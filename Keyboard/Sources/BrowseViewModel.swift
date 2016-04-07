//
//  BrowseViewModel.swift
//  Often
//
//  Created by Luc Succes on 1/10/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class BrowseViewModel: MediaItemGroupViewModel {
    var filteredMediaItems: [MediaItem]
    var filters: [String: FavoritesFilter] = [:]
    var mediaItems: [MediaItem]
    let didChangeMediaItems = Event<[MediaItem]>()
    
    init(path: String = "trending") {
        filteredMediaItems = []
        mediaItems = []

        super.init(baseRef: Firebase(url: BaseURL), path: path)

    }

    func getArtistWithOftenId(oftenId: String, completion: (ArtistMediaItem) -> ()) {
        let artistRef = baseRef.childByAppendingPath("artists/\(oftenId)")
        artistRef.observeEventType(.Value, withBlock: { snapshot in
            guard let value = snapshot.value as? NSDictionary else {
                return
            }
            let artist = ArtistMediaItem(data: value)
            completion(artist)
        })
    }

    func getTrackWithOftenid(oftenId: String, completion: (TrackMediaItem) -> ()) {
        let trackRef = baseRef.childByAppendingPath("tracks/\(oftenId)")
        trackRef.observeEventType(.Value, withBlock: { snapshot in
            guard let value = snapshot.value as? NSDictionary else {
                return
            }
            let track = TrackMediaItem(data: value)
            completion(track)
        })
    }
    
    func getPackWithOftenId(oftenId: String, completion: (PackMediaItem) -> ()) {
        let packRef = baseRef.childByAppendingPath("packs/\(oftenId)")
        packRef.observeEventType(.Value, withBlock: { snapshot in
            guard let value = snapshot.value as? NSDictionary else {
                return
            }
            let pack = PackMediaItem(data: value)
            self.mediaItems = pack.items
            self.filteredMediaItems = pack.items
            print(self.filteredMediaItems.count)
            completion(pack)
        })
    }

    func applyFilter(filter: FavoritesFilter) {
        filteredMediaItems = []
        filters[filter.type] = filter
        generateMediaItemGroups()
        didChangeMediaItems.emit(self.mediaItems)
    }

    func generateMediaItemGroups() -> [MediaItemGroup] {
        if !mediaItems.isEmpty {
            return separateGroupByArtists(mediaItems)
        }
        return []
    }

    private func separateGroupByArtists(items: [MediaItem]) -> [MediaItemGroup] {
        if filteredMediaItems != items {

            for item in items {
                guard let lyric = item as? MediaItem else {
                        continue
                }

                // Check for filters, if present applies them
                if shouldFilterLyric(lyric) {
                    continue
                }

                 filteredMediaItems.append(lyric)

            }

        }

        return mediaItemGroups
    }

    private func shouldFilterLyric(lyric: MediaItem) -> Bool {
        for filter in filters.values {
            switch filter {
            case .artist(let artist):
                    return true
    
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

}