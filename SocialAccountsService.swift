//
//  SocialAccountsService.swift
//  Often
//
//  Created by Kervins Valcourt on 8/13/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class SocialAccountsService: Service {
    let user: User
    var socialAccountsRef: Firebase
    var socialAccounts: [String: SocialAccount] {
        didSet {
            var socialAccountList = sorted(self.socialAccounts.values.array) {$0.name < $1.name}
            for var i = 0; i < socialAccountList.count; i++ {
                socialAccountList[i].index = i
            }
            sortedSocialAccounts = socialAccountList
        }
    }
    
    var sortedSocialAccounts: [SocialAccount]
    let socialAccountsPath = "socialAccounts"
    var isUpdatingSocialAccount = false
    
    init(user: User, root: Firebase) {
        self.user = user
        socialAccountsRef = root.childByAppendingPath(socialAccountsPath)
        sortedSocialAccounts = [SocialAccount]()
        socialAccounts = [String: SocialAccount]()
        
        super.init(root: root)
        
    }
    
    /**
    Fetches data from the local database and creates models
    
    :param: completion callback that gets called when data has loaded
    */
    func fetchLocalData(completion: (Bool) -> Void) {
        createSocialAccountsModels(completion)
    }
    
    /**
    Creates social service models from the default NSUserDefaults
    */
    private func createSocialAccountsModels(completion: (Bool) -> Void) {
        if let services = userDefaults.arrayForKey(socialAccountsPath)
        {
            sortedSocialAccounts = services as! [SocialAccount]
            delegate?.serviceDataDidLoad(self)
            completion(true)
        }
    }
    
    /**
    Listens for changes on the server (firebase) database and updates
    the local database, then notifies the delegate and calls the completion callback
    
    :param: completion callback that gets called when data has loaded
    */
    override func fetchRemoteData(completion: (Bool) -> Void) {
        socialAccountsRef.observeEventType(.Value, withBlock: { snapshot in
            if let socialAccountData = snapshot.value as? [String: AnyObject] {
                self.fetchDataForSocialAccountIds(socialAccountData.keys.array, completion: { keyboards in
                    self.delegate?.serviceDataDidLoad(self)
                    completion(true)
                })
            }
            }) { err in
                completion(false)
        }
    }
    
    /**
    Fetches data from the local database first and notifies the delegate
    simultaneously, kicks off a request to the remote database and refreshes the data of the local one
    
    :param: completion callback that gets called when data has loaded
    */
    func requestData(completion: ([SocialAccount]) -> Void) {
        fetchRemoteData { success in
            if success {
                completion(self.sortedSocialAccounts)
            } else {
                self.fetchLocalData { success in
                    completion(self.sortedSocialAccounts)
                }
            }
        }
    }
    
    /**
    
    */
    func fetchDataForSocialAccountIds(serviceIds: [String], completion: ([SocialAccount]) -> ()) {
        var index = 0
        var serviceCount = serviceIds.count
        var serviceList =  [SocialAccount]()
        
        for serviceId in serviceIds {
            self.processSocialAccountsData(serviceId, completion: { (socialAccount, success) in
                socialAccount.index = index++
                serviceList.append(socialAccount)
                
                if index + 1 >= serviceCount {
                    self.sortedSocialAccounts = sorted(serviceList) { $0.name < $1.name }
                    
                    self.userDefaults.setValue(self.sortedSocialAccounts, forKey: self.socialAccountsPath)
                    self.userDefaults.synchronize()
    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.delegate?.serviceDataDidLoad(self)
                        completion(self.sortedSocialAccounts)
                    })
                }
            })
        }
    }
    
    /**
    Processes JSON Artist data and creates models objects
    
    :param: serviceId The id from the key/value store, the SocialAccount object ID
    :param: completion callback which gets called when service objects are done being created
    */
    func processSocialAccountsData(socialAccountId: String, completion: (SocialAccount, Bool) -> ()) {
        let serviceRef = rootURL.childByAppendingPath("socialAccounts/\(socialAccountId)")
        
        serviceRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let data = snapshot.value as? [String: AnyObject]
                 {
                    var service = SocialAccount()
                    service.setValuesForKeysWithDictionary(data)
                    completion(service, true)
            }
        })
    }
    
    /**
    unsubscribe a Social Account with the given id
    
    :param: socialAccountId the id of the social Account to delete
    :param: completion callback when the delete operation has been successfully persisted on the backend
    */
    func removeSocialAccounteWithId(socialAccountId: String, completion: (NSError?) -> ()) {
        if isUpdatingSocialAccount {
            return
        }
        isUpdatingSocialAccount = true
        let socialAccount = socialAccounts[socialAccountId]
        socialAccounts.removeValueForKey(socialAccountId)
        
        
        if let socialAccount = socialAccount {
                NSNotificationCenter.defaultCenter().postNotificationName("socialAccount:removed", object: self, userInfo: [
                    "socialAccountId": socialAccount.id,
                    "index": socialAccount.index
                    ])
            self.userDefaults.setValue(socialAccount, forKey: self.socialAccountsPath)
            self.userDefaults.synchronize()
                self.isUpdatingSocialAccount = false
        }
        
        
        self.socialAccountsRef.childByAppendingPath(socialAccountId).removeValueWithCompletionBlock { (err, socialAccountsRef) in
            completion(nil)
        }
    }
    
    func addSocialAccounteWithId(socialAccountId: String, completion: (SocialAccount, Bool) -> ()) {
        if let socialAccount = socialAccounts[socialAccountId] {
            completion(socialAccount, true)
            NSNotificationCenter.defaultCenter().postNotificationName("socialAccount:added", object: self, userInfo: [
                "socialAccountId": socialAccount.id,
                "index": socialAccount.index
                ])
            return
        }
        if isUpdatingSocialAccount {
            return
        }
        isUpdatingSocialAccount = true
        processSocialAccountsData(socialAccountId, completion: { (socialAccount, success) in
            self.socialAccountsRef.childByAppendingPath(socialAccount.id).setValue(true)
            
            socialAccount.user = self.user
            self.socialAccounts[socialAccount.id] = socialAccount
            completion(socialAccount, success)
            NSNotificationCenter.defaultCenter().postNotificationName("keyboard:added", object: self, userInfo: [
                "socialAccountId": socialAccount.id,
                "index": socialAccount.index
                ])
            self.isUpdatingSocialAccount = false
            
        })
    }
}
