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
            "id": "music",
            "title": "Music",
            "type": "pack"
            ])
        group.items = packs
            .filter { $0.published }
            .filter { !$0.featured }
            .sort { $0.publishedTime.compare($1.publishedTime) == .OrderedDescending }
        
        
        let group2 = MediaItemGroup(dictionary: [
            "id": "tv shows",
            "title": "TV Shows",
            "type": "pack"
            ])
        group2.items = group.items
        
        let group3 = MediaItemGroup(dictionary: [
            "id": "sports",
            "title": "Sports",
            "type": "pack"
            ])
        group3.items = group.items
        
        let group4 = MediaItemGroup(dictionary: [
            "id": "politics",
            "title": "Politics",
            "type": "pack"
            ])
        group4.items = group.items
        
        let group5 = MediaItemGroup(dictionary: [
            "id": "celebs",
            "title": "Celebs",
            "type": "pack"
            ])
        group5.items = group.items
        
        let group6 = MediaItemGroup(dictionary: [
            "id": "random",
            "title": "Random",
            "type": "pack"
            ])
        group6.items = group.items
        
        
        return [group, group2, group3, group4, group5, group6]
        
    }
    
    override func generateMediaItemGroups() -> [MediaItemGroup] {
        if !mediaItems.isEmpty {
            mediaItemGroups = generatePacksGroup(mediaItems)
            return mediaItemGroups
        }
        
        return []
    }
    
}
