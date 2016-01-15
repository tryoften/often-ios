//
//  FacebookAccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 9/3/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class FacebookAccountManager: AccountManager {
    let permissions = [
        "public_profile",
        "user_actions.music",
        "user_likes",
        "email"
    ]

    override func openSession(completion: (results: ResultType) -> Void) {
        if let session = FBSession.activeSession() {
            let accessTokenData = session.accessTokenData

            if accessTokenData != nil {
                let accessToken = accessTokenData.accessToken
                firebase.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, accessToken in
                        if error != nil {
                            completion(results: ResultType.SystemError(e: error!))
                        } else {
                            self.fetchUserData(accessToken, completion: completion)
                        }
                })
            }
        } else {
            completion(results: ResultType.Error(e: FacebookAccountManagerError.MissingUserData))
        }

        sessionManagerFlags.openSession = true
    }

    override func login(userData: UserAuthData?, completion: (results: ResultType) -> Void) {
        guard isInternetReachable else {
            completion(results: ResultType.Error(e: FacebookAccountManagerError.NotConnectedOnline))
            return
        }
        
        PFFacebookUtils.logInWithPermissions(permissions, block: { (user, error) in
            if error == nil {
                if user != nil {
                    self.openSession(completion)
                } else {
                    completion(results: ResultType.Error(e: FacebookAccountManagerError.ReturnedEmptyUserObject))
                }
            } else {
                 completion(results: ResultType.SystemError(e: error!))
            }
        })

    }
    
    override func fetchUserData(authData: FAuthData, completion: (results: ResultType) -> Void) {
        userRef = firebase.childByAppendingPath("users/\(authData.uid)")

        let request = FBRequest.requestForMe()
        request.startWithCompletionHandler({ (connection, result, error) in
            if error == nil {
                guard let data = (result as? NSDictionary)?.mutableCopy() as? [String : AnyObject],
                    let userId = data["id"] as? String else {
                        completion(results: ResultType.Error(e: FacebookAccountManagerError.MissingUserData))
                        return
                }

                var userData = data

                let profilePicURLTemplate = "https://graph.facebook.com/%@/picture?type=%@"

                userData["profile_pic_small"] = String(format: profilePicURLTemplate, userId, "small")
                userData["profile_pic_large"] = String(format: profilePicURLTemplate, userId, "large")
                userData["backgroundImage"] = "user-profile-bg-\(arc4random_uniform(4) + 1)"

                self.currentUser = User()
                self.currentUser?.setValuesForKeysWithDictionary(userData)
                self.userRef?.updateChildValues(userData)

                if let user = self.currentUser {
                    completion(results: ResultType.Success(r: true))
                    self.delegate?.accountManagerUserDidLogin(self, user: user)
                }

            } else {
                completion(results: ResultType.SystemError(e: error!))
            }
        })
    }
}

enum FacebookAccountManagerError: ErrorType {
    case MissingUserData
    case ReturnedEmptyUserObject
    case NotConnectedOnline
}
