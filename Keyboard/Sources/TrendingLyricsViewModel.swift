//
//  TrendingLyricsViewModel.swift
//  Often
//
//  Created by Luc Succes on 12/9/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class TrendingLyricsViewModel: MediaItemGroupViewModel {
    init() {
        super.init(baseRef: Firebase(url: BaseURL), path: "trending")
    }
}