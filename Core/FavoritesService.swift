//
//  FavoritesService.swift
//  Often
//
//  Created by Luc Succes on 1/17/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

enum FavoritesFilter: Hashable, Equatable {
    case category(Category)
    case artist(ArtistMediaItem)

    var hashValue: Int {
        switch self {
        case .category(let category):
            return category.id.hashValue
        case .artist(let artist):
            return artist.id.hashValue
        }
    }

    var type: String {
        switch self {
        case .category(_): return "category"
        case .artist(_): return "artist"
        }
    }
}

func ==(lhs: FavoritesFilter, rhs: FavoritesFilter) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

/// fetches favorites for current user and keeps them up to date
/// also has methods to add/remove favorites
class FavoritesService: MediaItemsViewModel {
    static let defaultInstance = FavoritesService()
    private(set) var ids: Set<String> = []

    var filters: [String: FavoritesFilter] = [:]
    let didChangeFavorites = Event<[MediaItem]>()

    override func fetchData() throws {
        try fetchCollection(.Favorites, completion: { success in
            if self.mediaItems.isEmpty {
                return
            }
            
            self.ids = []
            for favorite in self.mediaItems {
                self.ids.insert(favorite.id)
            }
            
            self.didChangeFavorites.emit(self.mediaItems)
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
        delegate?.mediaLinksViewModelDidCreateMediaItemGroups(self, collectionType: .Favorites, groups: mediaItemGroups)
    }

    func addFavorite(result: MediaItem) {
        ids.insert(result.id)
        sendTask("addFavorite", result: result)
        
        Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.favorited), additionalProperties: AnalyticsAdditonalProperties.mediaItem(result.toDictionary()))
        
        mediaItems.append(result)
    }
    
    func removeFavorite(result: MediaItem) {
        Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.unfavorited), additionalProperties: AnalyticsAdditonalProperties.mediaItem(result.toDictionary()))
        
        ids.remove(result.id)
        sendTask("removeFavorite", result: result)
        mediaItems = mediaItems.filter({ $0 != result })
    }
    
    func checkFavorite(result: MediaItem) -> Bool {
        return ids.contains(result.id)
    }

    func applyFilter(filter: FavoritesFilter) {
        filteredMediaItems = []
        filters[filter.type] = filter
        generateMediaItemGroups()
        didChangeFavorites.emit(self.mediaItems)
    }

    override func generateMediaItemGroups() -> [MediaItemGroup] {
        if !mediaItems.isEmpty {
            return separateGroupByArtists(mediaItems)
        }
        return []
    }


    override func leftSectionHeaderTitle(index: Int) -> String {
        if index >= mediaItemGroups.count {
            return ""
        }

        let group = mediaItemGroups[index]

        if let artist = group.title {
            return artist
        }

        return ""
    }

    override func rightSectionHeaderTitle(indexPath: NSIndexPath) -> String {
        if indexPath.section >= mediaItemGroups.count {
            return ""
        }

        let group = mediaItemGroups[indexPath.section]
        return "\(group.items.count) lyrics"
    }

    override func sectionHeaderImageURL(indexPath: NSIndexPath) -> NSURL? {
        let groups = mediaItemGroups

        if indexPath.section >= groups.count {
            return nil
        }

        let group = groups[indexPath.section]
        if !group.items.isEmpty {
            if let lyric = group.items.first as? LyricMediaItem {
                return lyric.smallImageURL
            }
        }

        return nil
    }

    func generateRecentlyAddedFavoritesLyrics() -> MediaItemGroup {
        let group = MediaItemGroup(dictionary: [
            "id": "recentlyAddedFavorites",
            "title": "Recently Added",
            "type": "lyric"
        ])

        let sortedGroup = mediaItems.sort({ (l, r) in
            if let d1 = l.created, let d2 = r.created {
                return d1.compare(d2) == .OrderedDescending
            }
            return false
        })

        group.items = sortedGroup.count > 10 ? Array(sortedGroup[0..<10]) : sortedGroup

        return group
    }

    // MARK: Private Methods
    private func shouldFilterLyric(lyric: LyricMediaItem) -> Bool {
        for filter in filters.values {
            switch filter {
            case .artist(let artist):
                if lyric.artist_id != artist.id {
                    return true
                }
            case .category(let category):
                guard let lyricCategory = lyric.category else {
                    if category.id == Category.all.id {
                        return false
                    }
                    return true
                }

                if category.id == Category.all.id {
                    return false
                }

                if lyricCategory.id != category.id {
                    return true
                }
            }
        }

        return false
    }

    private func separateGroupByArtists(items: [MediaItem]) -> [MediaItemGroup] {
        if filteredMediaItems != items {
            filteredMediaItems = items
            var groups: [String: MediaItemGroup] = [:]

            for item in items {
                guard let lyric = item as? LyricMediaItem,
                    let artistName = lyric.artist_name else {
                        continue
                }

                // Check for filters, if present applies them
                if shouldFilterLyric(lyric) {
                    continue
                }
                
                if let _ = groups[artistName] {
                    groups[artistName]!.items.append(item)
                } else {
                    let group = MediaItemGroup(dictionary: [
                        "title": artistName,
                    ])
                    group.items = [item]
                    groups[artistName] = group
                }
            }

            for group in mediaItemGroups {
                group.items = sortLyricsByTracks(group.items)
            }
            indexSectionHeaderTitles(mediaItemGroups)
            mediaItemGroups = groups.values.sort({ $0.title < $1.title })            
        }

        return mediaItemGroups
    }
    
    private func sortLyricsByTracks(group: [MediaItem]) -> [MediaItem] {
        var sortedTracks: [String: [MediaItem]] = [:]
        for item in group {
            if let lyric = item as? LyricMediaItem, let title = lyric.track_title {
                if let _ = sortedTracks[title] {
                    sortedTracks[title]!.append(lyric)
                } else {
                    sortedTracks[title] = [lyric]
                }
            }
        }
        var keys: [String] = []
        for key in sortedTracks.keys {
            if let tracks = sortedTracks[key] as? [LyricMediaItem] {
                sortedTracks[key] = tracks.sort({ $0.index < $1.index })
            }
            keys.append(key)
        }
        let sortedKeys = keys.sort({$0 < $1})
        
        var sortedGroup: [MediaItem] = []
        for key in sortedKeys {
            if let tracks = sortedTracks[key] {
                sortedGroup.appendContentsOf(tracks)
            }
        }
        
        return sortedGroup
    }
    
    private func indexSectionHeaderTitles(groups: [MediaItemGroup]) {
        sectionIndex = [:]
        
        for indexTitle in AlphabeticalSidebarIndexTitles {
            sectionIndex[indexTitle] = nil
        }
        
        for i in 0..<groups.count {
            guard let artistLyric = groups[i].items.first as? LyricMediaItem, let character = artistLyric.artist_name?.characters.first else {
                return
            }
            
            let letterChar = Letter(rawValue: character)
            let numberChar = Digit(rawValue: character)
            
            if let char = letterChar {
                if sectionIndex[String(char)] == nil {
                    sectionIndex[String(char)] = i
                }
            }
            
            if let _ = numberChar {
                if sectionIndex["#"] == nil {
                    sectionIndex["#"] = i
                }
            }
            
        }
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