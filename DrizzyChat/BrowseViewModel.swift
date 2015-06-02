//
//  BrowseViewModel.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 5/27/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

/*******************************************************************************************************
BrowseViewModel
Load data into the tracks array
Acts as table view data source and delegates to the BrowseViewController
Table View Cell
    -> index + 1 ranking in left block
    -> Track Name as Title
    -> Lyric Count as Subtitle
    -> Add a cellAccessoryDisclosureIndicator in right block
*******************************************************************************************************/

class BrowseViewModel: NSObject, SessionManagerObserver {
    var sessionManager: SessionManager
    var delegate: BrowseViewModelDelegate?
    var tracksList: [Track]?
    
    init(sessionManager: SessionManager){
        self.sessionManager = sessionManager
        super.init()
        self.sessionManager.addSessionObserver(self)
        sessionManager.fetchTracks()
    }
    
    func requestData(completion: ((Bool) -> ())? = nil) {
        sessionManager.login()
    }
    
    func trackNameAtIndex(index: Int) -> String? {
        if let tracksList = tracksList {
            if index < tracksList.count {
                return tracksList[index].name
            }
        }

        return "No Track Name"
    }
    
//    func lyricCountAtIndex(index: Int) -> Int? {
//        if let tracksList = tracksList {
//            if index < tracksList.count {
//                return tracksList[index].lyricCount
//            }
//        }
//    }
    
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
        
    }
    
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User) {
        
    }
    
    func sessionManagerDidFetchKeyboards(sessionsManager: SessionManager, keyboards: [String: Keyboard]) {
        
    }
    
    func sessionManagerDidFetchTracks(sessionManager: SessionManager, tracks: [String : Track]) {
        tracksList = tracks.values.array
        self.delegate?.browseViewModelDidLoadTrackList(self, tracks: self.tracksList!)
    }
}

protocol BrowseViewModelDelegate {
    func browseViewModelDidLoadTrackList(browseViewModel: BrowseViewModel, tracks: [Track])
}
