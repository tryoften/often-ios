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
    var phoneNumber: String
    var fullName: String
    var email: String
    var password: String
    var artistSelectedList: [String]?
    var artistsList: [Artist]
    var artistService: ArtistService
    var delegate: WalkthroughViewModelDelegate?
    var sessionManager: SessionManager
   
    init(sessionManager: SessionManager){
        self.sessionManager = sessionManager
        phoneNumber = ""
        fullName = ""
        email = ""
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
            self.artistsList = artistsList.values.array
            println(self.artistsList.count)
            
            self.delegate?.walkthroughViewModelDidLoadArtistsList(self, keyboardList: self.artistsList)
        }
    }
    
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
        
    }
    
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User) {
        
    }
    
    func sessionManagerDidFetchKeyboards(sessionsManager: SessionManager, keyboards: [String: Keyboard]) {
        
    }
    
    func sessionManagerDidFetchTracks(sessionManager: SessionManager, tracks: [String : Track]) {
    }
    
    func sessionManagerDidFetchArtists(sessionManager: SessionManager, artists: [String : Artist]) {
        
    }
}

protocol WalkthroughViewModelDelegate {
    func walkthroughViewModelDidLoadArtistsList(signUpWalkthroughViewModel: SignUpWalkthroughViewModel, keyboardList: [Artist])
}