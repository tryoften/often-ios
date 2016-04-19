//
//  ConnectivityObservable.swift
//  Often
//
//  Created by Luc Succes on 1/20/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Alamofire

/**
 *  Protocol that defines a set of events needed to manage network reachability
 */
protocol ConnectivityObservable: class {
    var isNetworkReachable: Bool { get set }

    func startMonitoring()
    func updateReachabilityView()
}

extension ConnectivityObservable {
    func startMonitoring() {
        if let networkManager = NetworkReachabilityManager() {
            networkManager.listener = { status in
                self.isNetworkReachable = networkManager.isReachable
                self.updateReachabilityView()
            }
            networkManager.startListening()
        }
    }

    func updateReachabilityView() {}
}