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

class KeyboardViewModel: NSObject {
    weak var delegate: KeyboardViewModelDelegate?
    var userDefaults: NSUserDefaults
    var hasSeenToolTips: Bool?
    var realm: Realm!
    var isFullAccessEnabled: Bool
    var hasSeenTooltip: Bool {
        get {
            return userDefaults.boolForKey("toolTips")
        }
        set(value) {
            userDefaults.setBool(value, forKey: "toolTips")
        }
    }
    static let sharedInstance = KeyboardViewModel()
    
    override init() {
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        isFullAccessEnabled = false
        
        let root = Firebase(url: BaseURL)

        var configuration = SEGAnalyticsConfiguration(writeKey: AnalyticsWriteKey)
        SEGAnalytics.setupWithConfiguration(configuration)
        
        Crashlytics.startWithAPIKey(CrashlyticsAPIKey)

        if let userId = userDefaults.objectForKey("userId") as? String {
            SEGAnalytics.sharedAnalytics().identify(userId)
            var crashlytics = Crashlytics.sharedInstance()
            crashlytics.setUserIdentifier(userId)
        }
        SEGAnalytics.sharedAnalytics().screen("keyboard:loaded")

        userDefaults.setBool(true, forKey: "keyboardInstall")
        userDefaults.synchronize()

        super.init()
    }

    deinit {
        realm.invalidate()
        realm = nil
    }
    
}

protocol KeyboardViewModelDelegate: class {
    func keyboardViewModelDidLoadData(keyboardViewModel: KeyboardViewModel, data: [Keyboard])
    func keyboardViewModelCurrentKeyboardDidChange(keyboardViewModel: KeyboardViewModel, keyboard: Keyboard)
}