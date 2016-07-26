//
//  PacksService.swift
//  Often
//
//  Created by Luc Succes on 4/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Firebase
import FirebaseMessaging
import FirebaseInstanceID


class PacksService: PackItemViewModel {
    static let defaultInstance = PacksService()
    let userRef: FIRDatabaseReference
    let userId: String
    let didUpdatePacks = Event<[PackMediaItem]>()
    var mediaItems: [MediaItem]

    internal var collectionEndpoint: FIRDatabaseReference
    private var subscriptionsRef: FIRDatabaseReference!
    private var subscriptions: [PackSubscription] = []
    private(set) var ids: Set<String> = []
    private(set) var recentsPack: PackMediaItem?
    private(set) var favoritesPack: PackMediaItem?

    override var typeFilter: MediaType {
        didSet {
            SessionManagerFlags.defaultManagerFlags.lastFilterType = typeFilter.rawValue
            delegate?.mediaItemGroupViewModelDataDidLoad(self, groups: self.mediaItemGroups)
        }
    }

    init() {
        if let userId = SessionManagerFlags.defaultManagerFlags.userId {
            self.userId = userId
        } else {
            self.userId = "default"
        }
        
        mediaItems = []
        userRef = FIRDatabase.database().reference().child("users/\(userId)")
        collectionEndpoint = userRef.child("packs")

        super.init(packId: "")

        if let lastPack = SessionManagerFlags.defaultManagerFlags.lastPack {
            packId = lastPack
        }

        if let lastFilterType = SessionManagerFlags.defaultManagerFlags.lastFilterType,
            let type = MediaType(rawValue: lastFilterType) {
            typeFilter = type
        }

        currentCategory = Category.all

        do {
            try setupUser { inner in
               }
        } catch _ {
        }

        subscriptionsRef = userRef.childByAppendingPath("subscriptions")
        subscriptionsRef.observeEventType(.Value, withBlock: self.onSubscriptionsChanged)
        subscriptionsRef.keepSynced(true)
    }

