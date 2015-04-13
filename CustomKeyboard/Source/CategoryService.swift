//
//  CategoryService.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/15/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import BrightFutures
import UIKit

class CategoryService: NSObject {
    var artistId: String
    var root: Firebase
    var categoriesRef: Firebase
    var lyricsRef: Firebase
    var categories: [Category] = []
    var lyrics: [Lyric] = []
    var isDataLoaded: Bool = false
    
    init(artistId: String, root: Firebase) {
        self.artistId = artistId
        self.root = root
        self.categoriesRef = root.childByAppendingPath("categories")
        self.lyricsRef = root.childByAppendingPath("lyrics")

        super.init()
    }
    
    func observeNewCategories(snapshot: FDataSnapshot!) {
        if (!self.isDataLoaded) {
            return
        }
        let data = snapshot.value as! [String: String]
        var category = Category(id: data["id"]!, name: data["name"]!, lyrics: nil)
    }
    
    func categoryForId(categoryId: String) -> Category? {
        for category in categories {
            if category.id == categoryId {
                return category
            }
        }
        return nil
    }
    
    func requestCategories() -> Future<[Category]> {
        var promise = Promise<[Category]>()
        
        self.categories.append(RecentlyUsedCategory())
        
        categoriesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            let data = snapshot.value as! [ [String: String] ]
            
            for category in data {
                self.categories.append(Category(id: category["id"]!, name: category["name"]!, lyrics: nil))
            }
            
            self.isDataLoaded = true
            
            promise.success(self.categories)
        })
        
        return promise.future
    }
    
    func requestLyrics(categoryId: String, artistIds: [String]?) -> Future<[Lyric]> {
        var promise = Promise<[Lyric]>()
        
        var query = lyricsRef.childByAppendingPath("\(categoryId)")
        query.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let data = snapshot.value as? [String: [ [String : String] ]] {
                var lyrics = [Lyric]()
                
                for (key, lyricsData) in data {
                    for lyricData in lyricsData {
                        var lyric = Lyric(id: key, text: lyricData["text"]!, categoryId: lyricData["category_id"]!, trackId: lyricData["track_id"])
                        lyrics.append(lyric)
                    }
                }
                
                if let category = self.categoryForId(categoryId) {
                    category.lyrics = lyrics
                }
                
                promise.success(lyrics)
            } else {
                promise.failure(NSError())
            }
        })
        
        return promise.future
    }
    
    func requestData(completion: (Bool) -> Void) {
        self.requestCategories().andThen { result in
            var category = self.categories[1]
            var request = self.requestLyrics(category.id, artistIds: nil)
                
            request.onSuccess { data in
                completion(true)
            }
            
            request.onFailure { error in
                completion(false)
            }
        }
        
        // listen for any new categories added after the initial load
        categoriesRef.observeEventType(.ChildAdded, withBlock: self.observeNewCategories)
        
        
    }
}

protocol CategoryServiceDelegate {
    func categoryServiceDidLoad(service: CategoryService)
    func categoryServiceDidAddLyric(service: CategoryService, lyric: Lyric)
}
