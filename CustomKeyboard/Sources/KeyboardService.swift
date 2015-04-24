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
        self.keyboardsRef = root.childByAppendingPath("keyboards")
        self.root = root
        self.keyboards = [String: Keyboard]()
        super.init()
    }
    
    func requestData(completion: (Bool) -> Void) {
        keyboardsRef.observeEventType(.Value, withBlock: { (snapshot) -> Void in
            
//            println("\(snapshot.value)")
            if let keyboardsData = snapshot.value as? [String: AnyObject] {
                
                for (key, keyboardData) in keyboardsData {
                    let ownerId = keyboardData["owner"] as! String
                    let ownerURI = "owners/\(ownerId)"
                    var keyboard = Keyboard()
                    keyboard.id = key
                    keyboard.categories = self.createCategories(keyboardData["categories"] as! NSDictionary)
 
                    self.root.childByAppendingPath(ownerURI).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
                        println("\(snapshot.value)")
                        if let artistData = snapshot.value as? NSDictionary,
                            id = snapshot.key,
                            name = artistData["name"] as? String {
                                
                            var artist = Artist(id: id, name: id, imageURLSmall: nil, imageURLLarge: nil)
                            keyboard.artist = artist
                                

                                
                            self.keyboards[keyboard.id] = keyboard
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
            
            if let name = categoryData["name"] as? String,
            let lyricsData = categoryData["contents"] as? [String: String] {
                var lyrics = [Lyric]()
                
                for (lyricKey: String, lyricText: String) in lyricsData {
                    lyrics.append(Lyric(id: lyricKey, text: lyricText, categoryId: categoryKey, trackId: nil))
                }
            
                var category = Category(id: categoryKey, name: "Category", lyrics: lyrics)
                categories[category.id] = category
            }
        }

        return categories
    }
}
