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
    var artistSelectedList: [String]?
    var artistsList: [Artist]
    var artistService: ArtistService
    
     init(artistService: ArtistService) {
        self.phoneNumber = ""
        self.fullName = ""
        self.email = ""
        self.password = ""
        self.artistSelectedList = [String]()
        self.artistsList = [Artist]()
        self.artistService = artistService

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
    
    func isArtistsSelectedListValid(artistList:[String]) -> Bool {
        return artistSelectedList!.isEmpty
    }
    
    func getListOfArtists(completion: (artist: [Artist]) -> ()) {
        artistService.requestData { (artistsList) -> Void in
            self.artistsList = artistsList.values.array
        }
        completion(artist:self.artistsList)
    }
    
    func submitNewUser(completion: (success: Bool, error: NSError?) -> ()) {
        var user = PFUser.currentUser()
        var isExistingUser: Bool = false
        
        if user == nil {
            user = PFUser()
        } else {
            isExistingUser = true
        }
        
        user.username = email
        user.email = email
        user.password = password
        user["fullName"] = fullName
        user["phoneNumber"] = phoneNumber
        
        if !isExistingUser {
            user.signUpInBackgroundWithBlock(completion)
        } else {
            user.saveInBackgroundWithBlock(completion)
        }
    }
}