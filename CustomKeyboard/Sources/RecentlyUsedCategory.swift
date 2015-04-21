//
//  RecentlyUsedCategory.swift
//  DrizzyChat
//
//  Created by Luc Success on 12/31/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class RecentlyUsedCategory: Category {
    init() {
        super.init(id: "recently", name: "Recently Used", lyrics: nil)
        lyrics = []
        retrieveLyrics()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSelectLyric:", name: "lyric:selected", object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func didSelectLyric(notification: NSNotification) {
        if let userInfo = notification.userInfo as? [String: Lyric] {
            var lyric = userInfo["lyric"]
            for (index, aLyric) in enumerate(lyrics) {
                if lyric?.trackId == aLyric.trackId {
                    lyrics.removeAtIndex(index)
                    break
                }
            }
            lyrics.insert(lyric!, atIndex: 0)
            println("Lyric received: \(lyric)")
            persistLyrics()
        }
    }
    
    func persistLyrics() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var lyricsData = [ [String: AnyObject] ]()
        
        for lyric in lyrics {
            lyricsData.append(lyric.toDictionary())
        }
        userDefaults.setObject(lyricsData, forKey: "recently-used-lyrics")
        userDefaults.synchronize()
    }
    
    func retrieveLyrics() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let lyricsData = userDefaults.objectForKey("recently-used-lyrics") as? [[String: AnyObject]] {
            for lyricData in lyricsData {
                lyrics.append(Lyric(dict: lyricData))
            }
            
        }
    }
}
