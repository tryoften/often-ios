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

    override func openSession(_ completion: (results: ResultType) -> Void) {
        fetchData(completion)
        sessionManagerFlags.openSession = true
        initiateUserWithPacks()
    }
    
    override func login(_ userData: UserAuthData?, completion: (results: ResultType) -> Void) {
        guard isNetworkReachable else {
            completion(results: ResultType.error(e: AccountManagerError.notConnectedOnline))
            return
        }

        Twitter.sharedInstance().logIn { result, error in
            if error == nil {
                if result == nil {
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
    
    func fetchData(_ completion: ((results: ResultType) -> Void)? = nil) {
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            client.loadUser(withID: userID) { (user, error) -> Void in
                if error == nil {
                    if user == nil {
                        completion?(results: ResultType.error(e: AccountManagerError.returnedEmptyUserObject))
                    } else {
                        var firebaseData = [String: AnyObject]()
                        firebaseData["id"] = "twitter:\(userID)"
                        firebaseData["profileImageURL"] = user?.profileImageLargeURL
                        firebaseData["name"] = user?.name
                        firebaseData["username"] = user?.screenName
                        firebaseData["backgroundImage"] = "user-profile-bg-1"

                        if self.sessionManagerFlags.userId == nil {
                            guard let userIDWithProvider = firebaseData["id"] as? String else {
                                completion?(results: ResultType.error(e: AccountManagerError.returnedEmptyUserObject))
                                return
                            }

                            self.sessionManagerFlags.userId = userIDWithProvider
                            self.userRef = self.firebase.child(byAppendingPath: "users/\(userIDWithProvider)")

                            self.currentUser = User()
                            self.currentUser?.setValuesForKeys(firebaseData)

                            if let user = self.currentUser {
                                self.userRef?.updateChildValues(user.dataChangedToDictionary())
                                completion?(results: ResultType.success(r: true))
                                self.delegate?.accountManagerUserDidLogin(self, user: user)
                            }
                            self.initiateUserWithPacks()
                        }
                    }
                }
            }
        }
    }

}
