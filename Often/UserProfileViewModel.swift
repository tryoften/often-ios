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
    
    func socialAccountAtIndex(index: Int) -> SocialAccount? {
        if let socialAccounts = sessionManager.socialAccountService?.sortedSocialAccounts {
            if index < socialAccounts.count {
                return socialAccounts[index]
            }
        }
        return nil
    }
    
    func deleteSocialAccountWithId(socialAccountId: String, completion: (NSError?) -> ()) {
        sessionManager.socialAccountService?.removeSocialAccounteWithId(socialAccountId, completion: completion)
    }

    
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
        
    }
    
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool) {
        sessionManager.fetchSocialAccount()
        delegate?.userProfileViewModelDidLoginUser(self, user: user)
    }
    
    func sessionManagerDidFetchSocialAccounts(sessionsManager: SessionManager, socialAccounts: [SocialAccount]) {
        delegate?.userProfileViewModelDidLoadSocialServiceList(self, socialAccountList: socialAccounts)
    
    }
    
    
}

protocol UserProfileViewModelDelegate: class {
    func userProfileViewModelDidLoginUser(userProfileViewModel: UserProfileViewModel, user: User)
    func userProfileViewModelDidLoadSocialServiceList(userProfileViewModel: UserProfileViewModel, socialAccountList: [SocialAccount])
}