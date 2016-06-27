//
//  LoginViewModel.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/16/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class LoginViewModel: NSObject, SessionManagerDelegate, ConnectivityObservable {
    weak var delegate: LoginViewModelDelegate?
    var sessionManager: SessionManager
    var isNewUser: Bool
    var userAuthData: UserAuthData
    var isNetworkReachable: Bool = true

    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager

        isNewUser = false
        userAuthData = UserAuthData(username: "", email: "",  password: "", isNewUser: false)

        super.init()

        startMonitoring()
        self.sessionManager.delegate = self
    }

    deinit {
        self.sessionManager.delegate = nil
    }

    func login(_ accountType: AccountManagerType, completion: (results: ResultType) -> Void) throws {
        guard isNetworkReachable else {
            completion(results: ResultType.error(e: SignupError.notConnectedOnline))
            throw SignupError.notConnectedOnline
        }

        guard let accountManager = AccountManagerTypes[accountType] else {
            throw AccountManagerError.missingUserData
        }

        isNewUser = true

        do {
            try self.sessionManager.login(accountManager, userData: userAuthData,  completion: completion)
        } catch {

        }

    }

    func updateReachabilityView() {

    }

    func sessionManagerDidLoginUser(_ sessionManager: SessionManager, user: User) {
        Analytics.shared().track(AnalyticsProperties(eventName: AnalyticsEvent.login))
        delegate?.loginViewModelDidLoginUser(self, user: user)

    }

    func sessionManagerNoUserFound(_ sessionManager: SessionManager) {
        delegate?.loginViewModelNoUserFound(self)
    }
}

enum SignupError: ErrorProtocol {
    case emailNotVaild
    case passwordNotVaild
    case notConnectedOnline
    case timeOut
}

protocol LoginViewModelDelegate: class {
    func loginViewModelDidLoginUser(_ userProfileViewModel: LoginViewModel, user: User?)
    func loginViewModelNoUserFound(_ userProfileViewModel: LoginViewModel)
}
