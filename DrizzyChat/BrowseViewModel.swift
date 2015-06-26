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
    var tracksList: [Track]?
    var artists: [String : Artist]
    var artistsList: [Artist]
    var currentArtist: Artist
    
    override init() {
        rootRef = Firebase(url: BaseURL)
        artistService = ArtistService(root: rootRef)
        artists = [String : Artist]()
        artistsList = [Artist]()
        currentArtist = Artist()
        
        super.init()
        
        requestData(completion: { done in
            
        })
    }

    
    /**
        Load the artistsList array with all of the Artist objects
    
    */
    func requestData(completion: ((Bool) -> ())? = nil) {
        artistService.requestData({ artistData in
            self.artists = artistData
            self.artistsList = artistData.values.array
        })
    }
    
    
    /**
        Get the track name in the tracksList for a specific index
    
        :param: index index of the track name you want to get
    
        :returns: String of the track name for the index passed in
    */
    func trackNameAtIndex(index: Int) -> String? {
        if let tracksList = tracksList {
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
        if let tracksList = tracksList {
            if index < tracksList.count {
                return tracksList[index].lyricCount
            }
        }
        return 0 
    }

}

protocol BrowseViewModelDelegate: class {
    func browseViewModelDidLoadTrackList(browseViewModel: BrowseViewModel, tracks: [Track])
}
