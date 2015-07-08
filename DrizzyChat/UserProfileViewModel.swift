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
    var defaultKeyboardId: String? {
        set(value) {
            sessionManager.keyboardService?.currentKeyboardId = value
        }
        
        get {
            return sessionManager.keyboardService?.currentKeyboardId
        }
    }

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
        if sessionManager.userDefaults.objectForKey("openSession") != nil {
            sessionManager.fetchKeyboards()
            if let currentUser = sessionManager.currentUser {
                delegate?.userProfileViewModelDidLoginUser(self, user: currentUser)
            }
        
        } else {
         sessionManager.login()
        }
    }
    
    func keyboardAtIndex(index: Int) -> Keyboard? {
        if let keyboards = sessionManager.keyboardService?.keyboards {
            if index < keyboards.count {
                return keyboards[index]
            }
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
}

protocol UserProfileViewModelDelegate: class {
    func userProfileViewModelDidLoginUser(userProfileViewModel: UserProfileViewModel, user: User)
    func userProfileViewModelDidLoadKeyboardList(userProfileViewModel: UserProfileViewModel, keyboardList: [Keyboard])
}
