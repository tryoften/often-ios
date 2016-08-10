//
//  UsernameViewModel.swift
//  Often
//
//  Created by Kervins Valcourt on 8/5/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Firebase

class UsernameViewModel: BaseViewModel {
    let userId: String
    let userRef: FIRDatabaseReference

    init() {
        if let userId = SessionManagerFlags.defaultManagerFlags.userId {
            self.userId = userId
        } else {
            self.userId = "default"
        }

        userRef = FIRDatabase.database().reference().child("users/\(userId)")

        super.init()

        do {
            try setupUser { inner in
            }
        } catch _ {
        }
    }

    func generateSuggestedUsername() -> String {
        var username: String = ""

        if let user = currentUser {
            if !user.username.isEmpty {
                username = user.username
            } else {
                username = user.name.stringByReplacingOccurrencesOfString(" ", withString: ".").lowercaseString
            }

        }

        return username
    }

    func usernameDoesExist(username: String, completion: ((Bool) -> Void)? = nil) {
        let baseRef = FIRDatabase.database().reference()
        let encodedString = encodeString(username)
        let ref = baseRef.child("usernames/\(encodedString)")
        var exists: Bool = true

        ref.observeEventType(.Value, withBlock: { snapshot in

            if let _ = snapshot.value as? NSDictionary {
                exists = true
            } else {
                exists = false
            }

            dispatch_async(dispatch_get_main_queue()) {
                completion?(exists)
            }
        })

    }

    func saveUsername(username: String) {
        guard let id = currentUser?.id else {
            return
        }

        currentUser?.username = username

        let baseRef = FIRDatabase.database().reference()
        let encodedString = encodeString(username)
        var ref = baseRef.child("usernames/\(encodedString)")
        ref.setValue([
            "name": username,
            "userid": id,
            ])

        ref = baseRef.child("users/\(id)")
        ref.updateChildValues([
            "username": username
            ])

    }

    func encodeString(username: String) -> String {
        let plainData = (username as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        if let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) {
            return base64String
        }
        return ""
    }

}