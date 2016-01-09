//
//  AccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 11/11/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

/**
 *  Protocol that defines a set of events need for user creation
 */
protocol AccountManager {
    var sessionManagerFlags: SessionManagerFlags { get set }
    var firebase: Firebase { get set }
    var userRef: Firebase? { get set }
    weak var delegate: AccountManagerDelegate? { get set }
    var isInternetReachable: Bool { get set }
    var newUser: User? { get set }

    init(firebase: Firebase)
    func openSession(completion: (results: ResultType) -> Void)
    func login(userData: User?, completion: (results: ResultType) -> Void)
    func fetchUserData(authData: FAuthData, completion: (results: ResultType) -> Void)
}

enum ResultType {
    case Success(r: Bool)
    case Error(e: ErrorType)
    case SystemError(e: NSError)
}
protocol AccountManagerDelegate: class {
    func accountManagerUserDidLogin(accountManager: AccountManager, user: User)
    func accountManagerDidAddSocialAccount(accountManager: AccountManager, account: SocialAccount)
}