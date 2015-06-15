//
//  Service.swift
//  Drizzy
//
//  Created by Luc Succes on 6/3/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import RealmSwift

/// Provides data of specific entity (e.g. keyboard, lyric) from a local or remote source
class Service {
    var rootURL: Firebase
    let realm: Realm
    let writeQueue: dispatch_queue_t
    var delegate: ServiceDelegate?

    init(root: Firebase, realm: Realm = Realm()) {
        self.rootURL = root
        self.realm = realm
        self.writeQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    }
    
    func fetchLocalData() {}
    func fetchRemoteData(completion: (Bool) -> Void) {}
    func fetchData() {}
}

protocol ServiceDelegate {
    /// Gets called after the service is done loading into the service
    func serviceDataDidLoad(service: Service)
}