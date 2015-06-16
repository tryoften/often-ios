//
//  SignUpFormViewModel.swift
//  Drizzy
//
//  Created by Luc Success on 2/16/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class SignUpFormViewModel: NSObject {
    var fullName: String
    var email: String
    var password: String
    
    override init() {
        fullName = ""
        email = ""
        password = ""
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func validateForm() -> String? {
        var errorMessage: String?
        
        if !(count(fullName) >= 1) {
            errorMessage = "Please enter a name"
        } else if !isValidEmail(email) {
            errorMessage = "Please enter a valid email address"
        } else if !(count(password) >= 1) {
            errorMessage = "Please enter a valid password"
        } else if !(count(password) >= 6) {
            errorMessage = "Password needs to be at least 6 characters"
        }
        
        return errorMessage
    }
    
    func submitForm(completion: (success: Bool, error: NSError?) -> ()) {
        var user = PFUser.currentUser()
        var isExistingUser: Bool = false
        
        if user == nil {
            user = PFUser()
        } else {
            isExistingUser = true
        }

        if let user = user {
            user.username = email
            user.email = email
            user.password = password
            user["fullName"] = fullName
            
            if !isExistingUser {
                user.signUpInBackgroundWithBlock(completion)
            } else {
                user.saveInBackgroundWithBlock(completion)
            }
        }
    }
}
