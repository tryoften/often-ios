//
//  MediaItemsViewModel+Favorites.swift
//  Often
//
//  Created by Luc Succes on 12/15/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

extension MediaItemsViewModel {
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