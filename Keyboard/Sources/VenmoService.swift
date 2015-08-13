//
//  VenmoService.swift
//  Surf
//
//  Created by Komran Ghahremani on 7/17/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import UIKit

class VenmoService: NSObject {
    let manager: AFHTTPRequestOperationManager
    var currentUserID = ""
    var userDefaults: NSUserDefaults!
    var friends: [VenmoFriend]?
    
    override init() {
        manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html", "plain/html", "application/json") as Set<NSObject>
        
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)
        super.init()
    }
    
    /**
        Use the access token for the User to get the current users profile information
    
        :param: accessToken Token from the authorization GET call
    */
    func getCurrentUserInformation(accessToken: String) {
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
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                println("Success: \n\(responseObject.description)")
                
                if let friendsData = responseObject["data"] as? [AnyObject] {
                    self.userDefaults.setObject(friendsData, forKey: "friends")
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
