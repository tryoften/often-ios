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
    override var currentUser: User? {
        didSet {
            do {
                try fetchData()
            } catch _ {}
        }
    }

    private(set) var ids: [String] = []

    override func fetchData() throws {
        try fetchCollection(.Favorites, completion: { success in
            guard let collection = self.collections[.Favorites] else {
                return
            }

            self.ids = []
            for favorite in collection {
                self.ids.append(favorite.id)
            }
        })
    }

    func toggleFavorite(selected: Bool, result: MediaItem) {
        if selected {
            addFavorite(result)
        } else {
            removeFavorite(result)
        }
    }

    // TODO: add/remove favorite from local collection before server responds with data
    func addFavorite(result: MediaItem) {
        sendTask("addFavorite", result: result)
    }

    func removeFavorite(result: MediaItem) {
        sendTask("removeFavorite", result: result)
    }

    func checkFavorite(result: MediaItem) -> Bool {
        let base64URI = SearchRequest.idFromQuery(result.id)
            .stringByReplacingOccurrencesOfString("/", withString: "_")
            .stringByReplacingOccurrencesOfString("+", withString: "-")

        return ids.contains(base64URI)
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