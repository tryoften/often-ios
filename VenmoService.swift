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
    
    override init() {
        manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html", "plain/html") as Set<NSObject>
        super.init()
    }
    
    /**
        Server Side Flow:
    
        Need to redirect the user to URL and have them authorize through Venmo
        That will return a redirect URL with an authorization code
        Then use the Authorization Code in a POST call
        Token lasts for 60 days
    
        Client Side Flow:
        
        Get request to Venmo authorize URL to retrieve access token in 
        returned redirect URL
    
        :param: clientID our developer client id
    
    */
    func authorizeUserAndGetAccessToken(clientID: String) {
    
        var parameters: NSDictionary = ["client_id": appClientID, "scope": "access_profile", "response_type": "token"]
        
        manager.GET("https://api.venmo.com/v1/oauth/authorize",
            parameters: parameters,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                println("Success: \n\(operation.response.URL?.absoluteString)")
                // need to parse return URL and retrieve token
                
                var name = "accessToken"
                
                self.getParameterByName(name)
                
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                println(operation.response.URL?.absoluteString)
                println("Failure: \(error.localizedDescription)")
        })
    }
    
    func getParameterByName(name: String) {
        
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
        var parameters: NSDictionary = ["accessToken": accessToken]
        
        manager.GET(
            "https://api.venmo.com/v1/users/\(id)/friends",
            parameters: parameters,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                println("Success: \n\(responseObject.description)")
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
