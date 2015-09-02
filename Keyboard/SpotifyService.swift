//
//  SpotifyService.swift
//  Often
//
//  Created by Kervins Valcourt on 8/27/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class SpotifyService: NSObject {
    var authCallback: SPTAuthCallback?
    var spotifyAccount: SocialAccount?
    weak var delegate: SpotifySocialServiceDelegate?
   
    override init() {
        super.init()
        authCallback = { (error: NSError!, session: SPTSession!) in
            if (error != nil) {
                println("there's an error \(error)")
                return
                
            } else {
                self.performTestCallWithSession(session)
            }
        }
    }
    
    func performTestCallWithSession(session: SPTSession) {
        SPTUser.requestCurrentUserWithAccessToken(session.accessToken, callback: { (err, user) -> Void in
            if (err == nil) {
                self.getCurrentCurrentSessionToken(session)
                
            }
        })
    }
    
    func getCurrentCurrentSessionToken(session: SPTSession) {
        self.spotifyAccount = SocialAccount()
        self.spotifyAccount?.type = .Spotify
        self.spotifyAccount?.token = session.accessToken
        self.spotifyAccount?.activeStatus = true
        self.spotifyAccount?.tokenExpirationDate = session.expirationDate.description
        if let spotifyAccount = self.spotifyAccount {
            self.delegate?.spotifysocialServiceDidPullToken(self, account: spotifyAccount)
        }
    }

}

protocol SpotifySocialServiceDelegate: class {
    func spotifysocialServiceDidPullToken(userProfileViewModel: SpotifyService, account: SocialAccount)
}
