//
//  AccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 1/11/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Crashlytics
import TwitterKit
import Alamofire
import Firebase

typealias AccountManagerResultCallback = (results: ResultType) -> Void

class AccountManager: AccountManagerProtocol, ConnectivityObservable {
    weak var delegate: AccountManagerDelegate?
    var currentUser: User?

    final internal var sessionManagerFlags: SessionManagerFlags = SessionManagerFlags.defaultManagerFlags
    internal var userRef: FIRDatabaseReference?
    internal var firebase: FIRDatabaseReference
    internal var isNetworkReachable: Bool = true

    required init (firebase: FIRDatabaseReference) {
        self.firebase = firebase
        startMonitoring()
    }

    func isUserLoggedIn() {
        guard let userID = sessionManagerFlags.userId else {
            delegate?.accountManagerNoUserFound(self)
            return
        }

        userRef = firebase.child("users/\(userID)")
        userRef?.observeEventType(.Value, withBlock: { snapshot in
            if let value = snapshot.value as? [String: AnyObject] where snapshot.exists() {
                self.currentUser = User()
                self.currentUser?.setValuesForKeysWithDictionary(value)
                if let currentUser = self.currentUser {
                    self.delegate?.accountManagerUserDidLogin(self, user: currentUser)
                }

            } else {
                self.delegate?.accountManagerNoUserFound(self)
            }
        })
    }

    func login(userData: UserAuthData?, completion: (results: ResultType) -> Void) {
        fatalError("login method must be overridden in every child class")
    }

    func logout() {
        PFUser.logOut()
        currentUser = nil
        FBSDKLoginManager().logOut()

        let store = Twitter.sharedInstance().sessionStore
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
        }
    }

    func initiateUserWithPacks() {
        guard let user = currentUser else {
            return
        }

        let userQueue = FIRDatabase.database().reference().child("queues/user/tasks").childByAutoId()
        userQueue.setValue([
            "userId": user.id,
            "type": "initiatePacks"
        ])
    }

    internal func handleParseUser(completion: AccountManagerResultCallback) -> PFUserResultBlock {
        return { (user, error) in
            if error == nil {
                if user == nil {
                    completion(results: ResultType.Error(e: AccountManagerError.ReturnedEmptyUserObject))
                } else {
                    self.openSession(completion)
                }
            } else {
                self.logout()
                completion(results: ResultType.SystemError(e: error!))
            }
        }
    }

    internal func openSession(completion: (results: ResultType) -> Void) {}
    internal func fetchUserData(authData: FIRUser, completion: (results: ResultType) -> Void) {}
}

enum AccountManagerError: ErrorType {
    case MissingUserData
    case ReturnedEmptyUserObject
    case NotConnectedOnline
}