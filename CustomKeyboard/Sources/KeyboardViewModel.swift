//
//  KeyboardViewModel.swift
//  Drizzy
//
//  Created by Luc Success on 4/23/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class KeyboardViewModel: NSObject, KeyboardServiceDelegate, ArtistPickerCollectionViewDataSource {
    var keyboardService: KeyboardService
    var delegate: KeyboardViewModelDelegate?
    var userDefaults: NSUserDefaults
    var hasSeenToolTips: Bool?
    var eventsRef: Firebase
    var user: User
    var keyboards: [Keyboard] {
        return keyboardService.keyboards
    }
    var currentKeyboard: Keyboard? {
        didSet {
            if let currentKeyboard = currentKeyboard {
                delegate?.keyboardViewModelCurrentKeyboardDidChange(self, keyboard: currentKeyboard)
            }
        }
    }
    var realm: Realm
    var isFullAccessEnabled: Bool
    var hasSeenTooltip: Bool {
        get {
            return userDefaults.boolForKey("toolTips")
        }
        set(value) {
            userDefaults.setBool(value, forKey: "toolTips")
        }
    }
    
    override init() {
        
        isFullAccessEnabled = false
        
        let root = Firebase(url: BaseURL)
        let directory: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(AppSuiteName)!
        var realmPath = directory.path!.stringByAppendingPathComponent("db.realm")
        
        var fileManager = NSFileManager.defaultManager()
        isFullAccessEnabled = fileManager.isWritableFileAtPath(realmPath)
        
        if !isFullAccessEnabled {
            //TODO(luc): check if that file exists, if it doesn't, use the bundled DB
            realmPath = directory.path!.stringByAppendingPathComponent("keyboard.realm")
            realm = Realm(path: realmPath, readOnly: true, encryptionKey: nil, error: nil)!
            userDefaults = NSUserDefaults()
        } else {
            realm = Realm(path: realmPath)
            userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        }
        
        RLMRealm.setDefaultRealmPath(realmPath)
        

        if let userId = userDefaults.objectForKey("userId") as? String,
            let user = realm.objectForPrimaryKey(User.self, key: userId) {
            self.user = user
            keyboardService = KeyboardService(user: user,
                root: root, realm: realm)
        } else {
            // TODO(luc): get anonymous ID for the current session
            let user = User()
            user.id = "anon"
            self.user = user
            keyboardService = KeyboardService(user: user, root: Firebase(url: BaseURL), realm: realm)
        }
        
        eventsRef = root.childByAppendingPath("events/lyrics_inserted")

        super.init()
        if isFullAccessEnabled {
            authenticate()
        }
        keyboardService.delegate = self
    }
    
    func authenticate() {
        if let authData = userDefaults.objectForKey("authData") as? [String: String] {
            self.keyboardService.rootURL.authWithCustomToken(authData["token"], withCompletionBlock: { (error, data) -> Void in
                println(data)
            })
        } else {
            self.keyboardService.rootURL.authAnonymouslyWithCompletionBlock({ (err, data) -> Void in
                println(data)
            })
        }
    }
    
    func requestData(completion: ((Bool) -> ())? = nil) {
        self.keyboardService.requestData({ data in
            completion?(true)
        })
    }
    
    // MARK: KeyboardServiceDelegate
    func serviceDataDidLoad(service: Service) {
        let keyboards = keyboardService.keyboards
        if keyboards.count > 0 {
            if let lastKeyboardId = keyboardService.currentKeyboardId,
                lastKeyboard = keyboardService.keyboardWithId(lastKeyboardId) {
                currentKeyboard = lastKeyboard
            } else {
                currentKeyboard = keyboards.first
            }
            
            delegate?.keyboardViewModelCurrentKeyboardDidChange(self, keyboard: currentKeyboard!)
        }
        delegate?.keyboardViewModelDidLoadData(self, data: keyboards)
    }
    
    func artistsDidUpdate(artists: [Artist]) {
    
    }
    
    func lyricsDidUpdate(lyrics: [Lyric]) {
        
    }
    
    // MARK: ArtistPickerCollectionViewDataSource
    func numberOfItemsInArtistPicker(artistPicker: ArtistPickerCollectionViewController) -> Int {
        return keyboards.count
    }

    func artistPickerItemAtIndex(artistPicker: ArtistPickerCollectionViewController, index: Int) -> Keyboard? {
        if index < keyboards.count {
            return keyboards[index]
        }
        return nil
    }

    func artistPickerShouldHaveCloseButton(artistPicker: ArtistPickerCollectionViewController) -> Bool {
        return true
    }
    
    func artistPickerItemAtIndexIsSelected(artistPicker: ArtistPickerCollectionViewController, index: Int) -> Bool {
        if let currentKeyboardId = keyboardService.currentKeyboardId {
            var keyboard = keyboards[index]
            return keyboard.id == currentKeyboardId
        }
        return false
    }
    
    func logLyricInsertedEvent(lyric: Lyric) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        var data = [
            "lyric_id": lyric.id,
            "owner_id": lyric.artistId,
            "user_id": user.id,
            "timestamp": dateFormatter.stringFromDate(NSDate.new())
        ]

        eventsRef.childByAutoId().setValue(data)
        SEGAnalytics.sharedAnalytics().track("Lyric_Inserted", properties: data)
    }
}

protocol KeyboardViewModelDelegate {
    func keyboardViewModelDidLoadData(keyboardViewModel: KeyboardViewModel, data: [Keyboard])
    func keyboardViewModelCurrentKeyboardDidChange(keyboardViewModel: KeyboardViewModel, keyboard: Keyboard)
}