//
//  SignUpWalkthroughViewModel.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/3/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class SignUpWalkthroughViewModel: NSObject {
    var phoneNumber: String
    var fullName: String
    var email: String
    var password: String
    var artistsList: [String]
    
    override init() {
        phoneNumber = ""
        fullName = ""
        email = ""
        password = ""
        artistsList = [""]
    }
    
    func isPhoneValid(testStr:String) -> Bool {
        let phoneRegEx = "\\d{3}-\\d{3}-\\d{4}"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluateWithObject(testStr)
    }
    
    func isEmailValid(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func isNameValid(testStr:String) -> Bool {
        return count(testStr) >= 1
    }
    
    func isPasswordValid(passwordStr:String) -> Bool {
        return count(passwordStr) >= 1
    }
    
    func arePasswordMatchingValid(passwordStrOne:String,passwordStrTwo:String) -> Bool {
        return (passwordStrOne == passwordStrTwo)
    }
    
    func isArtisitsListValid(artistList:[String]) -> Bool {
        return artistList.isEmpty
    }
}