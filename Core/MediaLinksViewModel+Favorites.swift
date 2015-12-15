//
//  MediaLinksViewModel+Favorites.swift
//  Often
//
//  Created by Luc Succes on 12/15/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

extension MediaLinksViewModel {
    func toggleFavorite(selected: Bool, result: MediaLink) {
        if selected {
            addFavorite(result)
        } else {
            removeFavorite(result)
        }
    }

    // TODO: add/remove favorite from local collection before server responds with data
    func addFavorite(result: MediaLink) {
        sendTask("addFavorite", result: result)
    }

    func removeFavorite(result: MediaLink) {
        sendTask("removeFavorite", result: result)
    }

    func checkFavorite(result: MediaLink) -> Bool {
        let base64URI = SearchRequest.idFromQuery(result.id)
            .stringByReplacingOccurrencesOfString("/", withString: "_")
            .stringByReplacingOccurrencesOfString("+", withString: "-")

        return ids.contains(base64URI)
    }

    private func sendTask(task: String, result: MediaLink) {
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