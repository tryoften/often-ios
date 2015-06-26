//
//  KeyboardService.swift
//  Drizzy
//
//  Created by Luc Success on 4/22/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import RealmSwift

let CurrentKeyboardUserDefaultsKey = "currentKeyboard"

/// Service that provides and manages keyboard models along with categories.
/// It stores the data both locally and remotely
class KeyboardService: Service {
    let userId: String
    var keyboardsRef: Firebase
    var keyboards: [Keyboard]
    var notificationToken: NotificationToken?
    var userDefaults: NSUserDefaults
    var currentKeyboardId: String? {
        didSet {
            userDefaults.setValue(currentKeyboardId, forKey: CurrentKeyboardUserDefaultsKey)
            userDefaults.synchronize()
        }
    }
    var artistService: ArtistService

    init(userId: String, root: Firebase, realm: Realm = Realm(), artistService: ArtistService = ArtistService(root: Firebase(url: BaseURL))) {
        self.userId = userId
        self.artistService = artistService
        
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        keyboardsRef = root.childByAppendingPath("users/\(userId)/keyboards")
        keyboards = [Keyboard]()

        super.init(root: root, realm: realm)
        currentKeyboardId = userDefaults.stringForKey(CurrentKeyboardUserDefaultsKey)
    }
    
    deinit {
        if let token = notificationToken {
            realm.removeNotification(token)
        }
    }
    
    func keyboardWithId(keyboardId: String) -> Keyboard? {
        let keyboard = keyboards.filter {$0.id == keyboardId}
        return keyboard.isEmpty ? nil : keyboard.first
    }
    
    /**
        Deletes a keyboard model with the given id
        
        :param: keyboardId the id of the keyboard to delete
        :param: completion callback when the delete operation has been successfully persisted on the backend
    */
    func deleteKeyboardWithId(keyboardId: String, completion: (NSError?) -> ()) {
        keyboards = keyboards.filter { return ($0.id == keyboardId) ? false : true }
        realm.beginWrite()
        if let keyboard = realm.objectForPrimaryKey(Keyboard.self, key: keyboardId),
            let artist = keyboard.artist {
            realm.delete(artist)
            realm.delete(keyboard)
        }
        realm.commitWrite()
        self.keyboardsRef.childByAppendingPath(keyboardId).removeValueWithCompletionBlock { (err, keyboardRef) in
            completion(nil)
        }
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
        keyboards = sorted(realm.objects(Keyboard)) {$0.artistName < $1.artistName}
        delegate?.serviceDataDidLoad(self)
        completion(true)
    }
    
    /**
    */
    func fetchDataForKeyboardIds(keyboardIds: [String], completion: ([Keyboard]) -> ()) {
        var index = 0
        var keyboardCount = keyboardIds.count
        var keyboardList = [Keyboard]()

        for keyboardId in keyboardIds {
            self.processKeyboardData(keyboardId, completion: { (keyboard, success) in
                keyboard.index = index++
                keyboardList.append(keyboard)
        
                if index + 1 >= keyboardCount {
                    self.keyboards = sorted(keyboardList) { $0.artistName < $1.artistName }

                    self.realm.write {
                        self.realm.add(self.keyboards, update: true)
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.delegate?.serviceDataDidLoad(self)
                        completion(self.keyboards)
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
    
    /**
        Fetches data from the local database first and notifies the delegate
        simultaneously, kicks off a request to the remote database and refreshes the data of the local one
        
        :param: completion callback that gets called when data has loaded
    */
    func requestData(completion: ([Keyboard]) -> Void) {
        fetchLocalData { success in
            if self.keyboards.isEmpty {
                self.fetchRemoteData { success in
                    completion(self.keyboards)
                }
            } else {
                completion(self.keyboards)
            }
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
                    
                    self.artistService.processArtistData(ownerId) { (artist, success) in
                        keyboard.artist = artist
                        keyboard.artistName = artist.name
                        
                        completion(keyboard, true)
                    }
                }
            }
        })
    }
    
    /**
    Processes categories data
    */
    private func processCategoriesData(keyboard: Keyboard, ownerId: String, data: [String: AnyObject]) {
        let categories = List<Category>()

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

protocol KeyboardServiceDelegate: ServiceDelegate {}
