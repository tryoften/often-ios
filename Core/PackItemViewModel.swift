//
//  PackItemViewModel.swift
//  Often
//
//  Created by Katelyn Findlay on 4/14/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PackItemViewModel: BrowseViewModel {
    var packId: String {
        didSet {
            ref = baseRef.childByAppendingPath("packs/\(packId)")
        }
    }
    
    var pack: PackMediaItem? {
        didSet {
            if !doesCurrentPackContainType(self.typeFilter) {
                if let pack = self.pack, let availableType = pack.availableMediaType.keys.first {
                    typeFilter = availableType
                }
            }
        }
    }
    
    var typeFilter: MediaType = .Gif {
        didSet {
            delegate?.mediaItemGroupViewModelDataDidLoad(self, groups: self.mediaItemGroups)
        }
    }

    var isCurrentUser: Bool {
        guard let currentUserId = SessionManagerFlags.defaultManagerFlags.userId, let ownerId = pack?.owner?.id else {
            return false
        }

        return ownerId == currentUserId
    }

    init(userId: String? = nil, packId: String) {
        self.packId = packId
        super.init(userId: userId, path: "packs/\(packId)")
    }
    
    override func fetchData(completion: ((Bool) -> Void)? = nil) {
        ref.observeEventType(.Value, withBlock: { snapshot in
            if let data = snapshot.value as? NSDictionary {
                self.pack = PackMediaItem(data: data)                
                self.mediaItemGroups = self.pack!.getMediaItemGroups()
                self.delegate?.mediaItemGroupViewModelDataDidLoad(self, groups: self.mediaItemGroups)
                completion?(true)
            }
        })
    }

    func getMediaItemGroupForCurrentType() -> MediaItemGroup? {
        for group in mediaItemGroups {
            if group.type == typeFilter {
                return group
            }
        }
        return nil
    }

    func doesCurrentPackContainType(type: MediaType) -> Bool {
        guard let pack = pack, let _ = pack.availableMediaType[type] else {
            return false
        }
        return true
    }

    func showPushNotificationAlertForPack() -> Bool {
        SessionManagerFlags.defaultManagerFlags.pushNotificationShownCount += 1

        if !SessionManagerFlags.defaultManagerFlags.userNotificationSettings {
            if SessionManagerFlags.defaultManagerFlags.pushNotificationShownCount % 3 == 0 {
                SessionManagerFlags.defaultManagerFlags.pushNotificationShownCount = 0

                return true
            }
        }

        return false
    }

    func checkCurrentPackContents() {
        if !self.doesCurrentPackContainTypeForCategory(.Gif) {
            typeFilter = .Quote
        }

        if !self.doesCurrentPackContainTypeForCategory(.Quote) {
            typeFilter = .Gif
        }
    }

    func doesCurrentPackContainTypeForCategory(type: MediaType) -> Bool {
        for group in mediaItemGroups {
            if group.type == type {
                if group.items.isEmpty {
                    return false
                }
                return true
            }
        }
        return false
    }


    func saveChanges() {
        guard let pack = pack,
            name = pack.name,
            description = pack.description,
            backgroundColor = pack.backgroundColor else {
            return
        }

        ref.updateChildValues([
            "name": name,
            "description": description,
            "backgroundColor": backgroundColor.hexString
        ])

        triggerPackUpdate()
    }

    func updatePackProfileImage(image: ImageMediaItem) {
        guard let smallImage = image.smallImageURL?.absoluteString,
            largeImage = image.largeImageURL?.absoluteString else {
                return
        }

        let ref = baseRef.child("packs/\(packId)/image")
        ref.updateChildValues([
            "large_url": largeImage,
            "small_url": smallImage
        ])

        triggerPackUpdate()
    }

    func triggerPackUpdate() {
        guard let pack = pack else {
                return
        }

        let task = baseRef.child("queues/user/tasks").childByAutoId()
        task.setValue([
            "userId": userId,
            "type": "updatePack",
            "data": [
                "packId": pack.id
            ]
        ])
    }

}