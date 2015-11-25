 //
//  SignupViewModel.swift
//  Often
//
//  Created by Kervins Valcourt on 9/8/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class SignupViewModel: NSObject, SessionManagerObserver {
    weak var delegate: SignupViewModelDelegate?
    var sessionManager: SessionManager
    var user: User
    var password: String
    var isInternetReachable: Bool
    
    enum ResultType {
        case Success(r: Bool)
        case Error(e: ErrorType)
        case SystemError(e: NSError)
    }
    
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
    
    func signUpUser(completion: (results: ResultType) -> Void) throws {
        var userData = [String: String]()
        
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
        
        userData["email"] = user.email.lowercaseString
        userData["username"] = user.username.lowercaseString
        userData["password"] = password
        
        sessionManager.signupUser(.Email, data: userData, completion: { error -> () in
            if error == nil {
                print("all good in the hood")
                completion(results: ResultType.Success(r: true))
            } else {
                print("no good mang")
                completion(results: ResultType.SystemError(e: error!))
            }
        })
    }
    
    func signInUser(username:String, password:String, completion: (results: ResultType) -> Void) throws {
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
        
        sessionManager.loginWithUsername(username.lowercaseString, password: password) { error  in
            if error == nil {
                print("all good in the hood")
                completion(results: ResultType.Success(r: true))
            } else {
                print("no good mang")
                completion(results: ResultType.SystemError(e: error!))
            }
        }
        
    }

    
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
    }
    
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool) {
        self.user = user
        delegate?.signupViewModelDidLoginUser(self, user: user, isNewUser: isNewUser)
    }
    
    func sessionManagerDidFetchSocialAccounts(sessionsManager: SessionManager, socialAccounts: [String: AnyObject]?) {
    }
    
    func sessionManagerNoUserFound(sessionManager: SessionManager) {
        delegate?.signupViewModelNoUserFound(self)
    }
}
 
 enum SignupError: ErrorType {
    case EmailNotVaild
    case PasswordNotVaild
    case NotConnectedOnline
    case TimeOut
 }
 
protocol SignupViewModelDelegate: class {
    func signupViewModelDidLoginUser(userProfileViewModel: SignupViewModel, user: User?, isNewUser: Bool)
    func signupViewModelNoUserFound(userProfileViewModel: SignupViewModel)
}