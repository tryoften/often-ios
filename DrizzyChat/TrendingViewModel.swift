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
class TrendingViewModel: NSObject, SessionManagerObserver, ServiceDelegate {
    weak var delegate: TrendingViewModelDelegate?
    var artistsList: [Artist]
    var lyricsList: [Lyric]
    var ref: Firebase = Firebase(url: BaseURL)
    var trendingService: TrendingService
    var artistTrendingList: [Artist]?
    var lyricTrendingList: [Lyric]?
    
    init(sessionManager: SessionManager) {
        trendingService = TrendingService(root: ref)
        artistsList = [Artist]()
        lyricsList = [Lyric]()
        
        super.init()
        trendingService.delegate = self
    }
    
    func requestData(completion: ((Bool) -> ())? = nil) {
        trendingService.requestData()
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
        self.delegate?.trendingViewModelDidLoadTrackList(self, artists: artistsList)
    }
    
    // MARK: ServiceDelegate
    
    func serviceDataDidLoad(service: Service) {
        self.delegate?.trendingViewModelDidLoadFeaturedArtists(self, artist: trendingService.featuredArtists)
    }
    
    func artistsDidUpdate(artists: [Artist]) {
        artistsList = artists
        delegate?.artistsDidUpdate(self.artistsList)
    }
    
    func lyricsDidUpdate(lyrics: [Lyric]) {
        lyricsList = lyrics
        delegate?.lyricsDidUpdate(self.lyricsList)
    }
}

protocol TrendingViewModelDelegate: class {
    func trendingViewModelDidLoadFeaturedArtists(browseViewModel: TrendingViewModel, artist: [Artist])
    func trendingViewModelDidLoadTrackList(browseViewModel: TrendingViewModel, artists: [Artist])
    func artistsDidUpdate(artists: [Artist])
    func lyricsDidUpdate(lyrics: [Lyric])
}
