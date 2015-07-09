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
import Fabric
import Crashlytics

class KeyboardViewModel: NSObject, KeyboardServiceDelegate, ArtistPickerCollectionViewDataSource {
    var keyboardService: KeyboardService
    var delegate: KeyboardViewModelDelegate?
    var userDefaults: NSUserDefaults
    var hasSeenToolTips: Bool?
    var eventsRef: Firebase
    var user: User
    var keyboards: [Keyboard] {
        return keyboardService.sortedKeyboards
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
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        
        RLMRealm.setDefaultRealmSchemaVersion(1) { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(Keyboard.className(), block: { oldObject, newObject in
                    newObject["index"] = oldObject["index"]
                    
                })
            }
        }

        if !isFullAccessEnabled {
            //TODO(luc): check if that file exists, if it doesn't, use the bundled DB
            realmPath = directory.path!.stringByAppendingPathComponent("keyboard.realm")
            realm = Realm(path: realmPath, readOnly: true, encryptionKey: nil, error: nil)!
        } else {
            realm = Realm(path: realmPath)
        }
        
        RLMRealm.setDefaultRealmPath(realmPath)
        var configuration = SEGAnalyticsConfiguration(writeKey: AnalyticsWriteKey)
        SEGAnalytics.setupWithConfiguration(configuration)
        
        Fabric.with([Crashlytics()])

        if let userId = userDefaults.objectForKey("userId") as? String,
            let user = realm.objectForPrimaryKey(User.self, key: userId) {
                self.user = user
                SEGAnalytics.sharedAnalytics().identify(userId)
                keyboardService = KeyboardService(user: user,
                    root: root, realm: realm)
                var crashlytics = Crashlytics.sharedInstance()
                crashlytics.setUserIdentifier(userId)
                crashlytics.setUserName(user.username)
                crashlytics.setUserEmail(user.email)
        } else {
            // TODO(luc): get anonymous ID for the current session
            let user = User()
            user.id = "anon"
            self.user = user
            keyboardService = KeyboardService(user: user, root: Firebase(url: BaseURL), realm: realm)
        }
        SEGAnalytics.sharedAnalytics().screen("keyboard:loaded")

        eventsRef = root.childByAppendingPath("events/lyrics_inserted")
        userDefaults.setBool(true, forKey: "keyboardInstall")
        userDefaults.synchronize()

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
                SEGAnalytics.sharedAnalytics().identify(data.uid)
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
        let keyboards = keyboardService.sortedKeyboards
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
        
        eventsRef.childByAutoId().updateChildValues(data)
        SEGAnalytics.sharedAnalytics().track("keyboard:lyricSent", properties: data)
    }
}

protocol KeyboardViewModelDelegate {
    func keyboardViewModelDidLoadData(keyboardViewModel: KeyboardViewModel, data: [Keyboard])
    func keyboardViewModelCurrentKeyboardDidChange(keyboardViewModel: KeyboardViewModel, keyboard: Keyboard)
}