//
//  SessionManager.swift
//  Often
//
//  Created by Kervins Valcourt on 8/14/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation
import Crashlytics
import Firebase
import FirebaseInstanceID

class SessionManager: NSObject, AccountManagerDelegate {
    static let defaultManager = SessionManager()
    weak var delegate: SessionManagerDelegate?
    let sessionManagerFlags = SessionManagerFlags.defaultManagerFlags
    private var firebase: FIRDatabaseReference
    private var accountManager: AccountManager
    var currentUser: User? {
        return accountManager.currentUser
    }
    
    override init() {
        Analytics.setupWithConfiguration(SEGAnalyticsConfiguration.init(writeKey: AnalyticsWriteKey))
        Analytics.sharedAnalytics().screen("Service_Loaded")
        Flurry.startSession(FlurryClientKey)
        
        _ = ParseConfig.defaultConfig
        firebase = FIRDatabase.database().reference()
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
    
    func updateUserPushNotificationStatus(status: Bool)  {
        guard let user = currentUser, let userId = currentUser?.id else {
            return
        }
        
        user.pushNotificationStatus = status
        SessionManagerFlags.defaultManagerFlags.userNotificationSettings = status
        
        let userRef = FIRDatabase.database().reference().child("users/\(userId)")
        let pushNotificationTokenEndPoint = userRef.child("firebasePushNotificationToken")
        let pushNotificationStatusEndPoint = userRef.child("pushNotificationStatus")
        
        
        if status {
            PacksService.defaultInstance.addToGlobalPushNotifications()
            
            UIApplication.sharedApplication().registerUserNotificationSettings( UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: []))
            UIApplication.sharedApplication().registerForRemoteNotifications()
        } else {
            PacksService.defaultInstance.removeFromGlobalPushNotifications()
            
            UIApplication.sharedApplication().unregisterForRemoteNotifications()
        }
        
        if let token = FIRInstanceID.instanceID().token() {
            currentUser?.firebasePushNotificationToken = token
        }
        
        pushNotificationTokenEndPoint.setValue(user.firebasePushNotificationToken)
        pushNotificationStatusEndPoint.setValue(status)
    }
    
    
    func logout() {
        Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.logout))
        PFUser.logOut()
        accountManager.logout()
        try! FIRAuth.auth()!.signOut()
        accountManager.delegate = nil
        sessionManagerFlags.clearSessionFlags()
        
        guard let directory: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(AppSuiteName) else {
            return
        }
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(directory.path!)
        } catch _ {
        }
    }
    
    func checkForUsername() {
        guard let name = currentUser?.username where !name.isEmpty else {
            return
        }
        
        PacksService.defaultInstance.usernameDoesExist(name, completion:  { exists in
            self.sessionManagerFlags.userHasUsername = exists
            if exists {
                PacksService.defaultInstance.saveUsername(name)
            }
        })
        
        self.sessionManagerFlags.userHasUsername = false
    }
    
    func accountManagerUserDidLogin(accountManager: AccountManagerProtocol, user: User) {
        delegate?.sessionManagerDidLoginUser(self, user: user)
        checkForUsername()
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
