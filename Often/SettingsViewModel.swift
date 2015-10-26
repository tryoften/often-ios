//
//  SettingsViewModel.swift
//  Often
//
//  Created by Komran Ghahremani on 10/21/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class SettingsViewModel: NSObject, SessionManagerObserver {
    weak var delegate: SettingsViewModelDelegate?
    var sessionManager: SessionManager
    var currentUser: User?
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        super.init()
        self.sessionManager.addSessionObserver(self)
        self.requestData(nil)
    }
    
    deinit {
        sessionManager.removeSessionObserver(self)
    }
    
    func requestData(completion: ((Bool) -> ())? = nil) {
        if sessionManager.userDefaults.boolForKey(SessionManagerProperty.openSession) {
            if let user = sessionManager.currentUser {
                currentUser = user
                
            }
        }
    }
    
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
        
    }
    
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool) {
        currentUser = user
        if let userData = currentUser {
            delegate?.settingsViewModelDidReceiveUserData(self, user: userData, isNewUser: isNewUser)
        } else {
            print("No User Data")
        }
    }
    
    func sessionManagerDidFetchSocialAccounts(sessionsManager: SessionManager, socialAccounts: [String: AnyObject]?) {
    }
}

protocol SettingsViewModelDelegate: class {
    func settingsViewModelDidReceiveUserData(userProfileViewModel: SettingsViewModel, user: User, isNewUser: Bool)
}
