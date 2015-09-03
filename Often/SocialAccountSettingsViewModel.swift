//
//  SocialAccountSettingsViewModel.swift
//  Often
//
//  Created by Kervins Valcourt on 8/25/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class SocialAccountSettingsViewModel:NSObject, SessionManagerObserver, SpotifySocialServiceDelegate, VenmoServiceSocialServiceDelegate, SoundcloudSocialServiceDelegate   {
    weak var delegate: SocialAccountSettingsViewModelDelegate?
    var sessionManager: SessionManager
    var socialAccounts: [SocialAccount]
    var venmoService: VenmoService
    var spotifyService: SpotifyService
    var soundcloudService: SoundcloudService
    
    init(sessionManager: SessionManager, venmoService: VenmoService, spotifyService: SpotifyService, soundcloudService: SoundcloudService) {
        self.sessionManager = sessionManager
        self.venmoService = venmoService
        self.spotifyService = spotifyService
        self.soundcloudService = soundcloudService
        socialAccounts = [SocialAccount]()
        
        super.init()
        
        self.venmoService.delegate = self
        self.spotifyService.delegate = self
        self.soundcloudService.delegate = self
        self.sessionManager.addSessionObserver(self)
        
    }
    
    deinit {
        sessionManager.removeSessionObserver(self)
    }
    
      
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
        
    }
    
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool) {
        sessionManager.fetchSocialAccount()
    }
    
    func updateLocalSocialAccount (socialAccountType:SocialAccountType) {
        switch socialAccountType {
        case .Spotify:
            self.socialAccounts[1] = self.spotifyService.spotifyAccount!
            break
        case .Soundcloud:
            self.socialAccounts[2] = self.soundcloudService.soundcloudAccount!
            break
        case .Venmo:
            self.socialAccounts[3] = self.venmoService.venmoAccount!
            break
        case .Other:
            break
        default:
            break
            
        }
            sessionManager.socialAccountService?.updateLocalSocialAccount(socialAccounts)

    }
    
    func sessionManagerDidFetchSocialAccounts(sessionsManager: SessionManager, socialAccounts: [SocialAccount]) {
        self.socialAccounts = socialAccounts
        
    }
    
    func spotifysocialServiceDidPullToken(userProfileViewModel: SpotifyService, account: SocialAccount) {
        delegate?.socialAccountSettingsViewModelDidLoadSocialAccountList(self, socialAccount: account)
      
    }
    
    func venmoSocialServiceDidPullToken(userProfileViewModel: VenmoService, account: SocialAccount) {
         delegate?.socialAccountSettingsViewModelDidLoadSocialAccountList(self, socialAccount: account)
    }
    
    func soundcloudsocialServiceDidPullToken(userProfileViewModel: SoundcloudService, account: SocialAccount) {
        delegate?.socialAccountSettingsViewModelDidLoadSocialAccountList(self, socialAccount: account)
    }

}

protocol SocialAccountSettingsViewModelDelegate: class {
    func socialAccountSettingsViewModelDidLoginUser(userProfileViewModel: SocialAccountSettingsViewModel, user: User)
    func socialAccountSettingsViewModelDidLoadSocialAccountList(socialAccountSettingsViewModel: SocialAccountSettingsViewModel, socialAccount: SocialAccount)
}