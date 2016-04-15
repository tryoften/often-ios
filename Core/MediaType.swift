//
//  MediaType.swift
//  Often
//
//  Created by Luc Succes on 1/7/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

enum MediaType: String {
    case Article = "article"
    case Album = "album"
    case Artist = "artist"
    case Lyric = "lyric"
    case Track = "track"
    case Video = "video"
    case User = "user"
    case Gif = "gif"
    case Other = "other"
    case Pack = "pack"
    case Quote = "quote"

    var isVideo: Bool {
        switch self {
        case .Video:
            return true
        default:
            return false
        }
    }

    var isMusic: Bool {
        switch self {
        case .Album, .Track, .Artist:
            return true
        default:
            return false
        }
    }

    var isNews: Bool {
        switch self {
        case .Article:
            return true
        default:
            return false
        }
    }

    var isGif: Bool {
        switch self {
        case .Gif:
            return true
        default:
            return false
        }
    }
}

let MediaItemTypes: [MediaType: MediaItem.Type] = [
    .Article: ArticleMediaItem.self,
    .Artist: ArtistMediaItem.self,
    .Track: TrackMediaItem.self,
    .Lyric: LyricMediaItem.self,
    .Pack: PackMediaItem.self,
    .Quote: QuoteMediaItem.self,
    .Gif: GifMediaItem.self
]