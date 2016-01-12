//
//  AccountManagerProtocol.swift
//  Often
//
//  Created by Kervins Valcourt on 11/11/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

/**
 *  Protocol that defines a set of events need for user creation
 */
protocol AccountManagerProtocol {
    weak var delegate: AccountManagerDelegate? { get set }
    var currentUser: User? { get }

    init (firebase: Firebase)
    func login(userData: UserAuthData?, completion: (results: ResultType) -> Void)
    func logout()
}

enum AccountManagerType {
    case Email
    case Facebook
    case Twitter
    case Anonymous
}

enum ResultType {
    case Success(r: Bool)
    case Error(e: ErrorType)
    case SystemError(e: NSError)
}

protocol AccountManagerDelegate: class {
    func accountManagerUserDidLogin(accountManager: AccountManagerProtocol, user: User)
    func accountManagerUserDidLogout(accountManager: AccountManagerProtocol, user: User)
}