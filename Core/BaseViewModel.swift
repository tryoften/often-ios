//
//  BaseViewModel.swift
//  Often
//
//  Created by Luc Succes on 1/7/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Firebase

class BaseViewModel {
    let baseRef: FIRDatabaseReference
    var ref: FIRDatabaseReference
    var path: String?
    var isDataLoaded: Bool

    let sessionManagerFlags = SessionManagerFlags.defaultManagerFlags
    var currentUser: User?
    var userId: String
    private(set) var userRef: FIRDatabaseReference

    init(userId: String? = nil, baseRef: FIRDatabaseReference = FIRDatabase.database().reference(), path: String? = nil) {
        self.baseRef = baseRef
        self.path = path
        ref = path != nil ? baseRef.child(path!) : baseRef
        isDataLoaded = false

        if let id = userId {
            self.userId = id
        } else if let sessionId = sessionManagerFlags.userId {
            self.userId = sessionId
        } else {
            self.userId = "default"
        }

        userRef = baseRef.child("users/\(self.userId)")
        userRef.keepSynced(true)
    }

    /**
     Fetches data for current view model
     */
    func fetchData(completion: ((Bool) -> Void)? = nil) {
    }

    /**
     Creates a user object

     :param: completion
     :throws:

     read more about try/catch with async closures
     http://appventure.me/2015/06/19/swift-try-catch-asynchronous-closures/
     */
    func setupUser(completion: (() throws -> User) -> ()) throws {
        if !sessionManagerFlags.openSession {
            throw MediaItemsViewModelError.NoUser
        }

        userRef.observeEventType(.Value, withBlock: { snapshot in
            if let value = snapshot.value as? [String: AnyObject] where snapshot.exists() {
                self.currentUser = User()
                self.currentUser?.setValuesForKeysWithDictionary(value)
                completion({ return self.currentUser! })
            } else {
                completion({ throw MediaItemsViewModelError.NoUser })
            }
        })
    }
}