//
//  PacksViewModel.swift
//  Often
//
//  Created by Katelyn Findlay on 3/28/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PacksViewModel: MediaItemsViewModel {
    var sectionPacks: [String: [MediaItem]]
    var sections: [String]
    
    init() {
        sectionPacks = [:]
        sections = []
        super.init(collectionType: .Packs)
        collectionEndpoint = baseRef.child("browse")
    }
    
    func generatePacksGroup() -> [MediaItemGroup] {
        
        var groups: [MediaItemGroup] = []
        
        for section in sections {
            if let packs = sectionPacks[section] as? [PackMediaItem] {
                let group = MediaItemGroup(dictionary: [
                    "id": section,
                    "title": section,
                    "type": "section"
                    ])
                group.items = packs
                    .filter { $0.published }
                    .filter { !$0.featured }
                    .sort { $0.publishedTime.compare($1.publishedTime) == .OrderedDescending }
                groups.append(group)
            }
        }
        
        return groups
    }
    
    override func generateMediaItemGroups() -> [MediaItemGroup] {
        if !sectionPacks.isEmpty {
            mediaItemGroups = generatePacksGroup()
            return mediaItemGroups
        }
        
        return []
    }
    
    override func fetchCollection(completion: ((Bool) -> Void)? = nil) {
        collectionEndpoint.observeEventType(.Value, withBlock: { snapshot in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                self.isDataLoaded = true
                if let data = snapshot.value as? [[String: AnyObject]] {
                    self.sectionPacks = self.processPackItemsCollectionData(data)
                }
                
                let mediaItemGroups = self.generateMediaItemGroups()
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.mediaLinksViewModelDidCreateMediaItemGroups(self, collectionType: .Packs, groups: mediaItemGroups)
                    completion?(true)
                }
            }
        })
    }
    
    func processPackItemsCollectionData(data: [[String: AnyObject]]) -> [String: [MediaItem]] {
        sections = []
        var links: [MediaItem] = []
        var filteredPacks: [String: [MediaItem]] = [:]
        
        for item in data {
            if let name = item["name"] as? String, packs = item["packs"] as? [String: AnyObject] {
                sections.append(name)
                links = []
                for (_, pack) in packs {
                    if let dict = pack as? NSDictionary, let link = MediaItem.mediaItemFromType(dict) {
                        links.append(link)
                    }
                }
                filteredPacks[name] = links
                mediaItems.appendContentsOf(links)
            }
        }
        
        return filteredPacks
    }
}
