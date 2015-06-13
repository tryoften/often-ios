//
//  KeyboardService.swift
//  Drizzy
//
//  Created by Luc Success on 4/22/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import RealmSwift

/// Service that provides and manages keyboard models along with categories.
/// It stores the data both locally and remotely
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

    func fetchLocalData(completion: (Bool) -> Void) {
        // We have to create a new realm for reading on the main thread
        var realm = Realm()
        
        realm.addNotificationBlock { (notification, realm) in
            
        }
        
        let keyboards = realm.objects(Keyboard)
        
        for keyboard in keyboards {
            self.keyboards[keyboard.id] = keyboard
        }
        
        delegate?.serviceDataDidLoad(self)
        completion(true)
    }

    /// Listens for changes on the server (firebase) database and updates
    /// the local (realm) database, then notifies the delegate and calls the completion callback
    func fetchRemoteData(completion: (Bool) -> Void) {
        keyboardsRef.observeEventType(.Value, withBlock: { (snapshot) -> Void in
            
            if let keyboardsData = snapshot.value as? [String: AnyObject] {
                let keyboardCount = keyboardsData.count
                var index = 0
                
                for (key, val) in keyboardsData {
                    self.processKeyboardData(key, data: val, completion: { (keyboard, success) in
                        keyboard.index = index++
                        self.keyboards[keyboard.id] = keyboard
                        
                        if index + 1 >= keyboardCount {
                            self.realm.write {
                                self.realm.add(self.keyboards.values.array, update: true)
                            }
                            dispatch_async(dispatch_get_main_queue(), {
                                self.delegate?.serviceDataDidLoad(self)
                                completion(true)
                            })
                        }
                    })
                }
            }
            
            }) { (err) -> Void in
                completion(false)
        }
    }

    override func fetchData() {
        
    }
    
    /// Fetches data from the local database first and notifies the delegate
    /// simultaneously, kicks off a request to the remote database and refreshes the data of the local one
    func requestData(completion: ([String: Keyboard]) -> Void) {
        fetchLocalData { success in
            completion(self.keyboards)
        }
    }
    
    /// Processes JSON keyboard data and creates models objects
    private func processKeyboardData(key: String, data: AnyObject, completion: (Keyboard, Bool) -> ()) {
        let keyboardRef = root.childByAppendingPath("keyboards/\(key)")

        keyboardRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            dispatch_async(self.writeQueue) {
                if let keyboardData = snapshot.value as? [String: AnyObject] {
                    var keyboard = Keyboard()
                    keyboard.id = key
                    
                    if let categories = keyboardData["categories"] as? [String: AnyObject] {
                        keyboard.categories.extend(self.processCategoriesData(categories))
                    }
                    
                    if let ownerId = keyboardData["owner"] as? String {
                        self.processOwnerData(keyboard, ownerId: ownerId, completion: { success in
                            completion(keyboard, true)
                        })
                    }
                }
            }
        })
    }
    
    /// Processes owner (artist) JSON data and adds it to the keyboard
    private func processOwnerData(keyboard: Keyboard, ownerId: String, completion: (Bool) -> ()) {
        let ownerRef = root.childByAppendingPath("owners/\(ownerId)")

        ownerRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let artistData = snapshot.value as? [String: AnyObject],
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
                    
                    completion(true)
            }
        })
    }
    
    /// Processes categories data
    private func processCategoriesData(data: [String: AnyObject]) -> List<Category> {
        let categories = List<Category>()

        for (categoryKey, categoryData) in data {

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
                categories.append(category)
            }
        }

        return categories
    }
}
