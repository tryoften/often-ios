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
    var delegate: WalkthroughViewModelDelegate?
    
     init(artistService: ArtistService) {
        self.phoneNumber = ""
        self.fullName = ""
        self.email = ""
        self.password = ""
        self.artistSelectedList = [String]()
        self.artistsList = [Artist]()
        self.artistService = artistService

    }
    
    func getListOfArtists() {
        artistService.requestData { (artistsList) -> Void in
            self.artistsList = artistsList.values.array
            println(self.artistsList.count)
            
            self.delegate?.walkthroughViewModelDidLoadArtistsList(self, keyboardList: self.artistsList)
        }
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

protocol WalkthroughViewModelDelegate {
    func walkthroughViewModelDidLoadArtistsList(signUpWalkthroughViewModel: SignUpWalkthroughViewModel, keyboardList: [Artist])
}