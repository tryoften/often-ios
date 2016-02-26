//
//  FavoritesService.swift
//  Often
//
//  Created by Luc Succes on 1/17/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation


/// fetches favorites for current user and keeps them up to date
/// also has methods to add/remove favorites
class FavoritesService: MediaItemsViewModel {
    static let defaultInstance = FavoritesService()
    private(set) var ids: Set<String> = []
    
    let didChangeFavorites = Event<[MediaItem]>()
    
    override func fetchData() throws {
        try fetchCollection(.Favorites, completion: { success in
            if self.collections.isEmpty {
                return
            }
            
            self.ids = []
            for favorite in self.collections {
                self.ids.insert(favorite.id)
            }
            
            self.didChangeFavorites.emit(self.collections)
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
        delegate?.mediaLinksViewModelDidCreateMediaItemGroups(self, collectionType: .Favorites, groups: generateMediaItemGroups())
    }
    
    // TODO: add/remove favorite from local collection before server responds with data
    func addFavorite(result: MediaItem) {
        ids.insert(result.id)
        sendTask("addFavorite", result: result)
        
        Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.favorited), additionalProperties: AnalyticsAdditonalProperties.mediaItem(result.toDictionary()))
        
        collections.append(result)
    }
    
    func removeFavorite(result: MediaItem) {
        Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.unfavorited), additionalProperties: AnalyticsAdditonalProperties.mediaItem(result.toDictionary()))
        
        ids.remove(result.id)
        sendTask("removeFavorite", result: result)
        collections = collections.filter({ $0 != result })
    }
    
    func checkFavorite(result: MediaItem) -> Bool {
        return ids.contains(result.id)
    }
    
    override func generateMediaItemGroups() -> [MediaItemGroup] {
        if !collections.isEmpty {
            return generateFavoritesGroups(collections)
        }
        return []
    }
    
    func generateFavoritesGroups(items: [MediaItem]) -> [MediaItemGroup] {
        var groups: [MediaItemGroup] = []
        groups.append(generateRecentlyAddedFavoritesLyrics())
        groups.appendContentsOf(separateGroupByArtists(items))
        return groups
        
    }
    
    override func generateRecentlyAddedFavoritesLyrics() -> MediaItemGroup {
        
        let group = MediaItemGroup(dictionary: [
            "id": "recentlyAddedFavorites",
            "title": "Recently Added",
            "type": "lyric"
            ])
        
        let sortedGroup = collections.sort({ (l, r) in
            if let d1 = l.created, let d2 = r.created {
                return d1.compare(d2) == .OrderedDescending
            }
            return false
        })
        
        group.items = Array(sortedGroup[0..<10])
        
        return group
    }
    
    func separateGroupByArtists(items: [MediaItem]) -> [MediaItemGroup] {
        if mediaItems != items {
            mediaItems = items
            var groups: [String: MediaItemGroup] = [:]
            for item in items {
                guard let lyric = item as? LyricMediaItem,
                    let artistName = lyric.artist_name else {
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
            
            mediaItemGroups = groups.values.sort({ $0.title < $1.title })
            for group in mediaItemGroups {
                group.items = sortLyricsByTracks(group.items)
            }
            indexSectionHeaderTitles(mediaItemGroups)
        }
        return mediaItemGroups
    }
    
    func sortLyricsByTracks(group: [MediaItem]) -> [MediaItem] {
        var sortedTracks: [String: [MediaItem]] = [:]
        for item in group {
            if let lyric = item as? LyricMediaItem {
                if let _ = sortedTracks[lyric.track_title!] {
                    sortedTracks[lyric.track_title!]!.append(lyric)
                } else {
                    sortedTracks[lyric.track_title!] = [lyric]
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
    
    override func leftSectionHeaderTitle(index: Int) -> String {
        if index == 0 {
            return "Recently Added"
        } else {
            let group = generateMediaItemGroups()[index]
            if let artist = group.title {
                return artist
            }
            return ""
        }
    }
    
    override func rightSectionHeaderTitle(indexPath: NSIndexPath) -> String {
        var header = ""
        let group = generateMediaItemGroups()[indexPath.section]
        
        if indexPath.section == 0 {
            header = "\(group.items.count) lyrics"
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
    
    override func sectionHeaderImageURL(indexPath: NSIndexPath) -> NSURL? {
        if indexPath.section != 0 {
            let group = generateMediaItemGroups()[indexPath.section].items
            if !group.isEmpty {
                if let lyric = group.first as? LyricMediaItem, urlString = lyric.smallImage, let imageURL = NSURL(string: urlString) {
                    return imageURL
                }
            }
        }
        return nil
    }
    
    func indexSectionHeaderTitles(groups: [MediaItemGroup]) {
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