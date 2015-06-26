//
//  TrendingViewModel.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/9/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

/**
    Service:

    - Retrieve artist data in trending order
    - Each artist needs to have either a trend up, trend down, or no trend indicator
    - Each artist needs to be displayed with its Lyric and Track Count

*/
class TrendingViewModel: NSObject, SessionManagerObserver {
    weak var delegate: TrendingViewModelDelegate?
    var artistsList: [Artist]?
    
    init(sessionManager: SessionManager){
        super.init()
    }
    
    func requestData(completion: ((Bool) -> ())? = nil) {
        
    }
    
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
        
    }
    
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool) {
        
    }
    
    func sessionManagerDidFetchKeyboards(sessionsManager: SessionManager, keyboards: [Keyboard]) {
        
    }
    
    func sessionManagerDidFetchTracks(sessionManager: SessionManager, tracks: [String : Track]) {
       
    }
    
    func sessionManagerDidFetchArtists(sessionManager: SessionManager, artists: [String : Artist]) {
        artistsList = artists.values.array
        self.delegate?.trendingViewModelDidLoadTrackList(self, artists: artistsList!)
    }
}

protocol TrendingViewModelDelegate: class {
    func trendingViewModelDidLoadTrackList(browseViewModel: TrendingViewModel, artists: [Artist])
}
