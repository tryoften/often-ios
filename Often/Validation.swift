//
//  Validation.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/9/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

func PhoneIsValid(_ testStr: String) -> Bool {
    let phoneRegEx = "\\d{3}-\\d{3}-\\d{4}"
    let phoneTest = Predicate(format:"SELF MATCHES %@", phoneRegEx)
    return phoneTest.evaluate(with: testStr)
}

func EmailIsValid(_ testStr: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest = Predicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func NameIsValid(_ testStr: String) -> Bool {
    return testStr.characters.count >= 1
}

func PasswordIsValid(_ passwordStr: String) -> Bool {
    return passwordStr.characters.count >= 1
}

func arePasswordMatchingValid(_ passwordStrOne:String,passwordStrTwo:String) -> Bool {
    return (passwordStrOne == passwordStrTwo)
}

func ArtistsSelectedListIsValid(_ artistList: [String]) -> Bool {
    return !artistList.isEmpty
}
    
