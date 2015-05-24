//
//  KeyboardService.swift
//  Drizzy
//
//  Created by Luc Success on 4/22/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class KeyboardService: NSObject {
    var userId: String
    var keyboardsRef: Firebase
    var keyboards: [String: Keyboard]
    var root: Firebase

    init(userId: String, root: Firebase) {
        self.userId = userId
        self.keyboardsRef = root.childByAppendingPath("users/\(userId)/keyboards")
        self.root = root
        self.keyboards = [String: Keyboard]()
        super.init()
    }
    
    func deleteKeyboardWithId(keyboardId: String) {
        self.keyboardsRef.childByAppendingPath(keyboardId).removeValue()
    }
    
    func requestData(completion: ([String: Keyboard]) -> Void) {
        keyboardsRef.observeEventType(.Value, withBlock: { (snapshot) -> Void in
            
            if let keyboardsData = snapshot.value as? [String: AnyObject] {
                let keyboardCount = keyboardsData.count
                var index = 0
                
                for (key, val) in keyboardsData {
                    var keyboardRef = self.root.childByAppendingPath("keyboards/\(key)")
                    
                    keyboardRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        if let keyboardData = snapshot.value as? [String: AnyObject],
                            let ownerId = keyboardData["owner"] as? String {
                                let ownerURI = "owners/\(ownerId)"
                                var keyboard = Keyboard()
                                keyboard.id = key
                                
                                if let categories = keyboardData["categories"] as? NSDictionary {
                                    keyboard.categories = self.createCategories(categories)
                                    
                                    self.root.childByAppendingPath(ownerURI).observeSingleEventOfType(.Value, withBlock: { snapshot in
                                        println("\(snapshot.value)")
                                        if let artistData = snapshot.value as? NSDictionary,
                                            id = snapshot.key,
                                            name = artistData["name"] as? String {
                                                
                                                var urlSmall: String = (artistData["image_small"] ?? "") as! String
                                                var urlLarge: String = (artistData["image_large"] ?? "") as! String
                                                
                                                var artist = Artist(id: id, name: name, imageURLSmall: NSURL(string: urlSmall)!, imageURLLarge: NSURL(string: urlLarge)!)
                                                keyboard.artist = artist
                                                
                                                self.keyboards[keyboard.id] = keyboard
                                        }
                                        keyboard.index = index
                                        index++
                                        
                                        if index + 1 >= keyboardCount {
                                            completion(self.keyboards)
                                        }
                                    })
                                }
                        }

                    })
                    
                }
            }
            
        }) { (err) -> Void in
            
        }
    }
    
    func createCategories(data: NSDictionary) -> [String: Category] {
        var categories = [String: Category]()

        for (categoryKey, categoryData) in data as! [String: AnyObject] {

            if  let count = categoryData["count"] as? Int,
                let lyricsData = categoryData["contents"] as? [String: String] {
                var lyrics = [Lyric]()
                
                for (lyricKey: String, lyricText: String) in lyricsData {
                    lyrics.append(Lyric(id: lyricKey, text: lyricText, categoryId: categoryKey, trackId: nil))
                }
                
                var category = Category(id: categoryKey, name: categoryData["name"] as! String, lyrics: lyrics)

                categories[category.id] = category
            }
        }

        return categories
    }
}
