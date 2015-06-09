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
    let root: Firebase
    let realm: Realm
    let writeQueue: dispatch_queue_t

    init(root: Firebase, realm: Realm = Realm()) {
        self.root = root
        self.realm = realm
        self.writeQueue = dispatch_queue_create("com.drizzyapp.queue.service", DISPATCH_QUEUE_SERIAL)
    }
    
    func fetchLocalData() {}
    func fetchRemoteData() {}
    func fetchData() {}
    func getAllObjects() {}
}