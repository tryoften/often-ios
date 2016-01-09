//
//  LoginViewModel.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/16/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class LoginViewModel: NSObject, SessionManagerObserver {
    weak var delegate: LoginViewModelDelegate?
    var sessionManager: SessionManager
    var user: User
    var password: String
    var isInternetReachable: Bool

    init(sessionManager: SessionManager) {

        self.sessionManager = sessionManager
        let reachabilitymanager = AFNetworkReachabilityManager.sharedManager()
        isInternetReachable = reachabilitymanager.reachable

        user = User()
        password = ""

        super.init()

        reachabilitymanager.setReachabilityStatusChangeBlock { status in
            self.isInternetReachable = reachabilitymanager.reachable
        }
        reachabilitymanager.startMonitoring()

        self.sessionManager.addSessionObserver(self)
    }

    deinit {
        sessionManager.removeSessionObserver(self)
    }

    func createNewEmailUser(username: String, email: String, password: String, completion: (results: ResultType) -> Void) throws {

        guard AFNetworkReachabilityManager.sharedManager().reachable else {
            completion(results: ResultType.Error(e: SignupError.NotConnectedOnline))
            throw SignupError.EmailNotVaild
        }

        guard EmailIsValid(user.email) else {
            completion(results: ResultType.Error(e: SignupError.EmailNotVaild))
            throw SignupError.EmailNotVaild
        }

        guard PasswordIsValid(password) else {
            completion(results: ResultType.Error(e: SignupError.PasswordNotVaild))
            throw SignupError.PasswordNotVaild
        }

        user.username = username.lowercaseString
        user.email = user.email.lowercaseString
        user.password = password
        user.isNew = true

        do {
            try sessionManager.login(.Email, userData: user) { (results) -> Void in
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
            throw SignupError.NotConnectedOnline
        }

        guard EmailIsValid(username) else {
            completion(results: ResultType.Error(e: SignupError.EmailNotVaild))
            throw SignupError.EmailNotVaild
        }

        guard PasswordIsValid(password) else {
            completion(results: ResultType.Error(e: SignupError.PasswordNotVaild))
            throw SignupError.PasswordNotVaild
        }


        user.email = username.lowercaseString
        user.password = password
        user.isNew = false

        do {
            try sessionManager.login(.Email, userData: user) { (results) -> Void in
                switch results {
                case .Success(_): completion(results: ResultType.Success(r: true))
                case .Error(let err): completion(results: ResultType.Error(e: err))
                case .SystemError(let err): completion(results: ResultType.SystemError(e: err))
                }
            }
        } catch {

        }
    }

    func showErrorView(error: ErrorType) {
        switch error {
        case TwitterAccountManagerError.ReturnedEmptyUserObject:
            DropDownErrorMessage().setMessage("Unable to sign in. please try again", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case TwitterAccountManagerError.NotConnectedOnline, SignupError.NotConnectedOnline:
            DropDownErrorMessage().setMessage("Need to be connected to the internet", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case SessionManagerError.UnvalidSignUp:
            DropDownErrorMessage().setMessage("Unable to sign in. please try again", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case SignupError.EmailNotVaild:
            DropDownErrorMessage().setMessage("Please enter a vaild email", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case SignupError.PasswordNotVaild:
            DropDownErrorMessage().setMessage("Please enter a vaild password", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case FacebookAccountManagerError.ReturnedEmptyUserObject:
            DropDownErrorMessage().setMessage("Unable to create account. Please try again", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case FacebookAccountManagerError.NotConnectedOnline, SignupError.NotConnectedOnline:
            DropDownErrorMessage().setMessage("No internet connection fam :(", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        default:
            DropDownErrorMessage().setMessage("Unable to sign in. please try again", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        }
    }

    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
    }

    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool) {
        self.user = user
        delegate?.loginViewModelDidLoginUser(self, user: user, isNewUser: isNewUser)
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
    func loginViewModelDidLoginUser(userProfileViewModel: LoginViewModel, user: User?, isNewUser: Bool)
    func loginViewModelNoUserFound(userProfileViewModel: LoginViewModel)
}