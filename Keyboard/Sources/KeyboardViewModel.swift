//
//  KeyboardViewModel.swift
//  Often
//
//  Created by Komran Ghahremani on 11/7/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class KeyboardViewModel: NSObject {
    let sessionManagerFlags = SessionManagerFlags.defaultManagerFlags
    var firebaseRef: Firebase
    
    override init() {
        sessionManagerFlags.userHasOpenedKeyboard = true
        firebaseRef = Firebase(url: BaseURL)
        CacheConfig.setupStandardConfig()
        
        _ = ParseConfig.defaultConfig
        
        let configuration = SEGAnalyticsConfiguration(writeKey: AnalyticsWriteKey)
        Analytics.setupWithConfiguration(configuration)
        
        super.init()
        
        guard let userId = sessionManagerFlags.userId else {
            return
        }
        print("User authenticated: ", userId)
        Analytics.sharedAnalytics().identify(userId)
    }
    
    func logTextSendEvent(mediaLink: MediaItem) {
        guard let userId = sessionManagerFlags.userId else {
            print("User Id not found")
            return
        }
        
        let data = [
            "task": "addRecent",
            "user": userId,
            "result": mediaLink.toDictionary()
        ]
        
        Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.addRecent), additionalProperties: AnalyticsAdditonalProperties.mediaItem(mediaLink.toDictionary()))

        firebaseRef.childByAppendingPath("queues/user/tasks").childByAutoId().setValue(data)
    }

}
