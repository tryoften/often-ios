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
    var pack: PackMediaItem?
    
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
}