//
//  PacksViewModel.swift
//  Often
//
//  Created by Katelyn Findlay on 3/28/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PacksViewModel: MediaItemsViewModel {
    init() {
        super.init(collectionType: .Packs)
    }
    
    func generatePacksGroup(items: [MediaItem]) -> [MediaItemGroup] {
        guard let packs = items as? [PackMediaItem] else {
            return [MediaItemGroup]()
        }

        let group = MediaItemGroup(dictionary: [
            "id": "packs",
            "title": "Packs",
            "type": "pack"
            ])
        group.items = packs
            .filter { $0.published }
            .sort { $0.publishedTime.compare($1.publishedTime) == .OrderedDescending }
        
        return [group]
    }
    
    override func generateMediaItemGroups() -> [MediaItemGroup] {
        if !mediaItems.isEmpty {
            mediaItemGroups = generatePacksGroup(mediaItems)
            return mediaItemGroups
        }
        
        return []
    }
    
}
