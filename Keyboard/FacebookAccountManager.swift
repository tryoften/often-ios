//
//  FacebookAccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 9/3/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation
import Firebase

class FacebookAccountManager: AccountManager {
    private let loginPermissions = [
        "public_profile",
        "email"
    ]

    private let requestPermissions = [
        "fields": "id, name, first_name, last_name, email"
    ]


    override func openSession(completion: (results: ResultType) -> Void) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            let accessTokenData = FBSDKAccessToken.currentAccessToken().tokenString

            if accessTokenData != nil {
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(accessTokenData)
                FIRAuth.auth()!.signInWithCredential(credential, completion: { (user, err) in
                    if err != nil {
                        completion(results: ResultType.SystemError(e: err!))
                    } else {
                        if let user = user {
                            self.fetchUserData(user, completion: completion)
                            self.initiateUserWithPacks()
                        }
                    }
                })
            }
        } else {
            completion(results: ResultType.Error(e: AccountManagerError.MissingUserData))
        }

        sessionManagerFlags.openSession = true
    }

    override func login(userData: UserAuthData?, completion: (results: ResultType) -> Void) {
        guard isNetworkReachable else {
            completion(results: ResultType.Error(e: AccountManagerError.NotConnectedOnline))
            return
        }

        let fbLogin = FBSDKLoginManager()

        fbLogin.logInWithReadPermissions(loginPermissions) { result, error -> Void in
            if error == nil {
                if result.isCancelled  {
                    completion(results: ResultType.Error(e: AccountManagerError.ReturnedEmptyUserObject))

                } else {
                    self.openSession(completion)
                    
                }
            } else {
                self.logout()
                completion(results: ResultType.SystemError(e: error!))
            }
        }

    }
    
    override func fetchUserData(authData: FIRUser, completion: AccountManagerResultCallback) {
        userRef = firebase.child("users/\(authData.uid)")
        sessionManagerFlags.userId = authData.uid

        if FBSDKAccessToken.currentAccessToken() != nil {
            print("Token is available : \(FBSDKAccessToken.currentAccessToken().tokenString)")

            let request = FBSDKGraphRequest(graphPath: "me", parameters: requestPermissions)

            request.startWithCompletionHandler({ (connection, result, error) -> Void in
                if error == nil {
                    guard let data = (result as? NSDictionary)?.mutableCopy() as? [String : AnyObject],
                        let userId = data["id"] as? String else {
                            completion(results: ResultType.Error(e: AccountManagerError.MissingUserData))
                            return
                    }

                    var userData = data

                    let profilePicURLTemplate = "https://graph.facebook.com/%@/picture?type=%@"

                    userData["id"] = authData.uid
                    userData["profile_pic_large"] = String(format: profilePicURLTemplate, userId, "large")
                    userData["backgroundImage"] = "user-profile-bg-1"

                    self.currentUser = User()
                    self.currentUser?.setValuesForKeysWithDictionary(userData)
                    self.userRef?.updateChildValues(userData)

                    if let user = self.currentUser {
                        completion(results: ResultType.Success(r: true))
                        self.delegate?.accountManagerUserDidLogin(self, user: user)
                    }
                    self.initiateUserWithPacks()
                } else {
                    completion(results: ResultType.SystemError(e: error!))
                }
            })
        }
    }

}
