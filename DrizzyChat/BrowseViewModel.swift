//
//  BrowseViewModel.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 5/27/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

/**
    BrowseViewModel:

    Load data into the tracks array
    Acts as table view data source and delegates to the BrowseViewController
    
    Table View Cell
    - index + 1 ranking in left block
    - Track Name as Title
    - Lyric Count as Subtitle
    - Add a cellAccessoryDisclosureIndicator in right block
*/

class BrowseViewModel: NSObject {
    var rootRef: Firebase
    var artistService: ArtistService
    weak var delegate: BrowseViewModelDelegate?
    var artists: [Artist]
    var currentArtist: Artist?
    var isDataLoaded: Bool
    
    override init() {
        rootRef = Firebase(url: BaseURL)
        artistService = ArtistService(root: rootRef)
        artists = [Artist]()
        isDataLoaded = false
        
        super.init()
    }

    /**
        Load the artistsList array with all of the Artist objects
    
    */
    func requestData(completion: ((Bool) -> ())? = nil) {
        artistService.requestData({ artistData in
            self.isDataLoaded = true
            self.artists = artistData
            if !self.artists.isEmpty {
                self.currentArtist = self.artists[0]
            }
            self.delegate?.browseViewModelDidLoadData(self, artists: self.artists)
        })
    }
    
    
    func numberOfTracks() -> Int {
        if let tracksList = currentArtist?.tracksList {
            return tracksList.count
        }
        return 0
    }
    
    func trackAtIndex(index: Int) -> Track? {
        if let currentArtist = currentArtist {
            if index < currentArtist.tracksList.count {
                return currentArtist.tracksList[index]
            }
        }
        var track = Track()
        track.name = "Random track"
        return track
    }
    
    func userHasKeyboardForArtist(artist: Artist) -> Bool {
        if let currentUser = SessionManager.defaultManager.currentUser {
            return currentUser.hasKeyboardForArtist(artist)
        }
        return false
    }
    
    func toggleAddingKeyboardforCurrentArtist(completion: (added: Bool) -> ()) {
        if let keyboardService = SessionManager.defaultManager.keyboardService,
            let artist = currentArtist {
                if userHasKeyboardForArtist(artist) {
                    keyboardService.deleteKeyboardWithId(artist.keyboardId, completion: { error in
                        completion(added: false)
                    })
                } else {
                    keyboardService.addKeyboardWithId(artist.keyboardId, completion: { (keyboard, success) in
                        completion(added: true)
                    })
                }
        }
    }
    
    /**
        Get the track name in the tracksList for a specific index
    
        :param: index index of the track name you want to get
        :returns: String of the track name for the index passed in
    */
    func trackNameAtIndex(index: Int) -> String? {
        if let tracksList = currentArtist?.tracksList {
            if index < tracksList.count {
                return tracksList[index].name
            }
        }
        return "No Track Name"
    }
    
    
    /**
        Get the lyric count for a specific index in the tracksList
    
        :param: index index of the lyric count you want to get
        :returns: Integer that is the lyric count for that index passed in
    */
    func lyricCountAtIndex(index: Int) -> Int? {
        if let tracksList = currentArtist?.tracksList {
            if index < tracksList.count {
                return tracksList[index].lyricCount
            }
        }
        return 0 
    }

}

protocol BrowseViewModelDelegate: class {
    func browseViewModelDidLoadData(browseViewModel: BrowseViewModel, artists: [Artist])
    func browseViewModelDidLoadTrackList(browseViewModel: BrowseViewModel, tracks: [Track])
}
