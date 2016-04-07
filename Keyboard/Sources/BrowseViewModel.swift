//
//  BrowseViewModel.swift
//  Often
//
//  Created by Luc Succes on 1/10/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

enum MediaItemFilter: Hashable, Equatable {
    case category(Category)

    var hashValue: Int {
        switch self {
        case .category(let category):
            return category.id.hashValue
        }
    }

    var type: String {
        switch self {
        case .category(_): return "category"
        }
    }
}

func ==(lhs: MediaItemFilter, rhs: MediaItemFilter) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class BrowseViewModel: MediaItemGroupViewModel {
    var filteredMediaItems: [MediaItem]
    var filters: [String: MediaItemFilter] = [:]
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

    func applyFilter(filter: MediaItemFilter) {
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
                guard let item = item as? MediaItem else {
                    continue
                }

                // Check for filters, if present applies them
                if shouldFilterMediaItem(item) {
                    continue
                }
                filteredMediaItems.append(item)
            }
        }

        return mediaItemGroups
    }

    private func shouldFilterMediaItem(item: MediaItem) -> Bool {
        for filter in filters.values {
            switch filter {
            case .category(let category):
                guard let itemCategory = item.category else {
                    if category.id == Category.all.id {
                        return false
                    }
                    return true
                }

                if category.id == Category.all.id {
                    return false
                }

                if itemCategory.id != category.id {
                    return true
                }
            }
        }
        
        return false
    }

}