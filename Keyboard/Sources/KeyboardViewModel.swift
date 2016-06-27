//
//  KeyboardViewModel.swift
//  Often
//
//  Created by Komran Ghahremani on 11/7/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit
import Firebase

class KeyboardViewModel: NSObject {
    let sessionManagerFlags = SessionManagerFlags.defaultManagerFlags
    
    override init() {
        sessionManagerFlags.userHasOpenedKeyboard = true
        
        _ = ParseConfig.defaultConfig
        
        let configuration = SEGAnalyticsConfiguration(writeKey: AnalyticsWriteKey)
        Analytics.setup(with: configuration)
        
        super.init()
        
        guard let userId = sessionManagerFlags.userId else {
            return
        }
        print("User authenticated: ", userId)
        Analytics.shared().identify(userId)
    }
    
    func logTextSendEvent(_ mediaItem: MediaItem) {
        guard let userId = sessionManagerFlags.userId else {
            print("User Id not found")
            return
        }
        
        let data = [
            "type": "editUserPackItems",
            "task": "add",
            "userId": userId,
            "data": [
                "operation": "add",
                "packType": "recent",
                "mediaItem": mediaItem.toDictionary()
            ]
        ]

        let count = SessionManagerFlags.defaultManagerFlags.userMessageCount
        SessionManagerFlags.defaultManagerFlags.userMessageCount = count + 1

        Analytics.shared().track(AnalyticsProperties(eventName: AnalyticsEvent.addRecent), additionalProperties: AnalyticsAdditonalProperties.mediaItem(mediaItem.toDictionary()))

        FIRDatabase.database().reference().child("queues/user/tasks").childByAutoId().setValue(data)
    }

}
