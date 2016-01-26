//
//  BrowseViewModel.swift
//  Often
//
//  Created by Luc Succes on 1/10/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class BrowseViewModel: MediaItemGroupViewModel {
    init(path: String = "trending") {
        super.init(baseRef: Firebase(url: BaseURL), path: path)
    }

    func getArtistWithOftenId(oftenId: String, completion: (ArtistMediaItem) -> ()) {
        let artistRef = baseRef.childByAppendingPath("artists/\(oftenId)")
        artistRef.observeEventType(.Value, withBlock: { snapshot in
            guard let value = snapshot.value as? NSDictionary else {
                return
            }
            let artist = ArtistMediaItem(data: value)
            completion(artist)
        })
    }

    func getTrackWithOftenid(oftenId: String, completion: (TrackMediaItem) -> ()) {
        let trackRef = baseRef.childByAppendingPath("tracks/\(oftenId)")
        trackRef.observeEventType(.Value, withBlock: { snapshot in
            guard let value = snapshot.value as? NSDictionary else {
                return
            }
            let track = TrackMediaItem(data: value)
            completion(track)
        })
    }
}