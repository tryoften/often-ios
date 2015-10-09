//
//  SearchResultsViewModel.swift
//  Often
//
//  Created by Luc Succes on 9/29/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

class SearchResultsViewModel {
    
    let favoriteRef: Firebase
    let userId: String
    var favorites: [String]
    
    init?() {
        let baseRef = Firebase(url: BaseURL)
        let userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        favorites = []
        
        guard let userData = userDefaults.objectForKey("user") as? [String: String],
            let userId = userData["id"] else {
                self.userId = ""
                favoriteRef = Firebase()
            return nil
        }
        
        self.userId = userId
        favoriteRef = baseRef.childByAppendingPath("users/\(userId)/favorites")
        favoriteRef.keepSynced(true)
        getFavorites()
    }
    
    func toggleFavorite(selected: Bool, result: SearchResult) {
        if selected {
            addFavorite(result)
        } else {
            removeFavorite(result)
        }
    }
    
    func addFavorite(result: SearchResult) {
        sendTask("addFavorite", result: result)
    }
    
    func removeFavorite(result: SearchResult) {
        sendTask("removeFavorite", result: result)
    }
    
    func checkFavorite(result: SearchResult) -> Bool {
        let base64URI = SearchRequest.idFromQuery(result.id)
            .stringByReplacingOccurrencesOfString("/", withString: "_")
            .stringByReplacingOccurrencesOfString("+", withString: "-")
        
        return favorites.contains(base64URI)
    }
    
    func getFavorites() {
        favoriteRef.observeEventType(.Value, withBlock: { snapshot in
            
            if let data = snapshot.value as? [String: AnyObject] {
                var ids = [String]()
                
                for (id, _) in data {
                    ids.append(id)
                }
                
                self.favorites = ids
            }
            
        })
    }
    
    private func sendTask(task: String, result: SearchResult) {
        let favoriteQueueRef = Firebase(url: BaseURL).childByAppendingPath("queues/user/tasks").childByAutoId()
        favoriteQueueRef.setValue([
            "task": task,
            "user": userId,
            "result": result.toDictionary()
        ])
    }
}