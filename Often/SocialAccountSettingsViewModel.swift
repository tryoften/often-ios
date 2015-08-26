//
//  SocialAccountSettingsViewModel.swift
//  Often
//
//  Created by Kervins Valcourt on 8/25/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class SocialAccountSettingsViewModel:NSObject, SessionManagerObserver {
    weak var delegate: SocialAccountSettingsViewModelDelegate?
    var sessionManager: SessionManager
    var socialAccounts: [SocialAccount]
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        socialAccounts = [SocialAccount]()
        super.init()
        self.sessionManager.addSessionObserver(self)
    }
    
    deinit {
        sessionManager.removeSessionObserver(self)
    }
    
    func deleteSocialAccountWithId(socialAccountId: String, completion: (NSError?) -> ()) {
        sessionManager.socialAccountService?.removeSocialAccounteWithId(socialAccountId, completion: completion)
    }
    
    func addSocialAccountWithId(socialAccountId: String, completion: (Bool?) -> ()) {
        sessionManager.socialAccountService?.addSocialAccounteWithId(socialAccountId, completion: { (SocialAccount, success)  in
            completion(success)
        })
    }
    
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
        
    }
    
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool) {
        sessionManager.fetchSocialAccount()
    }
    
    func sessionManagerDidFetchSocialAccounts(sessionsManager: SessionManager, socialAccounts: [SocialAccount]) {
        self.socialAccounts = socialAccounts
        delegate?.socialAccountSettingsViewModelDidLoadSocialAccountList(self, socialAccountList: self.socialAccounts)
    }
}

protocol SocialAccountSettingsViewModelDelegate: class {
    func socialAccountSettingsViewModelDidLoginUser(userProfileViewModel: SocialAccountSettingsViewModel, user: User)
    func socialAccountSettingsViewModelDidLoadSocialAccountList(socialAccountSettingsViewModel: SocialAccountSettingsViewModel, socialAccountList: [SocialAccount])
}