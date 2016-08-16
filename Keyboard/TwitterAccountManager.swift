//
//  TwitterAccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 9/3/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation
import TwitterKit


class TwitterAccountManager: AccountManager {

    override func openSession(completion: (results: ResultType) -> Void) {
        fetchData(completion)
        sessionManagerFlags.openSession = true
        initiateUserWithPacks()
    }
    
    override func login(userData: UserAuthData?, completion: (results: ResultType) -> Void) {
        guard isNetworkReachable else {
            completion(results: ResultType.Error(e: AccountManagerError.NotConnectedOnline))
            return
        }

        Twitter.sharedInstance().logInWithCompletion { result, error in
            if error == nil {
                if result == nil {
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
    
    func fetchData(completion: ((results: ResultType) -> Void)? = nil) {
        func parseTwitterData(userID: String) {
            let client = TWTRAPIClient(userID: userID)
            client.loadUserWithID(userID) { (user, error) -> Void in
                if error == nil {
                    if user == nil {
                        completion?(results: ResultType.Error(e: AccountManagerError.ReturnedEmptyUserObject))
                    } else {
                        guard let user = user else {
                            return
                        }

                        let smallImage = user.profileImageURL
                        let largeImage = user.profileImageURL.stringByReplacingOccurrencesOfString("_normal", withString: "")

                        var firebaseData = [String: AnyObject]()
                        firebaseData["id"] = "twitter:\(userID)"
                        firebaseData["profileImageSmall"] = smallImage
                        firebaseData["profileImageLarge"] = largeImage
                        firebaseData["image"] = [
                            "small_url": smallImage,
                            "large_url": largeImage
                        ]
                        firebaseData["name"] = user.name
                        firebaseData["username"] = user.screenName
                        firebaseData["backgroundImage"] = "user-profile-bg-1"

                        let names = user.name.componentsSeparatedByString(" ")

                        if let firstName = names.first {
                            firebaseData["first_name"] = firstName
                        }

                        if let lastName = names.last {
                            firebaseData["last_name"] = lastName
                        }

                        self.currentUser?.setValuesForKeysWithDictionary(firebaseData)

                        if let user = self.currentUser {
                            self.userRef?.updateChildValues(user.dataChangedToDictionary())
                            completion?(results: ResultType.Success(r: true))
                            SessionManagerFlags.defaultManagerFlags.userLoginWithSocial = true
                            self.delegate?.accountManagerUserDidLogin(self, user: user)
                        }
                        self.initiateUserWithPacks()
                    }
                }
            }
        }

        guard let userID = Twitter.sharedInstance().sessionStore.session()?.userID else {
            completion?(results: ResultType.Error(e: AccountManagerError.ReturnedEmptyUserObject))
            return
        }

        userRef = firebase.child("users/twitter:\(userID)")
        sessionManagerFlags.userId = "twitter:\(userID)"
        self.currentUser = User()

        userRef?.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let value = snapshot.value as? [String: AnyObject] where snapshot.exists() {
                self.currentUser?.setValuesForKeysWithDictionary(value)

            } else {
                self.currentUser?.isNew = true
            }

            parseTwitterData(userID)
        })
    }

}
