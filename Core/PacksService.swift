//
//  PacksService.swift
//  Often
//
//  Created by Luc Succes on 4/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PacksService: PackItemViewModel {
    static let defaultInstance = PacksService()
    let userRef: Firebase
    let userId: String

    var mediaItems: [MediaItem]
    var currentTypeFilter: MediaType?

    internal var collectionEndpoint: Firebase

    private var subscriptionsRef: Firebase!
    private var subscriptions: [PackSubscription] = []
    private(set) var ids: Set<String> = []

    let didUpdatePacks = Event<[PackMediaItem]>()

    init() {
        userId = SessionManagerFlags.defaultManagerFlags.userId!
        mediaItems = []
        userRef = Firebase(url: BaseURL).childByAppendingPath("users/\(userId)")
        collectionEndpoint = Firebase(url: BaseURL).childByAppendingPath("users/\(userId)/packs")

        super.init(packId: "")

        if let lastPack = SessionManagerFlags.defaultManagerFlags.lastPack {
            packId = lastPack
        }

        do {
            try setupUser { inner in
               }
        } catch _ {
        }

        subscriptionsRef = userRef.childByAppendingPath("subscriptions")
        subscriptionsRef.observeEventType(.Value, withBlock: self.onSubscriptionsChanged)
        subscriptionsRef.keepSynced(true)
        fetchCollection()
    }

    private func processMediaItemsCollectionData(data: [String: AnyObject]) -> [MediaItem] {
        var items: [PackMediaItem] = []
        ids.removeAll()

        for (id, item) in data {
            ids.insert(id)
            if let dict = item as? NSDictionary,
                let item = MediaItem.mediaItemFromType(dict) as? PackMediaItem {
                    items.append(item)
            }
        }

        return items
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
                    self.populateCurrentPack()
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

    override func fetchData() {
        if packId.isEmpty {
            fetchCollection({ completion in
                if completion {
                    super.fetchData()
                }
            })
        } else {
            super.fetchData()
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
    }

    func removePack(pack: PackMediaItem) {
        sendTask("remove", result: pack)
    }

    func checkPack(result: MediaItem) -> Bool {
        return ids.contains(result.id)
    }

    private func sendTask(task: String, result: MediaItem) {
        guard let userId = currentUser?.id else {
            return
        }

        let userQueue = Firebase(url: BaseURL).childByAppendingPath("queues/user/tasks").childByAutoId()
        userQueue.setValue([
            "task": "editUserSubscription",
            "operation": task,
            "user": userId,
            "packId": result.id,
            "result": result.toDictionary()
        ])

        // Preemptively add item to collection before backend queue modifies
        // in case user worker is down
        let ref = collectionEndpoint.childByAppendingPath("\(result.id)")
        if task == "add" {
            ref.setValue(result.toDictionary())
        } else if task == "remove" {
            ref.removeValue()
        }
    }

    func switchCurrentPack(packId: String)  {
        self.packId = packId
        SessionManagerFlags.defaultManagerFlags.lastPack = packId
        currentCategory = Category.all
        fetchData()
    }

    private func populateCurrentPack() {
        guard let packs = mediaItems as? [PackMediaItem], let packsID = packs.first?.pack_id  else {
            return
        }

        if SessionManagerFlags.defaultManagerFlags.lastPack == nil {
            SessionManagerFlags.defaultManagerFlags.lastPack = packsID
            
        }

        for pack in packs where SessionManagerFlags.defaultManagerFlags.lastPack == pack.pack_id {
            self.pack = pack
            self.didUpdatePacks.emit(packs)

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
        }

    }

    private func onSubscriptionsChanged(snapshot: FDataSnapshot!) {
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