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
    var notificationToken: NotificationToken?

    init(userId: String?, root: Firebase, realm: Realm = Realm()) {
        self.userId = userId
        
        if let userId = userId {
            keyboardsRef = root.childByAppendingPath("users/\(userId)/keyboards")
        } else {
            keyboardsRef = root.childByAppendingPath("keyboards")
        }
        
        keyboards = [String: Keyboard]()

        super.init(root: root, realm: realm)
    }
    
    deinit {
        if let token = notificationToken {
            realm.removeNotification(token)
        }
    }
    
    func deleteKeyboardWithId(keyboardId: String) {
        self.keyboardsRef.childByAppendingPath(keyboardId).removeValue()
    }
    
    /**
        Fetches data from the local database and creates models
        
        :param: completion callback that gets called when data has loaded
    */
    func fetchLocalData(completion: (Bool) -> Void) {
        // We have to create a new realm for reading on the main thread
        
        notificationToken = realm.addNotificationBlock { (notification, realm) in
            println("Realm DB changed: \(notification)")
        }
        
        createKeyboardModels(completion)
    }
    
    /**
        Creates keyboard models from the default realm
    */
    private func createKeyboardModels(completion: (Bool) -> Void) {
        let keyboards = realm.objects(Keyboard)
        for keyboard in keyboards {
            self.keyboards[keyboard.id] = keyboard
        }
        
        delegate?.serviceDataDidLoad(self)
        completion(true)
    }
    
    /**
    */
    func fetchDataForKeyboardIds(keyboardIds: [String], completion: ([Keyboard]) -> ()) {
        var index = 0
        var keyboardCount = keyboardIds.count

        for keyboardId in keyboardIds {
            self.processKeyboardData(keyboardId, completion: { (keyboard, success) in
                keyboard.index = index++
                self.keyboards[keyboard.id] = keyboard
                
                if index + 1 >= keyboardCount {
                    if let userId = self.userId {
                        self.realm.write {
                            self.realm.add(self.keyboards.values.array, update: true)
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.delegate?.serviceDataDidLoad(self)
                        completion(self.keyboards.values.array)
                    })
                }
            })
        }
    }

    /**
        Listens for changes on the server (firebase) database and updates
        the local (realm) database, then notifies the delegate and calls the completion callback
        
        :param: completion callback that gets called when data has loaded
    */
    override func fetchRemoteData(completion: (Bool) -> Void) {
        keyboardsRef.observeEventType(.Value, withBlock: { snapshot in
            if let keyboardsData = snapshot.value as? [String: AnyObject] {
                self.fetchDataForKeyboardIds(keyboardsData.keys.array, completion: { keyboards in
                    completion(true)
                })
            }
        }) { err in
            completion(false)
        }
    }

    override func fetchData() {
        
    }
    
    /**
        Fetches data from the local database first and notifies the delegate
        simultaneously, kicks off a request to the remote database and refreshes the data of the local one
        
        :param: completion callback that gets called when data has loaded
    */
    func requestData(completion: ([String: Keyboard]) -> Void) {
        fetchLocalData { success in
            completion(self.keyboards)
        }

        fetchRemoteData { success in
            
        }
    }
    
    /**
        Processes JSON keyboard data and creates models objects

        :param: keyboardId The id from the key/value store, the keyboard object ID
        :param: completion callback which gets called when keyboard objects are done being created
    */
    private func processKeyboardData(keyboardId: String, completion: (Keyboard, Bool) -> ()) {
        let keyboardRef = rootURL.childByAppendingPath("keyboards/\(keyboardId)")

        keyboardRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let keyboardData = snapshot.value as? [String: AnyObject] {
                var keyboard = Keyboard()
                keyboard.id = keyboardId
                
                
                if let ownerId = keyboardData["owner"] as? String {
                    if let categories = keyboardData["categories"] as? [String: AnyObject] {
                        self.processCategoriesData(keyboard, ownerId: ownerId, data: categories)
                    }
                    
                    self.processOwnerData(keyboard, ownerId: ownerId, completion: { success in
                        completion(keyboard, true)
                    })
                }
            }
        })
    }
    
    /** 
        Processes owner (artist) JSON data and adds it to the keyboard
        
        :param: keyboard The keyboard model the owner object will be set on
        :param: ownerId The owner ID
        :param: completion gets invoked when the owner object is fetched and created
    */
    private func processOwnerData(keyboard: Keyboard, ownerId: String, completion: (Bool) -> ()) {
        let ownerRef = rootURL.childByAppendingPath("owners/\(ownerId)")

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
    
    /**
    Processes categories data
    */
    private func processCategoriesData(keyboard: Keyboard, ownerId: String, data: [String: AnyObject]) {
        let categories = List<Category>()
        let realm = Realm()

        for (categoryKey, categoryData) in data {

            if  let count = categoryData["count"] as? Int,
                let name = categoryData["name"] as? String,
                let lyricsData = categoryData["contents"] as? [String: String] {
                var lyrics = List<Lyric>()
                
                for (lyricKey: String, lyricText: String) in lyricsData {
                    lyrics.append(Lyric(value: [
                        "id": lyricKey,
                        "text": lyricText,
                        "categoryId": categoryKey,
                        "artistId": ownerId,
                        "trackId": ""
                    ]))
                }

                var category = Category()
                category.id = categoryKey
                category.name = name
                category.lyrics = lyrics
                category.keyboard = keyboard
                categories.append(category)
            }
        }

        keyboard.categories.extend(categories)
    }
}

protocol KeyboardServiceDelegate: ServiceDelegate {
}
