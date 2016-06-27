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


    override func openSession(_ completion: (results: ResultType) -> Void) {
        if FBSDKAccessToken.current() != nil {
            let accessTokenData = FBSDKAccessToken.current().tokenString

            if accessTokenData != nil {
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenData!)

                FIRAuth.auth()?.signIn(with: credential, completion: { (user, err) in
                    if err != nil {
                        completion(results: ResultType.systemError(e: err!))
                    } else {
                        if let user = user {
                            self.fetchUserData(user, completion: completion)
                            self.initiateUserWithPacks()
                        }
                    }
                })
            }
        } else {
            completion(results: ResultType.error(e: AccountManagerError.missingUserData))
        }

        sessionManagerFlags.openSession = true
    }

    override func login(_ userData: UserAuthData?, completion: (results: ResultType) -> Void) {
        guard isNetworkReachable else {
            completion(results: ResultType.error(e: AccountManagerError.notConnectedOnline))
            return
        }

        let fbLogin = FBSDKLoginManager()

        fbLogin.logIn(withReadPermissions: loginPermissions) { result, error -> Void in
            if error == nil {
                if ((result?.isCancelled) != nil)  {
                    completion(results: ResultType.error(e: AccountManagerError.returnedEmptyUserObject))

                } else {
                    self.openSession(completion)
                    
                }
            } else {
                self.logout()
                completion(results: ResultType.systemError(e: error!))
            }
        }

    }
    
    override func fetchUserData(_ authData: FIRUser, completion: AccountManagerResultCallback) {
        userRef = firebase.child("users/\(authData.uid)")
        sessionManagerFlags.userId = authData.uid

        if FBSDKAccessToken.current() != nil {
            print("Token is available : \(FBSDKAccessToken.current().tokenString)")

            let request = FBSDKGraphRequest(graphPath: "me", parameters: requestPermissions)

            request?.start(completionHandler: { (connection, result, error) -> Void in
                if error == nil {
                    guard let data = (result as? NSDictionary)?.mutableCopy() as? [String : AnyObject],
                        let userId = data["id"] as? String else {
                            completion(results: ResultType.error(e: AccountManagerError.missingUserData))
                            return
                    }

                    var userData = data

                    let profilePicURLTemplate = "https://graph.facebook.com/%@/picture?type=%@"

                    userData["id"] = authData.uid
                    userData["profile_pic_large"] = String(format: profilePicURLTemplate, userId, "large")
                    userData["backgroundImage"] = "user-profile-bg-1"

                    self.currentUser = User()
                    self.currentUser?.setValuesForKeys(userData)
                    self.userRef?.updateChildValues(userData)

                    if let user = self.currentUser {
                        completion(results: ResultType.success(r: true))
                        self.delegate?.accountManagerUserDidLogin(self, user: user)
                    }
                    self.initiateUserWithPacks()
                } else {
                    completion(results: ResultType.systemError(e: error!))
                }
            })
        }
    }

}
