//
//  UserProfileViewModel.swift
//  Often
//

import Foundation

class UserProfileViewModel: NSObject, SessionManagerObserver {
    weak var delegate: UserProfileViewModelDelegate?
    var sessionManager: SessionManager
    var currentUser: User?
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        super.init()
        self.sessionManager.addSessionObserver(self)
        self.requestData(nil)
    }
    
    deinit {
        sessionManager.removeSessionObserver(self)
    }
    
    func requestData(completion: ((Bool) -> ())? = nil) {
        if sessionManager.userDefaults.objectForKey("openSession") != nil {
            if let user = sessionManager.currentUser {
                currentUser = user
                delegate?.userProfileViewModelDidLoginUser(self, user: currentUser!)
            }
            
        } else {
                    }
    }
    
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
        
    }
    
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool) {
        currentUser = user
        delegate?.userProfileViewModelDidLoginUser(self, user: user)
    }
    
    func sessionManagerDidFetchSocialAccounts(sessionsManager: SessionManager, socialAccounts: [String:AnyObject]) {
        
    
    }
    
}

protocol UserProfileViewModelDelegate: class {
    func userProfileViewModelDidLoginUser(userProfileViewModel: UserProfileViewModel, user: User)
}

