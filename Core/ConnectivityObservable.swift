//
//  ConnectivityObservable.swift
//  Often
//
//  Created by Luc Succes on 1/20/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

/**
 *  Protocol that defines a set of events needed to manage network reachability
 */

protocol ConnectivityObservable: class {
    var isNetworkReachable: Bool {get set}

    func startMonitoring()
    func updateReachabilityStatusBar()
}

extension ConnectivityObservable where Self: UIViewController {
    func startMonitoring() {
//        let reachabilityManager = AFNetworkReachabilityManager.sharedManager()
//        isNetworkReachable = reachabilityManager.reachable
//
//        reachabilityManager.setReachabilityStatusChangeBlock { status in
//            self.isNetworkReachable = reachabilityManager.reachable
//            self.updateReachabilityStatusBar()
//        }
//        reachabilityManager.startMonitoring()
    }
}