//
//  SessionManager.swift
//  Often
//
//  Created by Kervins Valcourt on 8/14/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation
import Crashlytics

class SessionManager: NSObject, AccountManagerDelegate {
    static let defaultManager = SessionManager()
    weak var delegate: SessionManagerDelegate?
    let sessionManagerFlags = SessionManagerFlags.defaultManagerFlags
    private var firebase: Firebase
    private var accountManager: AccountManager
    var currentUser: User? {
        return accountManager.currentUser
    }

    override init() {
        Analytics.setupWithConfiguration(SEGAnalyticsConfiguration(writeKey: AnalyticsWriteKey))
        Analytics.sharedAnalytics().screen("Service_Loaded")
        Flurry.startSession(FlurryClientKey)
        Firebase.defaultConfig().persistenceEnabled = true

        _ = ParseConfig.defaultConfig
        firebase = Firebase(url: BaseURL)
        accountManager = AccountManager(firebase: firebase)

        super.init()

        accountManager.delegate = self

        if let userID = sessionManagerFlags.userId {
            Analytics.sharedAnalytics().identify(userID)
            let crashlytics = Crashlytics.sharedInstance()
            crashlytics.setUserIdentifier(userID)
            accountManager.isUserLoggedIn()
        }
    }

    func login(accountManagerControllerClass: AccountManager.Type, userData: UserAuthData?, completion: (results: ResultType) -> Void) throws {
        accountManager = accountManagerControllerClass.init(firebase: firebase)
        accountManager.delegate = self
        accountManager.login(userData, completion: { results in
            switch results {
            case .Success(let value): completion(results: ResultType.Success(r: value))
            case .Error(let err): completion(results: ResultType.Error(e: err))
            case .SystemError(let err): completion(results: ResultType.SystemError(e: err))
            }
        })
    }


    func logout() {
        Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.logout))
        PFUser.logOut()
        accountManager.logout()
        firebase.unauth()
        accountManager.delegate = nil
        sessionManagerFlags.clearSessionFlags()
        FavoritesService.defaultInstance.currentUser = nil

        guard let directory: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(AppSuiteName) else {
            return
        }
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(directory.path!)
        } catch _ {
        }
    }

    func accountManagerUserDidLogin(accountManager: AccountManagerProtocol, user: User) {
        FavoritesService.defaultInstance.currentUser = user
        delegate?.sessionManagerDidLoginUser(self, user: user)
    }

    func accountManagerUserDidLogout(accountManager: AccountManagerProtocol, user: User) {
    }

    func accountManagerNoUserFound(accountManager: AccountManagerProtocol) {
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
