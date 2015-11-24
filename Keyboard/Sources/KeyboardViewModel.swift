//
//  KeyboardViewModel.swift
//  Often
//
//  Created by Komran Ghahremani on 11/7/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class KeyboardViewModel: NSObject {
    var userDefaults: NSUserDefaults
    var isFullAccessEnabled: Bool
    var hasSeenTooltip: Bool {
        get {
            return userDefaults.boolForKey(KeyboardTooltipsDisplayedKey)
        }
        set(value) {
            userDefaults.setBool(value, forKey: KeyboardTooltipsDisplayedKey)
        }
    }
    var firebaseRef: Firebase
    
    static var userId: String? {
        get {
            guard let userDefaults = NSUserDefaults(suiteName: AppSuiteName) else {
                return nil
            }
            return userDefaults.objectForKey(UserDefaultsProperty.userID) as? String
        }
        
        set(value) {
            guard let userDefaults = NSUserDefaults(suiteName: AppSuiteName) else {
                return
            }
            userDefaults.setObject(value, forKey: UserDefaultsProperty.userID)
        }
    }
    
    override init() {
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        userDefaults.setBool(true, forKey: UserDefaultsProperty.keyboardInstalled)
        userDefaults.synchronize()
        
        isFullAccessEnabled = false
        firebaseRef = Firebase(url: BaseURL)
        
        _ = ParseConfig.defaultConfig
        
        let configuration = SEGAnalyticsConfiguration(writeKey: AnalyticsWriteKey)
        SEGAnalytics.setupWithConfiguration(configuration)
        
        super.init()
        
        guard let userId = KeyboardViewModel.userId else {
            return
        }
        print("User authenticated: ", userId)
        SEGAnalytics.sharedAnalytics().identify(userId)
    }
    
    func logTextSendEvent(mediaLink: MediaLink) {
        guard let userId = KeyboardViewModel.userId else {
            print("User Id not found")
            return
        }
        
        let data = [
            "task": "addRecent",
            "user": userId,
            "result": mediaLink.toDictionary()
        ]
        
        SEGAnalytics.sharedAnalytics().track("addRecent", properties: data as [NSObject : AnyObject])
        firebaseRef.childByAppendingPath("queues/user/tasks").childByAutoId().setValue(data)
    }
}
