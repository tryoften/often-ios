//
//  SocialAccountsService.swift
//  Often
//
//  Created by Kervins Valcourt on 8/13/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class SocialAccountsService: Service {
    var socialAccountsRef: Firebase
    var socialAccounts: [SocialAccount]
    let socialAccountsPath = "socialAccounts"
    
    override init(root: Firebase) {
        socialAccountsRef = root.childByAppendingPath(socialAccountsPath)
        socialAccounts = [SocialAccount]()
        
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
            socialAccounts = services as! [SocialAccount]
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
                completion(self.socialAccounts)
            } else {
                self.fetchLocalData { success in
                    completion(self.socialAccounts)
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
                    self.socialAccounts = sorted(serviceList) { $0.name < $1.name }
                    
                    self.userDefaults.setValue(self.socialAccounts, forKey: self.socialAccountsPath)
                    self.userDefaults.synchronize()
    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.delegate?.serviceDataDidLoad(self)
                        completion(self.socialAccounts)
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
    func processSocialAccountsData(serviceId: String, completion: (SocialAccount, Bool) -> ()) {
        let serviceRef = rootURL.childByAppendingPath("socialAccounts/\(serviceId)")
        
        serviceRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let data = snapshot.value as? [String: AnyObject]
                 {
                    var service = SocialAccount()
                    service.setValuesForKeysWithDictionary(data)
                    completion(service, true)
            }
        })
    }
}
