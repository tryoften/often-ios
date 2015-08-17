//
//  Service.swift
//  Often
//
//  Created by Kervins Valcourt on 8/13/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//
import UIKit

class Service {
    var rootURL: Firebase
    var userDefaults: NSUserDefaults
    weak var delegate: ServiceDelegate?
    var isInternetReachable: Bool
    var dataLoaded: Bool
    
    init(root: Firebase) {
        rootURL = root
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        dataLoaded = false
        
        var reachabilitymanager = AFNetworkReachabilityManager.sharedManager()
        isInternetReachable = reachabilitymanager.reachable
        
        reachabilitymanager.setReachabilityStatusChangeBlock { status in
            self.isInternetReachable = reachabilitymanager.reachable
        }
        reachabilitymanager.startMonitoring()
    }
    
    func fetchLocalData() {}
    func fetchRemoteData(completion: (Bool) -> Void) {}
}

protocol ServiceDelegate: class {
    /// Gets called after the service is done loading into the service
    func serviceDataDidLoad(service: Service)
    func socialServiceDidUpdate(socialService: [SocialAccount])
}