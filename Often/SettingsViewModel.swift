//
//  SettingsViewModel.swift
//  Often
//
//  Created by Komran Ghahremani on 10/21/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class SettingsViewModel: NSObject, SessionManagerDelegate {
    weak var delegate: SettingsViewModelDelegate?
    var sessionManager: SessionManager
    var currentUser: User?
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        super.init()
        self.sessionManager.delegate = self
        self.requestData(nil)
    }
    
    deinit {
        self.sessionManager.delegate = nil
    }
    
    func requestData(completion: ((Bool) -> ())? = nil) {
        if sessionManager.sessionManagerFlags.openSession {
            if let user = sessionManager.currentUser {
                currentUser = user

            }
        }
    }
    

    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User) {
        currentUser = user
        if let userData = currentUser {
            delegate?.settingsViewModelDidReceiveUserData(self, user: userData)
        } else {
            print("No User Data")
        }
    }
    
    func sessionManagerNoUserFound(sessionManager: SessionManager) {}

}

protocol SettingsViewModelDelegate: class {
    func settingsViewModelDidReceiveUserData(userProfileViewModel: SettingsViewModel, user: User)
}
