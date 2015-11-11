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
    
    override init() {
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        userDefaults.setBool(true, forKey: "keyboardInstall")
        userDefaults.synchronize()
        
        isFullAccessEnabled = false
        
        super.init()
    }
    
    func logTextSendEvent() {
        
    }
}
