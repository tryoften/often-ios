//
//  SearchResultsViewModel.swift
//  Often
//
//  Created by Luc Succes on 9/29/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

enum SearchResultsError: ErrorType {
    
}

class SearchResultsViewModel {
    
    let favoriteRef: Firebase?
    let userId: String
    
    init?() {
        let manager = SessionManager.defaultManager
        let baseRef = Firebase(url: BaseURL)
        
        guard let user = manager.currentUser else {
            return nil
        }
        
        userId = user.id
        favoriteRef = baseRef.childByAppendingPath("users/\(user.id)/favorites")
    }
    
    func addFavorite(result: SearchResult) {
        sendTask("askFavorite", result: result)
    }
    
    func removeFavorite(result: SearchResult) {
        sendTask("removeFavorite", result: result)
    }
    
    func getFavorites(callback: ([String]) -> ()) {
        favoriteRef?.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let data = snapshot.value as? [String: AnyObject] {
                var ids = [String]()
                
                for (id, _) in data {
                    ids.append(id)
                }
                
                callback(ids)
            }
            
        })
    }
    
    private func sendTask(task: String, result: SearchResult) {
        let favoriteQueueRef = Firebase(url: BaseURL).childByAppendingPath("queues/user/tasks").childByAutoId()
        favoriteQueueRef.setValue([
            "task": task,
            "user": "anon",
            "result": result.toDictionary()
        ])
    }
}
