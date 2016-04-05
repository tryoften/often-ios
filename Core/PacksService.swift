//
//  PacksService.swift
//  Often
//
//  Created by Luc Succes on 4/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation


class PacksService: UserMediaItemsViewModel {
    static let defaultInstance = PacksService()

    let didUpdatePacks = Event<[PackMediaItem]>()

    init() {
        super.init(collectionType: .Packs)
    }

    func generatePacksGroup(items: [MediaItem]) -> [MediaItemGroup] {
        let group = MediaItemGroup(dictionary: [
            "id": "packs",
            "title": "Packs",
            "type": "pack"
            ])
        group.items = items

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