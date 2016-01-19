//
//  LoginViewModel.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/16/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class LoginViewModel: NSObject, SessionManagerDelegate {
    weak var delegate: LoginViewModelDelegate?
    var sessionManager: SessionManager
    var isNewUser: Bool

    private var userAuthData: UserAuthData
    private var isInternetReachable: Bool
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager

        isNewUser = false
        let reachabilitymanager = AFNetworkReachabilityManager.sharedManager()
        isInternetReachable = reachabilitymanager.reachable

        userAuthData = UserAuthData(username: "", email: "",  password: "", isNewUser: false)

        super.init()

        reachabilitymanager.setReachabilityStatusChangeBlock { status in
            self.isInternetReachable = reachabilitymanager.reachable
        }
        reachabilitymanager.startMonitoring()

        self.sessionManager.delegate = self
    }

    deinit {
        self.sessionManager.delegate = nil
    }

    func createNewEmailUser(username: String, email: String, password: String, completion: (results: ResultType) -> Void) throws {
        guard AFNetworkReachabilityManager.sharedManager().reachable else {
            completion(results: ResultType.Error(e: SignupError.NotConnectedOnline))
            delegate?.loginViewModelNoUserFound(self)
            throw SignupError.EmailNotVaild
        }

        guard EmailIsValid(email) else {
            completion(results: ResultType.Error(e: SignupError.EmailNotVaild))
            delegate?.loginViewModelNoUserFound(self)
            throw SignupError.EmailNotVaild
        }

        guard PasswordIsValid(password) else {
            completion(results: ResultType.Error(e: SignupError.PasswordNotVaild))
            delegate?.loginViewModelNoUserFound(self)
            throw SignupError.PasswordNotVaild
        }

        isNewUser = true

        userAuthData.username = username.lowercaseString
        userAuthData.email = email.lowercaseString
        userAuthData.password = password
        userAuthData.isNewUser = true

        do {
            try sessionManager.login(EmailAccountManager.self, userData: userAuthData) { (results) -> Void in
                switch results {
                case .Success(_): completion(results: ResultType.Success(r: true))
                case .Error(let err): completion(results: ResultType.Error(e: err))
                case .SystemError(let err): completion(results: ResultType.SystemError(e: err))
                }
            }
        } catch {

        }
    }

    func signInUser(username: String, password: String, completion: (results: ResultType) -> Void) throws {
        guard isInternetReachable else {
            completion(results: ResultType.Error(e: SignupError.NotConnectedOnline))
            delegate?.loginViewModelNoUserFound(self)
            throw SignupError.NotConnectedOnline
        }

        guard EmailIsValid(username) else {
            completion(results: ResultType.Error(e: SignupError.EmailNotVaild))
            delegate?.loginViewModelNoUserFound(self)
            throw SignupError.EmailNotVaild
        }

        guard PasswordIsValid(password) else {
            completion(results: ResultType.Error(e: SignupError.PasswordNotVaild))
            delegate?.loginViewModelNoUserFound(self)
            throw SignupError.PasswordNotVaild
        }

        isNewUser = true

        userAuthData.email = username.lowercaseString
        userAuthData.password = password
        userAuthData.isNewUser = false

        do {
            try sessionManager.login(EmailAccountManager.self, userData: userAuthData) { (results) -> Void in
                switch results {
                case .Success(_): completion(results: ResultType.Success(r: true))
                case .Error(let err): completion(results: ResultType.Error(e: err))
                case .SystemError(let err): completion(results: ResultType.SystemError(e: err))
                }
            }
        } catch {

        }
    }

    func loginWithFacebook(completion: (results: ResultType) -> Void) throws {
        guard isInternetReachable else {
            completion(results: ResultType.Error(e: SignupError.NotConnectedOnline))
            delegate?.loginViewModelNoUserFound(self)
            throw SignupError.NotConnectedOnline
        }

        isNewUser = true

        do {
            try sessionManager.login(FacebookAccountManager.self, userData: nil,  completion: { results  -> Void in
                switch results {
                case .Success(_): completion(results: ResultType.Success(r: true))
                case .Error(let err): completion(results: ResultType.Error(e: err))
                case .SystemError(let err): completion(results: ResultType.SystemError(e: err))
                }
            })
        } catch {
            
        }
    }

    func loginAnonymously(completion: (results: ResultType) -> Void) throws {
        guard isInternetReachable else {
            completion(results: ResultType.Error(e: SignupError.NotConnectedOnline))
            delegate?.loginViewModelNoUserFound(self)
            throw SignupError.NotConnectedOnline
        }

        isNewUser = true

        do {
            try sessionManager.login(AnonymousAccountManager.self, userData: nil,  completion: { results  -> Void in
                switch results {
                case .Success(_): completion(results: ResultType.Success(r: true))
                case .Error(let err): completion(results: ResultType.Error(e: err))
                case .SystemError(let err): completion(results: ResultType.SystemError(e: err))
                }
            })
        } catch {

        }
    }

    func loginWithTwitter(completion: (results: ResultType) -> Void) throws {
        guard isInternetReachable else {
            completion(results: ResultType.Error(e: SignupError.NotConnectedOnline))
            delegate?.loginViewModelNoUserFound(self)
            throw SignupError.NotConnectedOnline
        }

        isNewUser = true

        do {
            try sessionManager.login(TwitterAccountManager.self, userData: nil, completion: { results  -> Void in
                switch results {
                case .Success(_): completion(results: ResultType.Success(r: true))
                case .Error(let err): completion(results: ResultType.Error(e: err))
                case .SystemError(let err): completion(results: ResultType.SystemError(e: err))
                }
            })
        } catch {

        }
    }


    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
    }

    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User) {
        delegate?.loginViewModelDidLoginUser(self, user: user)
    }

    func sessionManagerDidFetchSocialAccounts(sessionsManager: SessionManager, socialAccounts: [String: AnyObject]?) {
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