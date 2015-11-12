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
    
    override init() {
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        userDefaults.setBool(true, forKey: "keyboardInstall")
        userDefaults.synchronize()
        
        isFullAccessEnabled = false
        firebaseRef = Firebase(url: BaseURL)
        
        
        
        let configuration = SEGAnalyticsConfiguration(writeKey: AnalyticsWriteKey)
        SEGAnalytics.setupWithConfiguration(configuration)

        Parse.setApplicationId(ParseAppID, clientKey: ParseClientKey)
        PFConfig.getConfigInBackgroundWithBlock { (config, error) in
            if let newBaseURL = PFConfig.currentConfig().objectForKey("firebase_root") as? String {
                BaseURL = newBaseURL
            }
            
            if let newAppStoreLink = PFConfig.currentConfig().objectForKey("AppStoreLink") as? String {
                AppStoreLink = newAppStoreLink
            }
        }
        
        super.init()
        
        guard let userId = userDefaults.objectForKey(UserDefaultsProperty.userID) as? String else {
            return
        }
        SEGAnalytics.sharedAnalytics().identify(userId)
    }
    
    func logTextSendEvent(mediaLink: MediaLink) {
        guard let userId = userDefaults.objectForKey(UserDefaultsProperty.userID) as? String else {
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
