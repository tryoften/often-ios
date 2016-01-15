//
//  SessionManager.swift
//  Often
//
//  Created by Kervins Valcourt on 8/14/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation
import Crashlytics

class SessionManager: NSObject {
    let sessionManagerFlags = SessionManagerFlags.defaultManagerFlags
    var firebase: Firebase
    var accountManager: AccountManager?
    var userRef: Firebase?
    var currentUser: User?
    var currentSession: FBSession?
    weak var delegate: SessionManagerDelegate?
    var userIsLoggingIn = false

    static let defaultManager = SessionManager()
    
    override init() {
        let configuration = SEGAnalyticsConfiguration(writeKey: AnalyticsWriteKey)
        SEGAnalytics.setupWithConfiguration(configuration)
        SEGAnalytics.sharedAnalytics().screen("Service_Loaded")
        Flurry.startSession(FlurryClientKey)
        Firebase.defaultConfig().persistenceEnabled = true

        _ = ParseConfig.defaultConfig
        firebase = Firebase(url: BaseURL)
        
        super.init()

        firebase.observeAuthEventWithBlock { authData in
            self.processAuthData(authData)
        }
        
        if let userID = sessionManagerFlags.userId {
            SEGAnalytics.sharedAnalytics().identify(userID)
            let crashlytics = Crashlytics.sharedInstance()
            crashlytics.setUserIdentifier(userID)
            
            if let user = currentUser {
                crashlytics.setUserName(user.name)
                crashlytics.setUserEmail(user.email)
            }
        }
        
    }
    

    func login(accountManagerControllerClass: AccountManager.Type, userData: UserAuthData?, completion: (results: ResultType) -> Void) throws {
        userIsLoggingIn = true

        accountManager = accountManagerControllerClass.init(firebase: firebase)

        if let accountManager = accountManager {
            accountManager.login(userData, completion: { results in
                switch results {
                case .Success(let value): completion(results: ResultType.Success(r: value))
                case .Error(let err): completion(results: ResultType.Error(e: err))
                case .SystemError(let err): completion(results: ResultType.SystemError(e: err))
                }
            })
        }
    }


    func logout() {
        PFUser.logOut()
        accountManager?.logout()
        firebase.unauth()
        currentUser = nil
        accountManager = nil

        guard let directory: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(AppSuiteName) else {
            return
        }
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(directory.path!)
        } catch _ {
        }
    }
    
    private func processAuthData(authData: FAuthData?) {
        let persistUser: (User) -> Void = { user in
            self.currentUser = user

            if self.userIsLoggingIn {
                self.sessionManagerFlags.userId = user.id
                self.broadcastUserLoginEvent()
                self.userIsLoggingIn = false
            }
        }

        if !sessionManagerFlags.openSession {
            self.broadcastNoUserFoundEvent()
            logout()
            return
        }

        guard let authData = authData else {
            self.broadcastNoUserFoundEvent()
            logout()
            return

        }
        
        userRef = firebase.childByAppendingPath("users/\(authData.uid)")
        userRef?.observeSingleEventOfType(.Value, withBlock: { snapshot in
            // TODO(kervs): create user model with data and send event
            if snapshot.exists() {
                if let _ = snapshot.key,
                    let value = snapshot.value as? [String: AnyObject] {
                        let user = User()
                        user.setValuesForKeysWithDictionary(value)
                        user.id = authData.uid
                        self.userIsLoggingIn = true
                        
                        persistUser(user)
                }
            } else {
                    self.broadcastNoUserFoundEvent()
                    self.logout()
                
            }
            }, withCancelBlock: { error in
                
        })
        
    }

    // MARK: Private methods
    private func broadcastUserLoginEvent() {
        if let currentUser = currentUser {
            self.delegate?.sessionManagerDidLoginUser(self, user: currentUser)
        }
    }

    private func broadcastNoUserFoundEvent() {
        delegate?.sessionManagerNoUserFound(self)
    }

}

enum SessionManagerError: ErrorType {
    case UnvalidSignUp
}

protocol SessionManagerDelegate: class {
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User)
    func sessionManagerNoUserFound(sessionManager: SessionManager)
}
