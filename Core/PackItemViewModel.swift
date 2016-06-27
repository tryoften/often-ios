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
//            ref = baseRef.child(byAppendingPath: "packs/\(packId)")
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

    init(packId: String) {
        self.packId = packId
        super.init(path: "packs/\(packId)")
    }
    
    override func fetchData(_ completion: ((Bool) -> Void)? = nil) {
//        ref.observe(.value, with: { snapshot in
//            if let data = snapshot.value as? NSDictionary {
//                self.pack = PackMediaItem(data: data)                
//                self.mediaItemGroups = self.pack!.getMediaItemGroups()
//                self.delegate?.mediaItemGroupViewModelDataDidLoad(self, groups: self.mediaItemGroups)
//                completion?(true)
//            }
//        })
    }

    func getMediaItemGroupForCurrentType() -> MediaItemGroup? {
        for group in mediaItemGroups {
            if group.type == typeFilter {
                return group
            }
        }
        return nil
    }

    func doesCurrentPackContainType(_ type: MediaType) -> Bool {
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

    func doesCurrentPackContainTypeForCategory(_ type: MediaType) -> Bool {
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

}
