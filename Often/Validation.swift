//
//  Validation.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/9/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

func PhoneIsValid(testStr: String) -> Bool {
    let phoneRegEx = "\\d{3}-\\d{3}-\\d{4}"
    let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
    return phoneTest.evaluateWithObject(testStr)
}

func EmailIsValid(testStr: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluateWithObject(testStr)
}

func NameIsValid(testStr: String) -> Bool {
    return testStr.characters.count >= 1
}

func PasswordIsValid(passwordStr: String) -> Bool {
    return passwordStr.characters.count >= 1
}

func arePasswordMatchingValid(passwordStrOne:String,passwordStrTwo:String) -> Bool {
    return (passwordStrOne == passwordStrTwo)
}

func ArtistsSelectedListIsValid(artistList: [String]) -> Bool {
    return !artistList.isEmpty
}
    