//
//  SignUpWalkthroughViewModel.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/3/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

/**
Service:

- Create a user

*/

class SignUpWalkthroughViewModel: NSObject, SessionManagerObserver {
    var user: User
    var password: String
    var artistSelectedList: [String]?
    var artistsList: [Artist]
    var artistService: ArtistService
    var sessionManager: SessionManager
    weak var delegate: WalkthroughViewModelDelegate?
   
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        user = User()
        password = ""
        artistSelectedList = [String]()
        artistsList = [Artist]()
        artistService = ArtistService(root: Firebase(url: BaseURL))
        super.init()
        self.sessionManager.addSessionObserver(self)
    }
    
    deinit {
        sessionManager.removeSessionObserver(self)
    }
    
    func getListOfArtists() {
        artistService.requestData { (artistsList) -> Void in
            self.artistsList = artistsList
            
            println(self.artistsList.count)
            
            self.delegate?.walkthroughViewModelDidLoadArtistsList?(self, keyboardList: self.artistsList)
        }
    }
    
    func signUpUser() {
        var userData = [String: String]()
        if PhoneIsValid(user.phone) {
            userData["phone"] = user.phone
        } else {
            println("missing phone number")
            return
        }
        if EmailIsValid(user.email) {
            userData["email"] = user.email
            userData["username"] = user.email
        } else {
            println("missing email address")
            return
        }
        if NameIsValid(user.name) {
          userData["name"] = user.name
        }  else {
            println("missing full name")
            return
        }
        if PasswordIsValid(password) {
            userData["password"] = password
        } else {
            println("missing password")
            return
        }
        sessionManager.signUpUser(userData, completion: { (error) -> () in
            if error == nil {
                println("all good in the hood")
            } else {
                println("no good mang")
            }
        })
    }
    
    func sessionDidOpen(sessqionManager: SessionManager, session: FBSession) {
        
    }
    
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool) {
        self.user = user
        delegate?.walkthroughViewModelDidLoginUser?(self, user: user, isNewUser: isNewUser)
    }
    
    func sessionManagerDidFetchKeyboards(sessionsManager: SessionManager, keyboards: [Keyboard]) {
        
    }
}

@objc protocol WalkthroughViewModelDelegate: class {
    optional func walkthroughViewModelDidLoginUser(walkthroughViewModel: SignUpWalkthroughViewModel, user: User, isNewUser: Bool)
    optional func walkthroughViewModelDidLoadArtistsList(signUpWalkthroughViewModel: SignUpWalkthroughViewModel, keyboardList: [Artist])
}