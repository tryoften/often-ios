//
//  UserProfileViewModel.swift
//  Often
//
//  Created by Kervins Valcourt on 8/20/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class UserProfileViewModel: NSObject, SessionManagerObserver {
    weak var delegate: UserProfileViewModelDelegate?
    var sessionManager: SessionManager
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        super.init()
        self.sessionManager.addSessionObserver(self)
    }
    
    deinit {
        sessionManager.removeSessionObserver(self)
    }
    
    func requestData(completion: ((Bool) -> ())? = nil) {
        if sessionManager.userDefaults.objectForKey("openSession") != nil {
            sessionManager.fetchSocialAccount()
            if let currentUser = sessionManager.currentUser {
                delegate?.userProfileViewModelDidLoginUser(self, user: currentUser)
            }
            
        } else {
            if sessionManager.userDefaults.objectForKey("twitter") != nil {
                sessionManager.login(.Twitter)
            } else {
                sessionManager.login(.Facebook)
            }
        }
    }
    
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
        
    }
    
    func sessionManagerDidFetchSocialAccounts(sessionsManager: SessionManager, SocialAccounts: [SocialAccount]) {
    
    }
    
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool) {
        
    }
}

protocol UserProfileViewModelDelegate: class {
    func userProfileViewModelDidLoginUser(userProfileViewModel: UserProfileViewModel, user: User)
    func userProfileViewModelDidLoadSocialServiceList(userProfileViewModel: UserProfileViewModel, SocialAccountList: [SocialAccount])
}