//
//  SocialAccountsService.swift
//  Often
//
//  Created by Kervins Valcourt on 8/13/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit
/// Service that provides and manages SocialAccount models along with categories.
/// It stores the data both locally and remotely

class SocialAccountsService: Service {
    let user: User
    var socialAccountsRef: Firebase
    var socialAccounts: [String : AnyObject]?
    let socialAccountsPath = "socialAccounts"
    var isUpdatingSocialAccount = false
    
    
    init(user: User, root: Firebase) {
        self.user = user
        socialAccountsRef = root.childByAppendingPath("users/\(user.id)/accounts")
        socialAccountsRef.keepSynced(true)
        
        super.init(root: root)
    }
    
    /**
    Fetches data from the local database and creates models
    
    :param: completion: callback that gets called when data has loaded
    */
    func fetchLocalData(completion: (Bool) -> Void) {
        createSocialAccountsModels(completion)
    }
    
    func updateSocialAccount(socialAccount: SocialAccount){
        socialAccountsRef.childByAppendingPath(socialAccount.type.rawValue).setValue(socialAccount.toDictionary())
    }
    
    /**
    Creates social service models from the default NSUserDefaults
    */
    private func createSocialAccountsModels(completion: (Bool) -> Void) {
        socialAccountsRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            if snapshot.exists() {
                if let value = snapshot.value as? [String: AnyObject] {
                        self.socialAccounts = value
                        completion(true)
                }
            } else {
                completion(true)
            }
            
            }) { err -> Void in
                
        }
        
        delegate?.serviceDataDidLoad(self)
    }
    
}

protocol SocialAccountServiceDelegate: ServiceDelegate {}
