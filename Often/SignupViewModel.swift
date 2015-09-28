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
    
    enum ResultType {
        case Success(r: Bool)
        case Error(e: ErrorType)
        case SystemError(e: NSError)
    }
    
    enum SignupError: ErrorType {
        case EmailNotVaild
        case PasswordNotVaild
    }
    
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
    
    func signUpUser(completion: (results: ResultType) -> Void) throws {
        var userData = [String: String]()
        
        guard EmailIsValid(user.email) else {
            completion(results: ResultType.Error(e: SignupError.EmailNotVaild))
            throw SignupError.EmailNotVaild
        }

        guard PasswordIsValid(password) else {
            completion(results: ResultType.Error(e: SignupError.PasswordNotVaild))
            throw SignupError.PasswordNotVaild
        }
        
        userData["email"] = user.email
        userData["username"] = user.email
        userData["password"] = password
        
        sessionManager.signupUser(.Email, data: userData, completion: { error -> () in
            if error == nil {
                print("all good in the hood")
                completion(results: ResultType.Success(r: true))
            } else {
                print("no good mang")
                completion(results: ResultType.SystemError(e: error!))
            }
        })
    }
    
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
    }
    
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool) {
        self.user = user
        delegate?.signupViewModelDidLoginUser(self, user: user, isNewUser: isNewUser)
    }
    
    func sessionManagerDidFetchSocialAccounts(sessionsManager: SessionManager, socialAccounts: [String: AnyObject]?) {
    }
}

protocol SignupViewModelDelegate: class {
    func signupViewModelDidLoginUser(userProfileViewModel: SignupViewModel, user: User, isNewUser: Bool)
}