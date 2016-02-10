//
//  FavoritesService.swift
//  Often
//
//  Created by Luc Succes on 1/17/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class FavoritesService: MediaItemsViewModel {
    static let defaultInstance = FavoritesService()
    private(set) var ids: Set<String> = []
    
    let didChangeFavorites = Event<[MediaItem]>()
    
    override func fetchData() throws {
        try fetchCollection(.Favorites, completion: { success in
            guard let collection = self.collections[.Favorites] else {
                return
            }
            
            self.ids = []
            for favorite in collection {
                self.ids.insert(favorite.id)
            }
            
            self.didChangeFavorites.emit(collection)
        })
    }
    
    override func didSetupUser() {
        do {
            try fetchData()
        } catch _ {}
    }
    
    func toggleFavorite(selected: Bool, result: MediaItem) {
        if selected {
            addFavorite(result)
        } else {
            removeFavorite(result)
        }

        didChangeFavorites.emit([result])
        delegate?.mediaLinksViewModelDidCreateMediaItemGroups(self, collectionType: .Favorites, groups: generateMediaItemGroupsForCollectionType(.Favorites))
    }
    
    // TODO: add/remove favorite from local collection before server responds with data
    func addFavorite(result: MediaItem) {
        ids.insert(result.id)
        sendTask("addFavorite", result: result)

        Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.favorited), additonalProperties: AnalyticsAdditonalProperties.mediaItem(result.toDictionary()))

        if var collection = collections[.Favorites] {
            collection.append(result)
            collections[.Favorites] = collection
        }
    }
    
    func removeFavorite(result: MediaItem) {
        Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.unfavorited), additonalProperties: AnalyticsAdditonalProperties.mediaItem(result.toDictionary()))

        ids.remove(result.id)
        sendTask("removeFavorite", result: result)
        collections[.Favorites] = collections[.Favorites]?.filter({ $0 != result })
    }
    
    func checkFavorite(result: MediaItem) -> Bool {
        return ids.contains(result.id)
    }
    
    override func sectionHeaderTitleForCollectionType(collectionType: MediaItemsCollectionType, isLeft: Bool, indexPath: NSIndexPath) -> String {
        var header: String = ""
        let groups = generateMediaItemGroupsForCollectionType(collectionType)

        guard indexPath.section < groups.count else {
            return header
        }

        let group = groups[indexPath.section]
        if isLeft {
            if let artist = group.title {
                header = artist
            }
        } else {
            if let lyric = group.items[indexPath.row] as? LyricMediaItem {
                if let track = lyric.track_title {
                    header = "\(track) | \(group.items.count) \(lyric.type.rawValue)"
                    if group.items.count > 1 {
                        header += "s"
                    }
                }
            }
        }
        return header
    }
    
    override func sectionHeaderImageURL(collectionType: MediaItemsCollectionType, index: Int) -> NSURL? {
        let group = mediaItemGroupItemsForIndex(index, collectionType: collectionType)
        if !group.isEmpty {
            if let lyric = group.first as? LyricMediaItem, urlString = lyric.smallImage, let imageURL = NSURL(string: urlString) {
                return imageURL
            }
        }
        return nil
    }
    
    private func sendTask(task: String, result: MediaItem) {
        guard let userId = currentUser?.id else {
            return
        }
        
        let favoriteQueueRef = Firebase(url: BaseURL).childByAppendingPath("queues/user/tasks").childByAutoId()
        favoriteQueueRef.setValue([
            "task": task,
            "user": userId,
            "result": result.toDictionary()
        ])

        // Preemptively add item to collection before backend queue modifies
        // in case user worker is down
        let ref = Firebase(url: BaseURL).childByAppendingPath("users/\(userId)/favorites/\(result.id)")
        if task == "addFavorite" {
            ref.setValue(result.toDictionary())
        } else if task == "removeFavorite" {
            ref.removeValue()
        }
    }

}