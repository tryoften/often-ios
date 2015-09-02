//
//  SoundcloudService.swift
//  Often
//
//  Created by Kervins Valcourt on 8/28/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation
import OAuthSwift

class SoundcloudService {
    var soundcloudAccount: SocialAccount?
    weak var delegate: SoundcloudSocialServiceDelegate?
    
    func sendRequest(completion:(NSError?) -> ()) {
        let oauthswift = OAuth2Swift(
            consumerKey:    SoundcloudClientID,
            consumerSecret: SoundcloudConsumerSecret,
            authorizeUrl:   "https://soundcloud.com/connect",
            accessTokenUrl: "https://api.soundcloud.com/oauth2/token",
            responseType:   "token"
        )
        
        oauthswift.authorizeWithCallbackURL( NSURL(string:"tryoften://logindone")!, scope: "non-expiring", state: "", success: {
            credential, response, parameters in
            
            if let token = parameters["access_token"] as? String {
                self.getCurrentCurrentSessionToken (token)
                
                completion(nil)
            }
            }, failure: {(error: NSError!) -> Void in
                completion(error)
        })
        
    }
    
    func handleOpenURL(url: NSURL) {
        OAuth2Swift.handleOpenURL(url)
    }
    
    func getCurrentCurrentSessionToken(session: String) {
        soundcloudAccount = SocialAccount()
        soundcloudAccount?.type = .Soundcloud
        soundcloudAccount?.token = session
        soundcloudAccount?.activeStatus = true
        
        if let soundcloudAccount = self.soundcloudAccount {
            self.delegate?.soundcloudsocialServiceDidPullToken(self, account: soundcloudAccount)
        }
    }
    
}

protocol SoundcloudSocialServiceDelegate: class {
    func soundcloudsocialServiceDidPullToken(userProfileViewModel: SoundcloudService, account: SocialAccount)
}