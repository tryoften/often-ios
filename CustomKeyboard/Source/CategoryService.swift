//
//  CategoryService.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/15/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import BrightFutures
import UIKit
import SwiftyJSON

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
        
        if !isDataLoaded {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                self.getDataFromDisk({
                    (success, error) in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        if success {
                            promise.success(self.categories)
                        } else {
                            promise.failure(error!)
                        }
                    })
                    
                })
            })
        } else {
            promise.success(self.categories)
        }
        
        var categories = [Category]()
        categories.append(RecentlyUsedCategory())
        
        categoriesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            let data = snapshot.value as! [ [String: String] ]
            
            for category in data {
                if let id = category["id"], name = category["name"] {
                    if let cachedCategory = self.categoryForId(id) {
                        categories.append(Category(id: id, name: name, lyrics: cachedCategory.lyrics))
                    } else {
                        categories.append(Category(id: id, name: name, lyrics: nil))
                    }
                }
            }
            
            self.isDataLoaded = true
            self.categories = categories

            promise.success(self.categories)
    
        }, withCancelBlock: { error in
            promise.success(self.categories)
        })
        
        return promise.future
    }
    
    func requestLyrics(categoryId: String, artistIds: [String]?) -> Future<[Lyric]> {
        var promise = Promise<[Lyric]>()
        
        if let category = self.categoryForId(categoryId) {
            promise.success(category.lyrics)
        }
        
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
                if let category = self.categoryForId(categoryId) {
                    promise.success(category.lyrics)
                } else {
                    promise.failure(NSError())
                }
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
    
    func getDataFromDisk(completion: (success: Bool, error: NSError?) -> ()) {
        if let urlPath = NSBundle.mainBundle().pathForResource("lyrics", ofType: "json"), data = NSData(contentsOfFile: urlPath) {
            var error: NSError?
            var json = JSON(data: data, options: nil, error: &error)
            
            if error != nil {
                completion(success: false, error: error)
                return
            }

            categories = [Category]()
            categories.append(RecentlyUsedCategory())

            if let categories = json["categories"].array {
                
                for category in categories {
                    var lyrics = [Lyric]()
                    
                    if let categoryId = category["id"].string,
                        categoryName = category["name"].string,
                        lyricsData = json["lyrics"][categoryId][artistId].array {

                        for lyricData in lyricsData {
                            if let id = lyricData["track_id"].string,
                                text = lyricData["text"].string,
                                categoryId = lyricData["category_id"].string,
                                trackId = lyricData["track_id"].string {
                            var lyric = Lyric(id: id, text: text, categoryId: categoryId, trackId: trackId)
                            lyrics.append(lyric)
                            }
                        }
                        self.categories.append(Category(id: categoryId, name: categoryName, lyrics: lyrics))
                    }
                }
                
                isDataLoaded = true
                completion(success: true, error: nil)
            }
        }
    }
}

protocol CategoryServiceDelegate {
    func categoryServiceDidLoad(service: CategoryService)
    func categoryServiceDidAddLyric(service: CategoryService, lyric: Lyric)
}
