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

    init(packId: String) {
        self.packId = packId
        super.init(path: "packs/\(packId)")
    }
    
    override func fetchData() {
        ref.observeEventType(.Value, withBlock: { snapshot in
            if let data = snapshot.value as? NSDictionary {
                self.pack = PackMediaItem(data: data)                
                self.mediaItemGroups = self.pack!.getMediaItemGroups()
                self.delegate?.mediaItemGroupViewModelDataDidLoad(self, groups: self.mediaItemGroups)
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

}