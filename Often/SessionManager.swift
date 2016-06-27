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
        Analytics.setup(with: SEGAnalyticsConfiguration.init(writeKey: AnalyticsWriteKey))
        Analytics.shared().screen("Service_Loaded")
        Flurry.startSession(FlurryClientKey)

        _ = ParseConfig.defaultConfig
        firebase = FIRDatabase.database().reference()
        accountManager = AccountManager(firebase: firebase)

        super.init()

        accountManager.delegate = self

        if let userID = sessionManagerFlags.userId {
            Analytics.shared().identify(userID)
            let crashlytics = Crashlytics.sharedInstance()
            crashlytics.setUserIdentifier(userID)
            accountManager.isUserLoggedIn()
        }
    }

    func login(_ accountManagerControllerClass: AccountManager.Type, userData: UserAuthData?, completion: (results: ResultType) -> Void) throws {
        accountManager = accountManagerControllerClass.init(firebase: firebase)
        accountManager.delegate = self
        accountManager.login(userData, completion: { results in
            switch results {
            case .success(let value): completion(results: ResultType.success(r: value))
            case .error(let err): completion(results: ResultType.error(e: err))
            case .systemError(let err): completion(results: ResultType.systemError(e: err))
            }
        })
    }

    func updateUserPushNotificationStatus(_ status: Bool)  {
        guard let user = currentUser, let userId = currentUser?.id else {
            return
        }

        user.pushNotificationStatus = status
        SessionManagerFlags.defaultManagerFlags.userNotificationSettings = status

        if let token =  FIRInstanceID.instanceID().token() {
            currentUser?.firebasePushNotificationToken = token
        }

        let userRef = FIRDatabase.database().reference().child("users/\(userId)")
        let pushNotificationTokenEndPoint = userRef.child("firebasePushNotificationToken")
        let pushNotificationStatusEndPoint = userRef.child("pushNotificationStatus")

        pushNotificationTokenEndPoint.setValue(user.firebasePushNotificationToken)
        pushNotificationStatusEndPoint.setValue(status)

        if status {
            UIApplication.shared().registerUserNotificationSettings( UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: []))
            UIApplication.shared().registerForRemoteNotifications()
        } else {
            UIApplication.shared().unregisterForRemoteNotifications()
        }
    }


    func logout() {
        Analytics.shared().track(AnalyticsProperties(eventName: AnalyticsEvent.logout))
        PFUser.logOut()
        accountManager.logout()
        try! FIRAuth.auth()!.signOut()
        accountManager.delegate = nil
        sessionManagerFlags.clearSessionFlags()

        guard let directory: URL = FileManager.default().containerURLForSecurityApplicationGroupIdentifier(AppSuiteName) else {
            return
        }
        
        do {
            try FileManager.default().removeItem(atPath: directory.path!)
        } catch _ {
        }
    }

    func accountManagerUserDidLogin(_ accountManager: AccountManagerProtocol, user: User) {
        delegate?.sessionManagerDidLoginUser(self, user: user)
    }

    func accountManagerUserDidLogout(_ accountManager: AccountManagerProtocol, user: User) {
    }

    func accountManagerNoUserFound(_ accountManager: AccountManagerProtocol) {
        delegate?.sessionManagerNoUserFound(self)
    }
}

enum SessionManagerError: ErrorProtocol {
    case unvalidSignUp
}

protocol SessionManagerDelegate: class {
    func sessionManagerDidLoginUser(_ sessionManager: SessionManager, user: User)
    func sessionManagerNoUserFound(_ sessionManager: SessionManager)
}
