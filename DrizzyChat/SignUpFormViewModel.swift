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
    
    func validateForm() -> String? {
        var errorMessage: String?
        
        var regex = "[^@]+@[A-Za-z0-9.-]+\\.[A-Za-z]+"
        var emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        if (!(countElements(fullName) >= 1)) {
            errorMessage = "Please enter a  name"
        } else if (emailPredicate?.evaluateWithObject(email) != nil) {
            errorMessage = "Please enter a valid email address"
        } else if (!(countElements(password) >= 1)) {
            errorMessage = "Please enter a valid password"
        } else if (!(countElements(password) >= 6)) {
            errorMessage = "Password needs to be at least 6 characters"
        }
        
        return errorMessage;
    }
    
    func submitForm() {
        
    }
}
