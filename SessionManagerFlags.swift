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
    
    private var userDefaults: UserDefaults
    
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
    }

    var userNotificationSettings: Bool {
        get {
            return userDefaults.bool(forKey: SessionManagerPropertyKey.userNotificationSettings)
        }

        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.userNotificationSettings)
        }
    }
    
    var hasSeenKeyboardGeneralToolTips: Bool {
        get {
            return userDefaults.bool(forKey: SessionManagerPropertyKey.keyboardGeneralToolTips)
        }
        
        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.keyboardGeneralToolTips)
        }
    }
    
    var hasSeenKeyboardSearchBarToolTips: Bool {
        get {
            return UserDefaults.standard().bool(forKey: SessionManagerPropertyKey.keyboardSearchBarToolTips)
        }
        
        set(value) {
            UserDefaults.standard().set(value, forKey: SessionManagerPropertyKey.keyboardSearchBarToolTips)
        }
    }
    
    var userHasOpenedKeyboard: Bool {
        get {
            return userDefaults.bool(forKey: SessionManagerPropertyKey.keyboardOpen)
        }
        
        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.keyboardOpen)
        }
    }

    var userSeenKeyboardInstallWalkthrough: Bool {
        get {
            return userDefaults.bool(forKey: SessionManagerPropertyKey.keyboardInstallWalkthrough)
        }

        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.keyboardInstallWalkthrough)
        }
    }
    
    var userMessageCount: Int {
        get {
            return userDefaults.integer(forKey: SessionManagerPropertyKey.messageSentCount)
        }
        
        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.messageSentCount)
        }
    }

    var userHasSeenPushNotificationView: Bool {
        get {
            return userDefaults.bool(forKey: SessionManagerPropertyKey.userHasSeenPushNotificationView)
        }

        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.userHasSeenPushNotificationView)
        }
    }

    var pushNotificationShownCount: Int {
        get {
            return userDefaults.integer(forKey: SessionManagerPropertyKey.pushNotificationShownCount)
        }

        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.pushNotificationShownCount)
        }
    }

    
    var isKeyboardInstalled: Bool {
        get {
            guard let keyboards = UserDefaults.standard().dictionaryRepresentation()["AppleKeyboards"] as? [String] else {
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
            return userDefaults.bool(forKey: SessionManagerPropertyKey.openSession)
        }
        
        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.openSession)
        }
    }
    
    var userId: String? {
        get {
            return userDefaults.string(forKey: SessionManagerPropertyKey.userID)
        }
        
        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.userID)
        }
    }

    var lastPack: String? {
        get {
            return  UserDefaults.standard().object(forKey: SessionManagerPropertyKey.lastPack) as? String
        }

        set(value) {
             UserDefaults.standard().set(value, forKey: SessionManagerPropertyKey.lastPack)
        }
    }

    var lastFilterType: String? {
        get {
            return  UserDefaults.standard().object(forKey: SessionManagerPropertyKey.lastFilterType) as? String
        }

        set(value) {
            UserDefaults.standard().set(value, forKey: SessionManagerPropertyKey.lastFilterType)
        }
    }

    var lastCategoryIndex: Int {
        get {
            return  UserDefaults.standard().integer(forKey: SessionManagerPropertyKey.lastCategory)
        }

        set(value) {
            UserDefaults.standard().set(value, forKey: SessionManagerPropertyKey.lastCategory)
        }
    }
    
    var userIsAnonymous: Bool {
        get {
            return userDefaults.bool(forKey: SessionManagerPropertyKey.anonymousUser)
        }
        set(value) {
            setValueToUserDefaults(value, forKey: SessionManagerPropertyKey.anonymousUser)
        }
    }
    
    var isUserLoggedIn: Bool {
        return userId != nil
    }
    
    init() {
        userDefaults = UserDefaults(suiteName: AppSuiteName)!
    }
    
    func setValueToUserDefaults(_ value: AnyObject?, forKey: String) {
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
