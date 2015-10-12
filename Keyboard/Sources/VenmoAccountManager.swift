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
                print("Permissions Success!")
            } else {
                print("Permissions Fail")
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
        venmoAccount?.token = session.accessToken
        venmoAccount?.activeStatus = true
        venmoAccount?.tokenExpirationDate = session.expirationDate.description
        venmoAccount?.type = .Venmo
        
        if let venmoAccount = self.venmoAccount {
            self.delegate?.venmoAccountManagerDidPullToken(self, account: venmoAccount)
        }

    }
    
    /**
        Use the access token for the User to get the current users profile information
    
        - parameter accessToken: Token from the authorization GET call
    */

    func getVenmoUserInformation(accessToken: String) {
        let parameters: NSDictionary = ["accessToken": accessToken]
    
        manager.GET(
            "https://api.venmo.com/v1/me",
            parameters: parameters,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject) in
                
                print("Success: \n\(responseObject.description)")
                if let response = responseObject as? [String: AnyObject],
                    let responseData = response["data"] as? [String : AnyObject] {
                    if let userData = responseData["user"] as? [String : AnyObject] {
                        self.currentUserID = userData["id"] as! String
                    }
                }
                self.getCurrentUserListOfFriend(accessToken, id: self.currentUserID)
               
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                print("Failure: \(error.localizedDescription)")
        })
    }
    
    /**
        Retrieve contact list for the current user to populate the collection view
    
        - parameter accessToken: Token from the authorization GET call
        - parameter id: USer id from the User information call
    */
    func getCurrentUserListOfFriend(accessToken: String, id: String) {
        var parameters: NSDictionary = ["accessToken": accessToken, "limit": 500]
        
        func successCallback(operation: AFHTTPRequestOperation, responseObject: AnyObject) -> Void {
            print("Success: \n\(responseObject.description)")
            
            if let response = responseObject as? [String: AnyObject],
                friendsData = response["data"] as? [AnyObject] {
                    do {
                        let data = try NSJSONSerialization.dataWithJSONObject(friendsData, options: [])
                        self.userDefaults.setObject(data, forKey: "friends")
                        self.userDefaults.synchronize()
                    } catch let error as NSError {
                        print(error)
                    } catch {
                        
                    }
            }
        }
        
        manager.GET(
            "https://api.venmo.com/v1/users/\(id)/friends",
            parameters: parameters,
            success: successCallback,
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                print("Failure: \(error.localizedDescription)")
        })
    }
    
    /**
        Use all of the information we retrieved to allow the user to send a payment to someone
    
        - parameter accessToken: Token from the authorization GET call
        - parameter handle: Handle of target user
        - parameter amount: How much to send to the target user
        - parameter note: Note to describe the payment
    */
    func sendPayment(handle: String, amount: UInt, note: String) {
        Venmo.sharedInstance().sendPaymentTo(handle, amount: amount, note: note) { (transaction, success, error) -> Void in
            if success {
                print("Transaction Succeeded")
            } else {
                print("Transaction Failed")
            }
        }
    }
    
    func sendRequest(handle: String, amount: UInt, note: String) {
        Venmo.sharedInstance().sendRequestTo(handle, amount: amount, note: note) { (transaction, success, error) -> Void in
            if success {
                print("Transaction Succeeded")
            } else {
                print("Transaction Failed")
            }
        }
    }
}

protocol VenmoAccountManagerDelegate: class {
    func venmoAccountManagerDidPullToken(userProfileViewModel: VenmoAccountManager, account: SocialAccount)
}
