//
//  SearchResponse.swift
//  Often
//
//  Created by Luc Succes on 8/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

struct SearchResponse {
    var id: String
    var results: [SearchResult] = []
    var timeModified: NSDate
}