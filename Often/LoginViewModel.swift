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
        userAuthData = UserAuthData(name: "", email: "",  password: "", isNewUser: false)

        super.init()

        startMonitoring()
        self.sessionManager.delegate = self
    }

    deinit {
        self.sessionManager.delegate = nil
    }

    func login(accountType: AccountManagerType, completion: (results: ResultType) -> Void) throws {
        guard isNetworkReachable else {
            completion(results: ResultType.Error(e: SignupError.NotConnectedOnline))
            throw SignupError.NotConnectedOnline
        }

        guard let accountManager = AccountManagerTypes[accountType] else {
            throw AccountManagerError.MissingUserData
        }

        isNewUser = true

        do {
            try self.sessionManager.login(accountManager, userData: userAuthData,  completion: completion)
        } catch {

        }
    }

    func updateReachabilityView() {

    }

    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User) {
        isNewUser = user.isNew
        Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.login))
        delegate?.loginViewModelDidLoginUser(self, user: user)
    }

    func sessionManagerNoUserFound(sessionManager: SessionManager) {
        delegate?.loginViewModelNoUserFound(self)
    }
}

enum SignupError: ErrorType {
    case EmailNotVaild
    case PasswordNotVaild
    case NotConnectedOnline
    case TimeOut
}

protocol LoginViewModelDelegate: class {
    func loginViewModelDidLoginUser(userProfileViewModel: LoginViewModel, user: User?)
    func loginViewModelNoUserFound(userProfileViewModel: LoginViewModel)
}