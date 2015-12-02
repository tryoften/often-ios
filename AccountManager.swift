//
//  AccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 11/11/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation
class AccountManager: NSObject {
    let sessionManagerFlags = SessionManagerFlags.defaultManagerFlags
    var firebase: Firebase
    var userRef: Firebase?
    var isInternetReachable: Bool

    
    init(firebase: Firebase) {
        self.firebase = firebase
       
        let reachabilitymanager = AFNetworkReachabilityManager.sharedManager()
        isInternetReachable = reachabilitymanager.reachable
        
        super.init()
        
        reachabilitymanager.setReachabilityStatusChangeBlock { status in
            self.isInternetReachable = reachabilitymanager.reachable
        }
        
        reachabilitymanager.startMonitoring()
    }
    
    enum ResultType {
        case Success(r: Bool)
        case Error(e: ErrorType)
        case SystemError(e: NSError)
    }
    
    
}