//
//  UserMediaItemsViewModel.swift
//  Often
//
//  Created by Luc Succes on 4/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class UserMediaItemsViewModel: MediaItemsViewModel {

    override init(baseRef: Firebase = Firebase(url: BaseURL), collectionType: MediaItemsCollectionType) {
        super.init(baseRef: baseRef, collectionType: collectionType)

        if let userId = sessionManagerFlags.userId  {
            collectionEndpoint = baseRef.childByAppendingPath("users/\(userId)/\(collectionType.rawValue.lowercaseString)")
        }

        do {
            try setupUser { inner in
                self.didSetupUser()
            }
        } catch _ {
        }
    }

    func didSetupUser() {}
}