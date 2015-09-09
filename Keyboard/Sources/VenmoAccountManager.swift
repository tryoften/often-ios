//
//  VenmoAccountManager.swift
//  Surf
//
//  Created by Komran Ghahremani on 7/17/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import UIKit

class VenmoAccountManager: NSObject {
    let manager: AFHTTPRequestOperationManager
    var currentUserID = ""
    var userDefaults: NSUserDefaults!
    var friends: [VenmoFriend]?
    var venmoAccount: SocialAccount?
    weak var delegate: VenmoAccountManagerDelegate?
    override init() {
        manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html", "plain/html", "application/json") as Set<NSObject>
        
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)
        super.init()
    }
    
    func createRequest() {
        Venmo.startWithAppId(VenmoAppID, secret: VenmoAppSecret, name: "SWRV")
        Venmo.sharedInstance().requestPermissions(["make_payments", "access_profile", "access_friends"]) { (success, error) -> Void in
            if success {
                println("Permissions Success!")
            } else {
                println("Permissions Fail")
            }
        }
        
        if Venmo.isVenmoAppInstalled() {
            Venmo.sharedInstance().defaultTransactionMethod = VENTransactionMethod.API
        } else {
            Venmo.sharedInstance().defaultTransactionMethod = VENTransactionMethod.AppSwitch
        }

    }
    
    func getCurrentCurrentSessionToken(session: VENSession) {
        venmoAccount = SocialAccount()
        venmoAccount?.type = .Venmo
        venmoAccount?.token = session.accessToken
        venmoAccount?.activeStatus = true
        venmoAccount?.tokenExpirationDate = session.expirationDate.description
        
        if let venmoAccount = self.venmoAccount {
            self.delegate?.venmoAccountManagerDidPullToken(self, account: venmoAccount)
        }

    }
    
    /**
        Use the access token for the User to get the current users profile information
    
        :param: accessToken Token from the authorization GET call
    */

    func getVenmoUserInformation(accessToken: String) {
        var parameters: NSDictionary = ["accessToken": accessToken]
    
        manager.GET(
            "https://api.venmo.com/v1/me",
            parameters: parameters,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                println("Success: \n\(responseObject.description)")
                if let responseData = responseObject["data"] as? [String : AnyObject] {
                    if let userData = responseData["user"] as? [String : AnyObject] {
                        self.currentUserID = userData["id"] as! String
                    }
                }
                self.getCurrentUserListOfFriend(accessToken, id: self.currentUserID)
               
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                println("Failure: \(error.localizedDescription)")
        })
    }
    
    /**
        Retrieve contact list for the current user to populate the collection view
    
        :param: accessToken Token from the authorization GET call
        :param: id USer id from the User information call
    */
    func getCurrentUserListOfFriend(accessToken: String, id: String) {
        var parameters: NSDictionary = ["accessToken": accessToken, "limit": 500]
        
        manager.GET(
            "https://api.venmo.com/v1/users/\(id)/friends",
            parameters: parameters,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject) in
                println("Success: \n\(responseObject.description)")
                
                if let friendsData = responseObject["data"] as? [AnyObject] {
                    var data = NSJSONSerialization.dataWithJSONObject(friendsData, options: nil, error: nil)
                    self.userDefaults.setObject(data, forKey: "friends")
                    self.userDefaults.synchronize()
                }
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                println("Failure: \(error.localizedDescription)")
        })
    }
    
    /**
        Use all of the information we retrieved to allow the user to send a payment to someone
    
        :param: accessToken Token from the authorization GET call
        :param: handle Handle of target user
        :param: amount How much to send to the target user
        :param: note Note to describe the payment
    */
    func sendPayment(handle: String, amount: UInt, note: String) {
        Venmo.sharedInstance().sendPaymentTo(handle, amount: amount, note: note) { (transaction, success, error) -> Void in
            if success {
                println("Transaction Succeeded")
            } else {
                println("Transaction Failed")
            }
        }
    }
    
    func sendRequest(handle: String, amount: UInt, note: String) {
        Venmo.sharedInstance().sendRequestTo(handle, amount: amount, note: note) { (transaction, success, error) -> Void in
            if success {
                println("Transaction Succeeded")
            } else {
                println("Transaction Failed")
            }
        }
    }
}

protocol VenmoAccountManagerDelegate: class {
    func venmoAccountManagerDidPullToken(userProfileViewModel: VenmoAccountManager, account: SocialAccount)
}
