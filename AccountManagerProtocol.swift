//
//  AccountManagerProtocol.swift
//  Often
//
//  Created by Kervins Valcourt on 11/11/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation
import Firebase

/**
 *  Protocol that defines a set of events need for user creation
 */
protocol AccountManagerProtocol {
    weak var delegate: AccountManagerDelegate? { get set }
    var currentUser: User? { get }

    init (firebase: FIRDatabaseReference)
    func login(_ userData: UserAuthData?, completion: (results: ResultType) -> Void)
    func logout()
}

enum AccountManagerType {
    case email
    case facebook
    case twitter
    case anonymous
}

let AccountManagerTypes: [AccountManagerType: AccountManager.Type] = [
    .email: EmailAccountManager.self,
    .facebook: FacebookAccountManager.self,
    .twitter: TwitterAccountManager.self,
    .anonymous: AnonymousAccountManager.self
]

enum ResultType {
    case success(r: Bool)
    case error(e: ErrorProtocol)
    case systemError(e: NSError)
}

protocol AccountManagerDelegate: class {
    func accountManagerUserDidLogin(_ accountManager: AccountManagerProtocol, user: User)
    func accountManagerUserDidLogout(_ accountManager: AccountManagerProtocol, user: User)
    func accountManagerNoUserFound(_ accountManager: AccountManagerProtocol)
}
