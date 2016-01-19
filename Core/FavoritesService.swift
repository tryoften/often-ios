//
//  FavoritesService.swift
//  Often
//
//  Created by Luc Succes on 1/17/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import EmitterKit

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
        didChangeFavorites.emit([result])

        if selected {
            addFavorite(result)
        } else {
            removeFavorite(result)
        }
    }

    // TODO: add/remove favorite from local collection before server responds with data
    func addFavorite(result: MediaItem) {
        ids.insert(result.id)
        sendTask("addFavorite", result: result)
    }

    func removeFavorite(result: MediaItem) {
        ids.remove(result.id)
        sendTask("removeFavorite", result: result)
    }

    func checkFavorite(result: MediaItem) -> Bool {
        return ids.contains(result.id)
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
    }
}