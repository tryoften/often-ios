//
//  SearchResponse.swift
//  Often
//
//  Created by Luc Succes on 8/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

struct SearchResponse: Equatable {
    var id: String
    var results: [MediaItem] = []
    var timeModified: NSDate
}

func ==(lhs: SearchResponse, rhs: SearchResponse) -> Bool {
    return lhs.id == rhs.id && lhs.results == rhs.results
}