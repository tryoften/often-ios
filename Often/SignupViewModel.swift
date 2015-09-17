//
//  SignupViewModel.swift
//  Often
//
//  Created by Kervins Valcourt on 9/8/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class SignupViewModel: NSObject, SessionManagerObserver {
    weak var delegate: SignupViewModelDelegate?
    var sessionManager: SessionManager
    var user: User
    var password: String
    var venmoAccountManager: VenmoAccountManager
    var spotifyAccountManager: SpotifyAccountManager
    var soundcloudAccountManager: SoundcloudAccountManager
    
    init(sessionManager: SessionManager, venmoAccountManager: VenmoAccountManager, spotifyAccountManager: SpotifyAccountManager, soundcloudAccountManager: SoundcloudAccountManager) {
        self.sessionManager = sessionManager
        self.venmoAccountManager = venmoAccountManager
        self.spotifyAccountManager = spotifyAccountManager
        self.soundcloudAccountManager = soundcloudAccountManager
        user = User()
        password = ""
        
        super.init()
        
        self.sessionManager.addSessionObserver(self)
    }
    
    func signUpUser(completion: ((Bool) -> ())) {
        var userData = [String: String]()
        
        if EmailIsValid(user.email) {
            userData["email"] = user.email
            userData["username"] = user.email
        } else {
            println("missing email address")
            return
        }

        if PasswordIsValid(password) {
            userData["password"] = password
        } else {
            println("missing password")
            return
        }
        sessionManager.signupUser(.Email, data: userData, completion: { (error) -> () in
            if error == nil {
                println("all good in the hood")
                completion(true)
            } else {
                println("no good mang")
                completion(false)
            }
        })
    }
    
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
    }
    
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool) {
        self.user = user
        delegate?.signupViewModelDidLoginUser(self, user: user, isNewUser: isNewUser)
    }
    
    func sessionManagerDidFetchSocialAccounts(sessionsManager: SessionManager, socialAccounts: [SocialAccount]) {
    }

}

protocol SignupViewModelDelegate: class {
    func signupViewModelDidLoginUser(userProfileViewModel: SignupViewModel, user: User, isNewUser: Bool)
}