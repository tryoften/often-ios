//
//  FilterMap.swift
//  Often
//
//  Created by Kervins Valcourt on 10/28/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

enum FilterTag: String {
    case Music = "Music"
    case Video = "Video"
    case Gifs = "Gifs"
    case News = "News"
    case All = "All"
}

typealias FilterMap = [(FilterTag, [MediaType])]

let DefaultFilterMap: FilterMap = [
    (.All, []),
    (.Music, [.Track, .Album, .Artist]),
    (.Video, [.Video]),
    (.News, [.Article])
]


