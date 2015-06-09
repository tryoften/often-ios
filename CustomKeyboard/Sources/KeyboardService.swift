//
//  KeyboardService.swift
//  Drizzy
//
//  Created by Luc Success on 4/22/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import RealmSwift

class KeyboardService: Service {
    var userId: String?
    var keyboardsRef: Firebase
    var keyboards: [String: Keyboard]

    init(userId: String?, root: Firebase, realm: Realm = Realm()) {
        self.userId = userId
        
        if let userId = userId {
            self.keyboardsRef = root.childByAppendingPath("users/\(userId)/keyboards")
        } else {
            self.keyboardsRef = root.childByAppendingPath("keyboards")
        }
        
        self.keyboards = [String: Keyboard]()
        
        super.init(root: root, realm: realm)
    }
    
    func deleteKeyboardWithId(keyboardId: String) {
        self.keyboardsRef.childByAppendingPath(keyboardId).removeValue()
    }
    
    override func getAllObjects() {
        
    }

    override func fetchLocalData() {
        realm.objects(Keyboard)
    }

    override func fetchRemoteData() {
        
    }

    override func fetchData() {
        
    }
    
    func requestData(completion: ([String: Keyboard]) -> Void) {
        dispatch_async(writeQueue) {
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
                                            if let artistData = (snapshot.value as? NSDictionary)!.mutableCopy() as? NSMutableDictionary,
                                                id = snapshot.key,
                                                name = artistData["name"] as? String {
                                                    var data = artistData
                                                    data["id"] = id
                                                    
                                                    var urlSmall: String = (artistData["image_small"] ?? "") as! String
                                                    var urlLarge: String = (artistData["image_large"] ?? "") as! String
                                                    
                                                    let artist = Artist(value: data)
                                                    artist.imageURLSmall = urlSmall
                                                    artist.imageURLLarge = urlLarge
                                                    
                                                    keyboard.artist = artist
                                                    
                                                    self.keyboards[keyboard.id] = keyboard
                                            }
                                            keyboard.index = index
                                            index++

                                            if index + 1 >= keyboardCount {
                                                self.realm.write {
                                                    self.realm.add(self.keyboards.values.array, update: true)
                                                }
                                                dispatch_async(dispatch_get_main_queue(), {
                                                    completion(self.keyboards)
                                                })
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
    }
    
    func createCategories(data: NSDictionary) -> [String: Category] {
        var categories = [String: Category]()

        for (categoryKey, categoryData) in data as! [String: AnyObject] {

            if  let count = categoryData["count"] as? Int,
                let name = categoryData["name"] as? String,
                let lyricsData = categoryData["contents"] as? [String: String] {
                var lyrics = [Lyric]()
                
                for (lyricKey: String, lyricText: String) in lyricsData {
                    lyrics.append(Lyric(value: [
                        "id": lyricKey,
                        "text": lyricText,
                        "categoryId": categoryKey,
                        "trackId": ""
                    ]))
                }
                
                var category = Category()
                category.id = categoryKey
                category.name = name
                category.lyrics.extend(lyrics)

                categories[category.id] = category
            }
        }

        return categories
    }
}
