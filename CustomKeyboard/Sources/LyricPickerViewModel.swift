//
//  LyricPickerViewModel.swift
//  Drizzy
//
//  Created by Luc Success on 2/19/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class LyricPickerViewModel: NSObject {
    
    var trackService: TrackService
    
    init(trackService: TrackService) {
        self.trackService = trackService
    }
    
    func getTrackForLyric(lyric: Lyric, completion: (track: Track) -> ()) {
        trackService.getTrackForLyric(lyric, completion: completion)
    }
}
