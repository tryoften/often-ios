//
//  UserProfileViewModel.swift
//  Drizzy
//
//  Created by Luc Success on 5/17/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class UserProfileViewModel: NSObject, SessionManagerObserver {
    weak var delegate: UserProfileViewModelDelegate?
    var sessionManager: SessionManager

    var numberOfKeyboards: Int {
        if let keyboardService = sessionManager.keyboardService {
            return keyboardService.keyboards.count
        }
        return 0
    }
    
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
    
    func keyboardAtIndex(index: Int) -> Keyboard? {
        if let keyboard = sessionManager.keyboardService?.keyboards[index] {
            return keyboard
        }
        return nil
    }
    
    func deleteKeyboardWithId(keyboardId: String, completion: (NSError?) -> ()) {
        sessionManager.keyboardService?.deleteKeyboardWithId(keyboardId, completion: completion)
    }
    
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
        
    }

    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool) {
        sessionManager.fetchKeyboards()
        delegate?.userProfileViewModelDidLoginUser(self, user: user)
    }
    
    func sessionManagerDidFetchKeyboards(sessionManager: SessionManager, keyboards: [Keyboard]) {
        delegate?.userProfileViewModelDidLoadKeyboardList(self, keyboardList: keyboards)
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
