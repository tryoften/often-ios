//
//  UserMediaItemsViewModel.swift
//  Often
//
//  Created by Luc Succes on 4/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class UserMediaItemsViewModel: MediaItemsViewModel {
    let userRef: Firebase
    let userId: String

    override init(baseRef: Firebase = Firebase(url: BaseURL), collectionType: MediaItemsCollectionType) {
        if let userId = SessionManagerFlags.defaultManagerFlags.userId {
            self.userId = userId
        } else {
            self.userId = "default"
        }
        
        userRef = baseRef.childByAppendingPath("users/\(userId)")

        super.init(baseRef: baseRef, collectionType: collectionType)

        collectionEndpoint = baseRef.childByAppendingPath("users/\(userId)/\(collectionType.rawValue.lowercaseString)")

        do {
            try setupUser { inner in
                self.didSetupUser()
            }
        } catch _ {
        }
    }

    func didSetupUser() {}
}