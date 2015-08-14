//
//  SocialServicesService.swift
//  Often
//
//  Created by Kervins Valcourt on 8/13/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class SocialServicesService: Service {
    var socialServicesRef: Firebase
    var socialServices: [SocialService]
    let socialServicePath = "socialServices"
    
    override init(root: Firebase) {
        socialServicesRef = root.childByAppendingPath(socialServicePath)
        socialServices = [SocialService]()
        
        super.init(root: root)
        
    }
    
    /**
    Fetches data from the local database and creates models
    
    :param: completion callback that gets called when data has loaded
    */
    func fetchLocalData(completion: (Bool) -> Void) {
        createSocialServiceModels(completion)
    }
    
    /**
    Creates social service models from the default NSUserDefaults
    */
    private func createSocialServiceModels(completion: (Bool) -> Void) {
        if let services = userDefaults.arrayForKey(socialServicePath)
        {
            socialServices = services as! [SocialService]
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
        socialServicesRef.observeEventType(.Value, withBlock: { snapshot in
            if let socialServiceData = snapshot.value as? [String: AnyObject] {
                self.fetchDataForSocialServiceIds(socialServiceData.keys.array, completion: { keyboards in
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
    func requestData(completion: ([SocialService]) -> Void) {
        fetchRemoteData { success in
            if success {
                completion(self.socialServices)
            } else {
                self.fetchLocalData { success in
                    completion(self.socialServices)
                }
            }
        }
    }
    
    /**
    
    */
    func fetchDataForSocialServiceIds(serviceIds: [String], completion: ([SocialService]) -> ()) {
        var index = 0
        var serviceCount = serviceIds.count
        var serviceList =  [SocialService]()
        
        for serviceId in serviceIds {
            self.processSocialServicesData(serviceId, completion: { (socialService, success) in
                socialService.index = index++
                serviceList.append(socialService)
                
                if index + 1 >= serviceCount {
                    self.socialServices = sorted(serviceList) { $0.name < $1.name }
                    
                    self.userDefaults.setValue(self.socialServices, forKey: self.socialServicePath)
                    self.userDefaults.synchronize()
    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.delegate?.serviceDataDidLoad(self)
                        completion(self.socialServices)
                    })
                }
            })
        }
    }
    
    /**
    Processes JSON Artist data and creates models objects
    
    :param: serviceId The id from the key/value store, the SocialService object ID
    :param: completion callback which gets called when service objects are done being created
    */
    func processSocialServicesData(serviceId: String, completion: (SocialService, Bool) -> ()) {
        let serviceRef = rootURL.childByAppendingPath("socialServices/\(serviceId)")
        
        serviceRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let data = snapshot.value as? [String: AnyObject]
                 {
                    var service = SocialService()
                    service.setValuesForKeysWithDictionary(data)
                    completion(service, true)
            }
        })
    }
}
