//
//  SessionManagerFlags.swift
//  Often
//
//  Created by Kervins Valcourt on 11/30/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class SessionManagerFlags {
    static let defaultManagerFlags = SessionManagerFlags()
    
    private var userDefaults: NSUserDefaults
    
    struct SessionManagerPropertyKey {
        static var userID = "userID"
        static var userEmail = "email"
        static var messageSentCount = "messageSentCount"
        static var openSession = "openSession"
        static var keyboardOpen = "keyboardOpen"
        static var anonymousUser = "anonymousUser"
        static var keyboardGeneralToolTips = "keyboardGeneralToolTips"
        static var keyboardSearchBarToolTips = "searchBarTool"
        static var keyboardInstallWalkthrough = "keyboardInstallWalkthrough"
        static var userNotificationSettings = "userNotificationSettings"
        static var userHasSeenPushNotificationView = "userHasSeenPushNotificationView"
        static var pushNotificationShownCount = "pushNotificationShownCount"
        static var lastPack = "pack"
        static var lastCategory = "category"
        static var lastFilterType = "filter"
        static var userHasUsername = "userHasUsername"
    }

    var userNotificationSettings: Bool {
        get {
            return userDefaults.boolForKey(SessionManagerPropertyKey.userNotificationSettings)
        }

        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.userNotificationSettings)
        }
    }
    
    var hasSeenKeyboardGeneralToolTips: Bool {
        get {
            return userDefaults.boolForKey(SessionManagerPropertyKey.keyboardGeneralToolTips)
        }
        
        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.keyboardGeneralToolTips)
        }
    }
    
    var hasSeenKeyboardSearchBarToolTips: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(SessionManagerPropertyKey.keyboardSearchBarToolTips)
        }
        
        set(value) {
            NSUserDefaults.standardUserDefaults().setBool(value, forKey: SessionManagerPropertyKey.keyboardSearchBarToolTips)
        }
    }
    
    var userHasOpenedKeyboard: Bool {
        get {
            return userDefaults.boolForKey(SessionManagerPropertyKey.keyboardOpen)
        }
        
        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.keyboardOpen)
        }
    }

    var userSeenKeyboardInstallWalkthrough: Bool {
        get {
            return userDefaults.boolForKey(SessionManagerPropertyKey.keyboardInstallWalkthrough)
        }

        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.keyboardInstallWalkthrough)
        }
    }
    
    var userMessageCount: Int {
        get {
            return userDefaults.integerForKey(SessionManagerPropertyKey.messageSentCount)
        }
        
        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.messageSentCount)
        }
    }

    var userHasSeenPushNotificationView: Bool {
        get {
            return userDefaults.boolForKey(SessionManagerPropertyKey.userHasSeenPushNotificationView)
        }

        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.userHasSeenPushNotificationView)
        }
    }
    
    var userHasUsername: Bool {
        get {
            return userDefaults.boolForKey(SessionManagerPropertyKey.userHasUsername)
        }
        
        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.userHasUsername)
        }
    }

    var pushNotificationShownCount: Int {
        get {
            return userDefaults.integerForKey(SessionManagerPropertyKey.pushNotificationShownCount)
        }

        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.pushNotificationShownCount)
        }
    }

    
    var isKeyboardInstalled: Bool {
        get {
            guard let keyboards = NSUserDefaults.standardUserDefaults().dictionaryRepresentation()["AppleKeyboards"] as? [String] else {
                return false
            }
            
            if !keyboards.contains(KeyboardIdentifier) {
                return false
            } else {
                return true
            }
        }
    }
    
    var openSession: Bool {
        get {
            return userDefaults.boolForKey(SessionManagerPropertyKey.openSession)
        }
        
        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.openSession)
        }
    }
    
    var userId: String? {
        get {
            return userDefaults.stringForKey(SessionManagerPropertyKey.userID)
        }
        
        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.userID)
        }
    }

    var lastPack: String? {
        get {
            return  NSUserDefaults.standardUserDefaults().objectForKey(SessionManagerPropertyKey.lastPack) as? String
        }

        set(value) {
             NSUserDefaults.standardUserDefaults().setObject(value, forKey: SessionManagerPropertyKey.lastPack)
        }
    }

    var lastFilterType: String? {
        get {
            return  NSUserDefaults.standardUserDefaults().objectForKey(SessionManagerPropertyKey.lastFilterType) as? String
        }

        set(value) {
            NSUserDefaults.standardUserDefaults().setObject(value, forKey: SessionManagerPropertyKey.lastFilterType)
        }
    }

    var lastCategoryIndex: Int {
        get {
            return  NSUserDefaults.standardUserDefaults().integerForKey(SessionManagerPropertyKey.lastCategory)
        }

        set(value) {
            NSUserDefaults.standardUserDefaults().setInteger(value, forKey: SessionManagerPropertyKey.lastCategory)
        }
    }
    
    var userIsAnonymous: Bool {
        get {
            return userDefaults.boolForKey(SessionManagerPropertyKey.anonymousUser)
        }
        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.anonymousUser)
        }
    }
    
    var isUserLoggedIn: Bool {
        return userId != nil
    }
    
    init() {
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
    }
    
    func setValueToUserDefaults(value: AnyObject?, forKey: String) {
        userDefaults.setValue(value, forKey: forKey)
        userDefaults.synchronize()
    }
    
    func clearSessionFlags() {
        userDefaults.setValue(nil, forKey: SessionManagerPropertyKey.userID)
        userDefaults.setValue(nil, forKey: SessionManagerPropertyKey.userEmail)
        userDefaults.setValue(nil, forKey: SessionManagerPropertyKey.messageSentCount)
        userDefaults.setValue(nil, forKey: SessionManagerPropertyKey.openSession)
        userDefaults.setValue(nil, forKey: SessionManagerPropertyKey.keyboardOpen)
        userDefaults.setValue(nil, forKey: SessionManagerPropertyKey.anonymousUser)
        userDefaults.setValue(nil, forKey: SessionManagerPropertyKey.keyboardGeneralToolTips)
        userDefaults.setValue(nil, forKey: SessionManagerPropertyKey.keyboardSearchBarToolTips)
        userDefaults.setValue(nil, forKey: SessionManagerPropertyKey.keyboardInstallWalkthrough)
        userDefaults.setValue(nil, forKey: SessionManagerPropertyKey.userNotificationSettings)
        userDefaults.setValue(nil, forKey: SessionManagerPropertyKey.userHasSeenPushNotificationView)
        userDefaults.setValue(nil, forKey: SessionManagerPropertyKey.pushNotificationShownCount)
        userDefaults.setValue(nil, forKey: SessionManagerPropertyKey.lastPack)
        userDefaults.setValue(nil, forKey: SessionManagerPropertyKey.lastCategory)
        userDefaults.setValue(nil, forKey: SessionManagerPropertyKey.lastFilterType)

        userDefaults.synchronize()
    }
    
}