//
//  FilterMap.swift
//  Often
//
//  Created by Kervins Valcourt on 10/28/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation
private let MusicFilterMap: [MediaType] = [.Album, .Track, .Artist]

private let VideoFilterMap: [MediaType] = [.Video]

private let GifsFilterMap: [MediaType] = [.Gif]

private let NewsFilterMap: [MediaType] = [.Article]

private let AllFilterMap: [MediaType] = [.Other]

enum FilterTag {
    case Music
    case Video
    case Gifs
    case News
    case All
}

let FilterMap: [FilterTag: FilterButton] = [
    .Music: FilterButton(filter: MusicFilterMap),
    .Video:FilterButton(filter: VideoFilterMap),
    .Gifs: FilterButton(filter: GifsFilterMap),
    .News: FilterButton(filter: NewsFilterMap),
    .All:  FilterButton(filter: AllFilterMap)
]
