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
import Alamofire

class PacksService: PackItemViewModel {
    static let defaultInstance = PacksService()
//    let userRef: FIRDatabaseReference
    let userId: String
    let didUpdatePacks = Event<[PackMediaItem]>()
    var mediaItems: [MediaItem]
    let collectionURL: String

//    internal var collectionEndpoint: FIRDatabaseReference
//    private var subscriptionsRef: FIRDatabaseReference!
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
//        userRef = FIRDatabase.database().reference().child("users/\(userId)")
//        collectionEndpoint = userRef.child("packs")

        collectionURL = "\(BaseURL)users/\(userId)/packs.json"


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

//        subscriptionsRef = userRef.child("subscriptions")
//        subscriptionsRef.observe(.value, with: self.onSubscriptionsChanged)
//        subscriptionsRef.keepSynced(true)
    }

     func fetchCollection(_ completion: ((Bool) -> Void)? = nil) {
//        collectionEndpoint.observe(.value, with: { snapshot in
//            DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosBackground).async {
//                self.isDataLoaded = true
//                if let data = snapshot.value as? [String: AnyObject] {
//                    self.mediaItems = self.processMediaItemsCollectionData(data)
//                }
//                DispatchQueue.main.async {
//                    completion?(true)
//                }
//            }
//        })

        Alamofire.request(.GET, collectionURL)
            .validate()
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization

                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    self.mediaItems = self.processMediaItemsCollectionData(JSON as! [String : AnyObject])
                    completion?(true)
                }
        }
    }

    func generatePacksGroup(_ items: [MediaItem]) -> [MediaItemGroup] {
        let group = MediaItemGroup(dictionary: [
            "id": "packs",
            "title": "Packs",
            "type": "pack"
        ])
        group.items = items

        return [group]
    }

    override func fetchData(_ completion: ((Bool) -> Void)? = nil) {
        fetchCollection { [weak self] done in
            if let packs = self?.mediaItems as? [PackMediaItem] {
                self?.populateCurrentPack()
                self?.didUpdatePacks.emit(packs)
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

    func addPack(_ pack: PackMediaItem) {
        sendTask("add", result: pack)

        FIRMessaging.messaging().subscribe(toTopic: "/topics/\(pack.id)")

        let currentInstallation = PFInstallation.current()
        currentInstallation.addUniqueObject("p\(pack.id)", forKey: "channels")
        currentInstallation.saveInBackground()
    }

    func removePack(_ pack: PackMediaItem) {
        sendTask("remove", result: pack)

        FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/\(pack.id)")

        let currentInstallation = PFInstallation.current()
        currentInstallation.remove("p\(pack.id)", forKey: "channels")
        currentInstallation.saveInBackground()
    }

    func checkPack(_ result: MediaItem) -> Bool {
        return ids.contains(result.id)
    }

    func getPackForId(_ packId: String) -> PackMediaItem? {
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

    func switchCurrentPack(_ packId: String)  {
        self.packId = packId
        SessionManagerFlags.defaultManagerFlags.lastPack = packId
        currentCategory = Category.all
        fetchData()
    }

    private func processMediaItemsCollectionData(_ data: [String: AnyObject]) -> [MediaItem] {
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

    private func sendTask(_ task: String, result: MediaItem) {
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
//        let ref = collectionEndpoint.child("\(result.id)")
//        if task == "add" {
//            ref.setValue(result.toDictionary())
//        } else if task == "remove" {
//            ref.removeValue()
//        }

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

    private func onSubscriptionsChanged(_ snapshot: FIRDataSnapshot!) {
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
