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

enum FilterTag: String {
    case Music = "music"
    case Video = "video"
    case Gifs = "gifs"
    case News = "news"
    case All = "all"
}

let FilterMap: [FilterTag: [MediaType]] = [
    .Music: MusicFilterMap,
    .Video: VideoFilterMap,
    .Gifs: GifsFilterMap,
    .News: NewsFilterMap,
    .All: AllFilterMap
]

var DefaultFilterMode = FilterMap[.All]!
var MusicFilterMode = FilterMap[.Music]!
var VideoFilterMode = FilterMap[.Video]!
var GifsFilterMode = FilterMap[.Gifs]!
var NewsFilterMode = FilterMap[.News]!

protocol FilterMapProtocol: class {
    func currentFilterSet(filter: [MediaType])
}