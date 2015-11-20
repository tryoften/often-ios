//
//  SettingsViewModel.swift
//  Often
//
//  Created by Komran Ghahremani on 10/21/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

enum SettingsViewModelError: ErrorType {
    case NoUser
    case RequestDataFailed
}

class SettingsViewModel {
    weak var delegate: SettingsViewModelDelegate?
    let baseRef: Firebase
    private let userDefaults: NSUserDefaults
    var sessionManager: SessionManager
    var currentUser: User?
    
    init(sessionManager: SessionManager) {
        baseRef = Firebase(url: BaseURL)
        self.sessionManager = sessionManager
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        
    }
    
    func requestData(completion: ((Bool) -> ())? = nil) throws {
        guard let userId = userDefaults.objectForKey(UserDefaultsProperty.userID) as? String else {
            throw SettingsViewModelError.NoUser
        }
        
        guard userDefaults.boolForKey(UserDefaultsProperty.openSession) else {
            throw SettingsViewModelError.RequestDataFailed
        }
        
        let userRef = baseRef.childByAppendingPath("users/\(userId)")
        userRef.keepSynced(true)
        
        userRef.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                if let _ = snapshot.key,
                    let value = snapshot.value as? [String: AnyObject] {
                        self.currentUser = User()
                        self.currentUser?.setValuesForKeysWithDictionary(value)
                }
            }
            self.delegate?.settingsViewModelDidReceiveUserData(self)
        })

    }
    
}

protocol SettingsViewModelDelegate: class {
    func settingsViewModelDidReceiveUserData(userProfileViewModel: SettingsViewModel)
}
