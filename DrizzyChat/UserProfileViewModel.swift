//
//  UserProfileViewModel.swift
//  Drizzy
//
//  Created by Luc Success on 5/17/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class UserProfileViewModel: NSObject, SessionManagerObserver {
    var sessionManager: SessionManager
    var keyboardsList: [Keyboard]?
    weak var delegate: UserProfileViewModelDelegate?
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        super.init()
        self.sessionManager.addSessionObserver(self)
    }
    
    deinit {
        sessionManager.removeSessionObserver(self)
    }

    func requestData(completion: ((Bool) -> ())? = nil) {
        self.sessionManager.login()
    }
    
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
        
    }

    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool) {
        self.sessionManager.fetchKeyboards()
        self.delegate?.userProfileViewModelDidLoginUser(self, user: user)
    }
    
    func sessionManagerDidFetchKeyboards(sessionManager: SessionManager, keyboards: [String: Keyboard]) {
        self.keyboardsList = keyboards.values.array
        self.delegate?.userProfileViewModelDidLoadKeyboardList(self, keyboardList: self.keyboardsList!)
    }
    
    func sessionManagerDidFetchTracks(sessionManager: SessionManager, tracks: [String : Track]) {
        
    }
    
    func sessionManagerDidFetchArtists(sessionManager: SessionManager, artists: [String : Artist]) {
        
    }
}

protocol UserProfileViewModelDelegate: class {
    func userProfileViewModelDidLoginUser(userProfileViewModel: UserProfileViewModel, user: User)
    func userProfileViewModelDidLoadKeyboardList(userProfileViewModel: UserProfileViewModel, keyboardList: [Keyboard])
}
