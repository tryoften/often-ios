//
//  SocialAccountSettingsViewModel.swift
//  Often
//
//  Created by Kervins Valcourt on 8/25/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//
//  swiftlint:disable force_cast

import Foundation

class SocialAccountSettingsViewModel: NSObject, SessionManagerObserver, AccountManagerDelegate {
    weak var delegate: SocialAccountSettingsViewModelDelegate?
    var sessionManager: SessionManager
    var socialAccounts: [SocialAccount]
    var spotifyAccountManager: SpotifyAccountManager?
    var soundcloudAccountManager: SoundcloudAccountManager?
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        spotifyAccountManager = sessionManager.spotifyAccountManager
        soundcloudAccountManager = sessionManager.soundcloudAccountManager
        socialAccounts = [SocialAccount]()
        
        super.init()

        spotifyAccountManager?.delegate = self
        soundcloudAccountManager?.delegate = self
        sessionManager.addSessionObserver(self)
    }
    
    deinit {
        sessionManager.removeSessionObserver(self)
    }

    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
        
    }
    
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool) {
        delegate?.socialAccountSettingsViewModelDidLoginUser(self, user: user)
        
    }
    
    func sessionManagerDidFetchSocialAccounts(sessionsManager: SessionManager, socialAccounts: [String: AnyObject]?) {
        if let socialAccounts = socialAccounts {
            for accounts in socialAccounts.values {
                let socialAccount = SocialAccount()
                socialAccount.setValuesForKeysWithDictionary(accounts as! [String : AnyObject])
                self.socialAccounts.append(socialAccount)
            }
            delegate?.socialAccountSettingsViewModelDidLoadSocialAccountList(self, socialAccount: self.socialAccounts)
        }
    }

    func userLogin(accountManager: AccountManager) {
    }

    func addedNewSocialAccount(accountManager: AccountManager, account: SocialAccount) {
        delegate?.socialAccountSettingsViewModelDidLoadSocialAccount(self, socialAccount: account)
      
    }
}

protocol SocialAccountSettingsViewModelDelegate: class {
    func socialAccountSettingsViewModelDidLoadSocialAccount(socialAccountSettingsViewModel: SocialAccountSettingsViewModel, socialAccount: SocialAccount)
    func socialAccountSettingsViewModelDidLoginUser(userProfileViewModel: SocialAccountSettingsViewModel, user: User)
    func socialAccountSettingsViewModelDidLoadSocialAccountList(socialAccountSettingsViewModel: SocialAccountSettingsViewModel, socialAccount: [SocialAccount])
}