//
//  AccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 11/11/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation
class AccountManager: NSObject {
    let sessionManagerFlags = SessionManagerFlags.defaultManagerFlags
    var firebase: Firebase
    var userRef: Firebase?
    weak var delegate: AccountManagerDelegate?
    var isInternetReachable: Bool
    var newUser: User?

    enum ResultType {
        case Success(r: Bool)
        case Error(e: ErrorType)
        case SystemError(e: NSError)
    }
    
    init(firebase: Firebase) {
        self.firebase = firebase
       
        let reachabilitymanager = AFNetworkReachabilityManager.sharedManager()
        isInternetReachable = reachabilitymanager.reachable
        
        super.init()
        
        reachabilitymanager.setReachabilityStatusChangeBlock { status in
            self.isInternetReachable = reachabilitymanager.reachable
        }
        
        reachabilitymanager.startMonitoring()
    }

    func openSession(completion: (results: ResultType) -> Void) {}
    func login(userData: User?, completion: (results: ResultType) -> Void) {}
    func fetchUserData(authData: FAuthData, completion: (results: ResultType) -> Void) {}
}

protocol AccountManagerDelegate: class {
    func accountManagerUserDidLogin(accountManager: AccountManager, user: User)
    func accountManagerDidAddSocialAccount(accountManager: AccountManager, account: SocialAccount)
}