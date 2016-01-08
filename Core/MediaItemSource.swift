//
//  MediaItemSource.swift
//  Often
//
//  Created by Luc Succes on 1/7/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

enum MediaItemSource: String {
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

extension MediaItem {
    func getNameForSource() -> String {
        switch source {
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
}