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
    weak var delegate: BrowseViewModelDelegate?
    var tracksList: [Track]?
    var currentArtist: Int = 0
    
    // Dummy data
    var images = [
        UIImage(named: "frank"),
        UIImage(named: "snoop"),
        UIImage(named: "nicki-minaj"),
        UIImage(named: "drake"),
        UIImage(named: "eminem")
    ]
    
    var artistNames = [
        "F R A N K  O C E A N",
        "S N O O P  D O G G",
        "N I C K I  M I N A J",
        "D R A K E",
        "E M I N E M"
    ]
    
    var tracks = [
        "Super Rich Kids",
        "Pump Pump",
        "Anaconda",
        "Company",
        "Superman"
    ]

    
    /**
        Load the artistsList array with all of the Artist objects
    
    */
    func requestData(completion: ((Bool) -> ())? = nil) {
        
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
        Pass in the ID for the artist from the header and get back all of the tracks
        for that artist. Stores all of the tracks in the tracksList array.
    
        :param: id the string from the header that represents an owner/artist
    
    */
    func getTracksForArtistID(id: String) {
        
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
