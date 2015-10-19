//
//  SearchResult.swift
//  Often
//
//  Created by Luc Succes on 8/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

enum SearchResultType: String {
    case Article = "article"
    case Link = "link"
    case Music = "music"
    case Album = "album"
    case Track = "track"
    case Artist = "artist"
    case Video = "video"
    case User = "user"
    case Other = "other"
}

enum SearchResultSource: String {
    case Billboard = "billboard"
    case Complex = "complex-music"
    case Highsnobiety = "highsnobiety"
    case EliteDaily = "elitedaily"
    case Fader = "fader"
    case FactMag = "factmag"
    case FourPins = "fourpins"
    case HotNewHipHop = "hnhh"
    case Hypebeast = "hypebeast"
    case MTV = "mtv-news"
    case Paper = "paper"
    case PigeonsAndPlanes = "pigeonsandplanes"
    case Spotify = "spotify"
    case SpinMusic = "spin-music"
    case SpinNews = "spin-news"
    case Soundcloud = "soundcloud"
    case Youtube = "youtube"
    case VibeNews = "vibe-news"
    case VibeMusic = "vibe-music"
    case Vice = "vice"
    case XXLMag = "xxlmag"
    case TMZ = "tmz"
    case Unknown = "unknown"
}

class SearchResult: Equatable {
    var id: String = ""
    var type: SearchResultType = .Other
    var score: Double = 0.0
    var sourceName: String = ""
    var source: SearchResultSource = .Unknown
    var image: String?
    var data: [String: AnyObject] = [:]
    
    
    init (data: [String: AnyObject]) {
        self.data = data
        
        if let id = data["_id"] as? String {
            self.id = id
        }
    }
    
    func iconImageForSource() -> UIImage? {
        return UIImage(named: source.rawValue)
    }
    
    func getInsertableText() -> String {
        return ""
    }
    
    func getNameForSource() -> String {
        switch (source) {
        case .Billboard: return "Billboard"
        case .Complex: return "Complex"
        case .Highsnobiety: return "Highsnobiety"
        case .EliteDaily: return "Elite Daily"
        case .Fader: return "Fader"
        case .FactMag: return "FactMag"
        case .FourPins: return "Four Pins"
        case .HotNewHipHop: return "Hot New HipHop"
        case .Hypebeast: return "Hypebeast"
        case .MTV: return "MTV"
        case .Paper: return "Paper"
        case .PigeonsAndPlanes: return "Pigeons And Planes"
        case .Spotify: return "Spotify"
        case .SpinMusic: return "Spin Music"
        case .SpinNews: return "Spin News"
        case .Soundcloud: return "Soundcloud"
        case .Youtube: return "Youtube"
        case .VibeNews: return "Vibe News"
        case .VibeMusic: return "Vibe Music"
        case .Vice: return "Vice"
        case .XXLMag: return "XXL Mag"
        case .TMZ: return "TMZ"
        case .Unknown: return "Unknown"
        }
    }
    
    func toDictionary() -> [String: AnyObject] {
        var data : [String: AnyObject] = [
            "_id": id,
            "id": id,
            "type": type.rawValue,
            "source": source.rawValue
        ]
        
        for (key, value) in self.data {
            data[key] = value
        }
        
        return data
    }
}

func ==(lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.id == rhs.id
}