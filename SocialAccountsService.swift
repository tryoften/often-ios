//
//  SocialAccountsService.swift
//  Often
//
//  Created by Kervins Valcourt on 8/13/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit
/// Service that provides and manages SocialAccount models along with categories.
/// It stores the data both locally and remotely

class SocialAccountsService: Service {
    let user: User
    var socialAccountsRef: Firebase
    var socialAccounts: [SocialAccount]?
    let socialAccountsPath = "socialAccounts"
    var isUpdatingSocialAccount = false
    
    init(user: User, root: Firebase) {
        self.user = user
        socialAccountsRef = root.childByAppendingPath("users/\(user.id)/accounts")
        
        super.init(root: root)
    }
    
    
    /**
    Fetches data from the local database and creates models
    
    :param: completion callback that gets called when data has loaded
    */
    func fetchLocalData(completion: (Bool) -> Void) {
        createSocialAccountsModels(completion)
    }
    
    func updateSocialAccount(socialAccount: SocialAccount){
        socialAccountsRef.childByAppendingPath(socialAccount.type?.rawValue).setValue(["token":socialAccount.token, "activeStatus":socialAccount.activeStatus,"tokenExpirationDate":socialAccount.tokenExpirationDate])
    }
    
    func updateLocalSocialAccount (socialAccounts: [SocialAccount]) {
        userDefaults.setObject(socialAccounts, forKey: socialAccountsPath)
        userDefaults.synchronize()
    }
    /**
    Creates social service models from the default NSUserDefaults
    */
    private func createSocialAccountsModels(completion: (Bool) -> Void) {
        if let services = userDefaults.arrayForKey(socialAccountsPath) as? [SocialAccount]
        {
            socialAccounts = services
            delegate?.serviceDataDidLoad(self)
            completion(true)
        } else {
            createSocialAccount()
            delegate?.serviceDataDidLoad(self)
            completion(true)
        }
    }
    
    func createSocialAccount() {
        socialAccounts = [SocialAccount]()
        
        var twitter = SocialAccount()
        twitter.type = .Twitter
        
        var spotify = SocialAccount()
        spotify.type = .Spotify
        
        var soundcloud = SocialAccount()
        soundcloud.type = .Soundcloud
        
        var venmo = SocialAccount()
        venmo.type = .Venmo
        
        socialAccounts!.append(twitter)
        socialAccounts!.append(spotify)
        socialAccounts!.append(soundcloud)
        socialAccounts!.append(venmo)
    }
    
  
    
}

protocol SocialAccountServiceDelegate: ServiceDelegate {}
