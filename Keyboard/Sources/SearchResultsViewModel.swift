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
    var fullAccessEnabled: Bool
    
    init?() {
        let baseRef = Firebase(url: BaseURL)
        favorites = []
        fullAccessEnabled = false
        
        guard let userId = SessionManagerFlags.defaultManagerFlags.userId else {
                self.userId = ""
                favoriteRef = Firebase()
            return nil
        }
        
        self.userId = userId
        favoriteRef = baseRef.childByAppendingPath("users/\(userId)/favorites")
        favoriteRef.keepSynced(true)
        getFavorites()
    }
    
    func toggleFavorite(selected: Bool, result: MediaItem) {
        if selected {
            addFavorite(result)
        } else {
            removeFavorite(result)
        }
    }
    
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
    
    private func sendTask(task: String, result: MediaItem) {
        let favoriteQueueRef = Firebase(url: BaseURL).childByAppendingPath("queues/user/tasks").childByAutoId()
        let data = [
            "task": task,
            "user": userId,
            "result": result.toDictionary()
        ]
        
        SEGAnalytics.sharedAnalytics().track(task, properties: data as [NSObject : AnyObject])
        favoriteQueueRef.setValue(data)
    }
    
    func isFullAccessEnabled() -> Bool {
        let pbWrapped: UIPasteboard? = UIPasteboard.generalPasteboard()
        if let _ = pbWrapped {
            fullAccessEnabled = true
            return true
        } else {
            fullAccessEnabled = false
            return false
        }
    }
}
