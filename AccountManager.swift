//
//  AccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 1/11/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class AccountManager: AccountManagerProtocol {
    weak var delegate: AccountManagerDelegate?
    var currentUser: User?

    final internal var sessionManagerFlags: SessionManagerFlags = SessionManagerFlags.defaultManagerFlags
    internal var userRef: Firebase?
    internal var firebase: Firebase
    internal var isInternetReachable: Bool


   required init (firebase: Firebase) {
        self.firebase = firebase
        let reachabilitymanager = AFNetworkReachabilityManager.sharedManager()
        isInternetReachable = reachabilitymanager.reachable

        reachabilitymanager.setReachabilityStatusChangeBlock { status in
            self.isInternetReachable = reachabilitymanager.reachable
        }

        reachabilitymanager.startMonitoring()

    }

    func login(userData: UserAuthData?, completion: (results: ResultType) -> Void) {
        fatalError("login method must be overridden in every child class")
    }

    final func logout() {
        currentUser = nil
        sessionManagerFlags.clearSessionFlags()
    }

    internal func openSession(completion: (results: ResultType) -> Void) {}
    internal func fetchUserData(authData: FAuthData, completion: (results: ResultType) -> Void) {}
}