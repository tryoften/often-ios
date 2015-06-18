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
    var delegate: BrowseViewModelDelegate?
    var tracksList: [Track]?
    
    func requestData(completion: ((Bool) -> ())? = nil) {
    }
    
    func trackNameAtIndex(index: Int) -> String? {
        if let tracksList = tracksList {
            if index < tracksList.count {
                return tracksList[index].name
            }
        }

        return "No Track Name"
    }
    
    func lyricCountAtIndex(index: Int) -> Int? {
        if let tracksList = tracksList {
            if index < tracksList.count {
                return tracksList[index].lyricCount
            }
        }
        return 0 
    }

}

protocol BrowseViewModelDelegate {
    func browseViewModelDidLoadTrackList(browseViewModel: BrowseViewModel, tracks: [Track])
}
