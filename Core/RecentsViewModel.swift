//
//  RecentsViewModel.swift
//  Often
//
//  Created by Luc Succes on 3/9/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

/// View Model for Recents
class RecentsViewModel: MediaItemsViewModel {
    init() {
        super.init(collectionType: .Recents)
    }

    func generateRecentsGroup(items: [MediaItem]) -> [MediaItemGroup] {
        let group = MediaItemGroup(dictionary: [
            "id": "recents",
            "title": sectionHeaderTitle(),
            "type": "lyric"
        ])

        group.items = items.sort({ (l, r) in
            if let d1 = l.created, let d2 = r.created {
                return d1.compare(d2) == .OrderedDescending
            }
            return false
        })

        return [group]
    }

    override func generateMediaItemGroups() -> [MediaItemGroup] {
        if !mediaItems.isEmpty {
            var groups: [MediaItemGroup] = []
            groups.append(FavoritesService.defaultInstance.generateRecentlyAddedFavoritesLyrics())
            groups.appendContentsOf(generateRecentsGroup(mediaItems))

            mediaItemGroups = groups

            return groups
        }

        return []
    }

    override func leftSectionHeaderTitle(index: Int) -> String {
        if index == 0 {
            return "Recently Favorited"
        }
        return super.leftSectionHeaderTitle(index)
    }


}