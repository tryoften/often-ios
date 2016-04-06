//
//  PacksService.swift
//  Often
//
//  Created by Luc Succes on 4/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PacksService: UserMediaItemsViewModel {
    static let defaultInstance = PacksService()

    private var subscriptionsRef: Firebase!
    private var subscriptions: [PackSubscription] = []
    private(set) var ids: Set<String> = []

    let didUpdatePacks = Event<[PackMediaItem]>()

    init() {
        super.init(collectionType: .Packs)
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

    override func fetchCollection(completion: ((Bool) -> Void)? = nil) {
        collectionEndpoint.observeEventType(.Value, withBlock: { snapshot in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                self.isDataLoaded = true
                if let data = snapshot.value as? [String: AnyObject] {
                    self.mediaItems = self.processMediaItemsCollectionData(data)
                }
                dispatch_async(dispatch_get_main_queue()) {
                    completion?(true)
                    if let packs = self.mediaItems as? [PackMediaItem] {
                        self.didUpdatePacks.emit(packs)
                    }
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

    override func generateMediaItemGroups() -> [MediaItemGroup] {
        if !mediaItems.isEmpty {
            mediaItemGroups = generatePacksGroup(mediaItems)
            return mediaItemGroups
        }

        return []
    }

    func addPack(pack: PackMediaItem) {
        sendTask("addPack", result: pack)
    }

    func removePack(pack: PackMediaItem) {
        sendTask("removePack", result: pack)
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
            "task": task,
            "user": userId,
            "result": result.toDictionary()
        ])

        // Preemptively add item to collection before backend queue modifies
        // in case user worker is down
        let ref = collectionEndpoint.childByAppendingPath(result.id)
        if task == "addPack" {
            ref.setValue(result.toDictionary())
        } else if task == "removePack" {
            ref.removeValue()
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