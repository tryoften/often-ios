//
//  AnonymousAccountManager.swift
//  Often
//
//  Created by Kervins Valcourt on 11/11/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class AnonymousAccountManager: AccountManager {
    
    func openSessionWithAnonymous(completion: (results: ResultType) -> Void) {
        let ref = firebase
        
        ref.authAnonymouslyWithCompletionBlock { (err, auth) -> Void in
            if ((err) != nil) {
                print(err)
                completion(results: ResultType.Error(e: AnonymousAccountManagerError.ReturnedEmptyUserObject))
            } else {
                completion(results: ResultType.Success(r: true))
            }
        }
        sessionManagerFlags.openSession = true
        sessionManagerFlags.userIsAnonymous = true
    }
    
    func createAnonymousUser(completion: (results: ResultType) -> Void)  {
        
        PFAnonymousUtils.logInWithBlock {
            (user: PFUser?, error: NSError?) -> Void in
            if ((error) != nil) {
                completion(results: ResultType.Error(e: AnonymousAccountManagerError.ReturnedEmptyUserObject))
            } else {
                 self.openSessionWithAnonymous(completion)
            }
        }
        
    }
}

enum AnonymousAccountManagerError: ErrorType {
    case ReturnedEmptyUserObject
}