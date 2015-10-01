//
//  SocialAccountSettingsViewModel.swift
//  Often
//
//  Created by Kervins Valcourt on 8/25/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class SocialAccountSettingsViewModel:NSObject, SessionManagerObserver, SpotifyAccountManagerDelegate, VenmoAccountManagerDelegate, SoundcloudAccountManagerDelegate {
    weak var delegate: SocialAccountSettingsViewModelDelegate?
    var sessionManager: SessionManager
    var socialAccounts: [SocialAccount]
    var venmoAccountManager: VenmoAccountManager
    var spotifyAccountManager: SpotifyAccountManager
    var soundcloudAccountManager: SoundcloudAccountManager
    
    init(sessionManager: SessionManager, venmoAccountManager: VenmoAccountManager, spotifyAccountManager: SpotifyAccountManager, soundcloudAccountManager: SoundcloudAccountManager) {
        self.sessionManager = sessionManager
        self.venmoAccountManager = venmoAccountManager
        self.spotifyAccountManager = spotifyAccountManager
        self.soundcloudAccountManager = soundcloudAccountManager
        self.socialAccounts = [SocialAccount]()
        
        super.init()
        
        self.venmoAccountManager.delegate = self
        self.spotifyAccountManager.delegate = self
        self.soundcloudAccountManager.delegate = self
        self.sessionManager.addSessionObserver(self)
        
    }
    
    deinit {
        sessionManager.removeSessionObserver(self)
    }
    
      
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
        
    }
    
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool) {
        
    }
    
    func sessionManagerDidFetchSocialAccounts(sessionsManager: SessionManager, socialAccounts: [String: AnyObject]?) {
        if let socialAccounts = socialAccounts {
            for accounts in socialAccounts.values {
                print(accounts)
                let socialAccount = SocialAccount()
                socialAccount.setValuesForKeysWithDictionary(accounts as! [String : AnyObject])
                self.socialAccounts.append(socialAccount)
            }
        }
    }
    
    func spotifyAccountManagerDidPullToken(userProfileViewModel: SpotifyAccountManager, account: SocialAccount) {
        delegate?.socialAccountSettingsViewModelDidLoadSocialAccountList(self, socialAccount: account)
      
    }
    
    func venmoAccountManagerDidPullToken(userProfileViewModel: VenmoAccountManager, account: SocialAccount) {
         delegate?.socialAccountSettingsViewModelDidLoadSocialAccountList(self, socialAccount: account)
    }
    
    func soundcloudAccountManagerDidPullToken(userProfileViewModel: SoundcloudAccountManager, account: SocialAccount) {
        delegate?.socialAccountSettingsViewModelDidLoadSocialAccountList(self, socialAccount: account)
    }

}

protocol SocialAccountSettingsViewModelDelegate: class {
    func socialAccountSettingsViewModelDidLoginUser(userProfileViewModel: SocialAccountSettingsViewModel, user: User)
    func socialAccountSettingsViewModelDidLoadSocialAccountList(socialAccountSettingsViewModel: SocialAccountSettingsViewModel, socialAccount: SocialAccount)
}