     func fetchCollection(completion: ((Bool) -> Void)? = nil) {
        collectionEndpoint.observeEventType(.Value, withBlock: { snapshot in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                self.isDataLoaded = true
                if let data = snapshot.value as? [String: AnyObject] {
                    self.mediaItems = self.processMediaItemsCollectionData(data)
                }
                dispatch_async(dispatch_get_main_queue()) {
                    completion?(true)
                }
            }
        })
    }

    func generatePacksGroup(items: [MediaItem]) -> [MediaItemGroup] {
        let group = MediaItemGroup(dictionary: [
            "id": "packs",
            "title": "Packs",
            "type": "pack"
        ])
        group.items = items

        return [group]
    }

    override func fetchData(completion: ((Bool) -> Void)? = nil) {
        fetchCollection { [weak self] done in
            if let packs = self?.mediaItems as? [PackMediaItem] {
                self?.populateCurrentPack()
                self?.didUpdatePacks.emit(packs)
            }
        }
    }

    func fetchLocalData(completion: ((Bool) -> Void)? = nil) {
        if let path = NSBundle.mainBundle().pathForResource("djkhaledpack", ofType: "json") {
            do {
                let jsonData =  try NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
                if let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    self.isDataLoaded = true
                    let pack = PackMediaItem(data: jsonResult)
                    self.mediaItems = [pack]
                    if let packs = mediaItems as? [PackMediaItem] {
                        populateCurrentPack()
                        didUpdatePacks.emit(packs)
                    }
                }
            } catch _{

            }

        }
    }

    func generateMediaItemGroups() -> [MediaItemGroup] {
        if !mediaItems.isEmpty {
            mediaItemGroups = generatePacksGroup(mediaItems)
            return mediaItemGroups
        }

        return []
    }

    func addPack(pack: PackMediaItem) {
        sendTask("add", result: pack)

        FIRMessaging.messaging().subscribeToTopic("/topics/\(pack.id)")

        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.addUniqueObject("p\(pack.id)", forKey: "channels")
        currentInstallation.saveInBackground()
    }

    func addToGlobalPushNotifications() {
        FIRMessaging.messaging().subscribeToTopic("/topics/global")

        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.addUniqueObject("pglobal", forKey: "channels")
        currentInstallation.saveInBackground()
    }

    func removeFromGlobalPushNotifications() {
        FIRMessaging.messaging().unsubscribeFromTopic("/topics/global")

        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.removeObject("pglobal", forKey: "channels")
        currentInstallation.saveInBackground()
    }

    func removePack(pack: PackMediaItem) {
        sendTask("remove", result: pack)

        FIRMessaging.messaging().unsubscribeFromTopic("/topics/\(pack.id)")

        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.removeObject("p\(pack.id)", forKey: "channels")
        currentInstallation.saveInBackground()
    }

    func checkPack(result: MediaItem) -> Bool {
        return ids.contains(result.id)
    }

    func getPackForId(packId: String) -> PackMediaItem? {
        guard let packs = mediaItems as? [PackMediaItem] else {
            return nil
        }

        if recentsPack?.id == packId {
            return recentsPack
        }

        if favoritesPack?.id == packId {
            return favoritesPack
        }

        for pack in packs where packId == pack.pack_id {
            return pack
        }

        return nil
    }

    func switchCurrentPack(packId: String)  {
        self.packId = packId
        SessionManagerFlags.defaultManagerFlags.lastPack = packId
        currentCategory = Category.all
        fetchData()
    }

    private func processMediaItemsCollectionData(data: [String: AnyObject]) -> [MediaItem] {
        var items: [PackMediaItem] = []
        ids.removeAll()

        for (id, item) in data {
            ids.insert(id)
            if let dict = item as? NSDictionary, let item = MediaItem.mediaItemFromType(dict) as? PackMediaItem {
                if item.isRecents {
                    recentsPack = item
                } else if item.isFavorites {
                    favoritesPack = item
                } else {
                    items.append(item)
                }
            }
        }

        return items
    }

    private func sendTask(task: String, result: MediaItem) {
        guard let userId = currentUser?.id else {
            return
        }

        let userQueue = FIRDatabase.database().reference().child("queues/user/tasks").childByAutoId()
        userQueue.setValue([
            "type": "editPackSubscription",
            "userId": userId,
            "data": [
                "packId": result.id,
                "operation": task
            ],
            "result": result.toDictionary()
        ])

        // Preemptively add item to collection before backend queue modifies
        // in case user worker is down
        let ref = collectionEndpoint.child("\(result.id)")
        if task == "add" {
            ref.setValue(result.toDictionary())
        } else if task == "remove" {
            ref.removeValue()
        }

        fetchData()
    }

    private func populateCurrentPack() {
        guard let packs = mediaItems as? [PackMediaItem], let packsID = packs.first?.pack_id  else {
            return
        }
        
        if SessionManagerFlags.defaultManagerFlags.lastPack == nil {
            SessionManagerFlags.defaultManagerFlags.lastPack = packsID
        }

        if let currentPackId = SessionManagerFlags.defaultManagerFlags.lastPack, let pack = getPackForId(currentPackId) {
            self.pack = pack
            self.mediaItemGroups = pack.getMediaItemGroups()

            if let packId = pack.pack_id {
                self.packId = packId
            }

            if SessionManagerFlags.defaultManagerFlags.lastCategoryIndex < pack.categories.count {
                currentCategory = pack.categories[SessionManagerFlags.defaultManagerFlags.lastCategoryIndex]
            } else {
                currentCategory = pack.categories.first
                SessionManagerFlags.defaultManagerFlags.lastCategoryIndex = 0
            }

            if let currentCategory = currentCategory {
                applyFilter(currentCategory)
            }

            self.delegate?.mediaItemGroupViewModelDataDidLoad(self, groups: self.mediaItemGroups)
        }

    }

    private func onSubscriptionsChanged(snapshot: FIRDataSnapshot!) {
        var subscriptions = [PackSubscription]()
        if let data = snapshot.value as? [String: AnyObject] {
            for (_, item) in data {
                if let item = item as? NSDictionary {
                    subscriptions.append(PackSubscription(data: item))
                }
            }

        }
    }

}