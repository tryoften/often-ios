//
//  TrendingService.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/26/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class TrendingService: Service {
    var featuredRef: Firebase
    var trendingRef: Firebase
    var artists: [Artist]
    var lyrics: [Lyric]
    var featuredArtists: [Artist]
    var artistService: ArtistService
    
    init(root: Firebase, artistService: ArtistService? = nil) {
        artists = [Artist]()
        lyrics = [Lyric]()
        featuredArtists = [Artist]()
        trendingRef = root.childByAppendingPath("trending")
        featuredRef = root.childByAppendingPath("/trending/featured_artists/")

        if let artistService = artistService {
            self.artistService = artistService
        } else {
            self.artistService = ArtistService(root: root.childByAppendingPath("owners"))
        }
        
        super.init(root: root)
        
        requestData()
    } 
    
    
    /**
        One method to retrieve everything for the Trending view. Populates the artist, lyrics, and header featured
        content inside the class arrays
    
        :param: callback function for completion maybe -- but need 3?
    */
    func requestData() {
        trendingRef.childByAppendingPath("artists")
            .queryOrderedByChild("score")
            .queryLimitedToLast(10)
            .observeEventType(.Value, withBlock:{ (snapshot) -> Void in
                // reverse array order
                if let data = snapshot.value as? [String: AnyObject] {
                    var artists = [Artist]()
                    var index = 0
                    
                    let appendArtist: (Artist) -> () = { (artist) in
                        artists.append(artist)
                        
                        index++
                        if index == data.count {
                            artists = sorted(artists) { $0.score > $1.score }
                            self.artists = artists
                        }
                    }
                    println(data)
                    
                    for (artistId, artistData) in data  {
                        if let name = artistData["owner_name"] as? String,
                            let score = artistData["score"] as? Int,
                            let lyricCount = artistData["lyrics_count"] as? Int,
                            let tracksCount = artistData["tracks_count"] as? Int {
                                var artist = Artist()
                                artist.id = artistId
                                artist.name = name
                                artist.score = score
                                artist.lyricCount = lyricCount
                                artist.tracksCount = tracksCount
                                
                                appendArtist(artist)
                        }
                    }
                    self.delegate?.artistsDidUpdate(self.artists)
                }
        })
        
        trendingRef.childByAppendingPath("lyrics")
            .queryOrderedByChild("score")
            .queryLimitedToLast(10)
            .observeEventType(.Value, withBlock:{ (snapshot) -> Void in
                // reverse array order
                if let data = snapshot.value as? [String: AnyObject] {
                    var lyrics = [Lyric]()
                    var index = 0
                    
                    let appendLyric: (Lyric) -> () = { (lyric) in
                        lyrics.append(lyric)
                        
                        index++
                        if index == data.count {
                            lyrics = sorted(lyrics) { $0.score > $1.score }
                            self.lyrics = lyrics
                        }
                    }
                    
                    for (lyricId, lyricData) in data {
                        if let score = lyricData["score"] as? Int,
                            let id = lyricId as? String,
                            let owner = lyricData["owner_name"] as? String,
                            let text = lyricData["text"] as? String {
                            
                            let lyric = Lyric()
                            lyric.id = lyricId
                            lyric.score = score
                            lyric.owner = owner
                            lyric.text = text
                            appendLyric(lyric)
                        }
                    }
                    println(data)
                    self.delegate?.lyricsDidUpdate(self.lyrics)
                }
            })

        trendingRef.observeEventType(.Value, withBlock: { snapshot in
            //println(snapshot.value)
            // snapshot of the trending branch
            if let trendingData = snapshot.value as? [String : AnyObject] {
                // next retrieve the artist data and populate [artists]
                if let artistsData = trendingData["artists"] as? [[String : String]] {
                    for var i = 0; i < artistsData.count; i++ {
                        var artist = Artist()
                        artist.id = artistsData[i]["owner_id"]!
                        artist.arrow = artistsData[i]["arrow"]!
                        self.artists.append(artist)
                    }
                }
                
                // next retrieve the featured artist data and populate [featuredArtists]
                if let featuredData = trendingData["featured_artists"] as? [[String : String]] {
                    for var i = 0; i < featuredData.count; i++ {
                        var featuredArtist = Artist()
                        featuredArtist.id = featuredData[i]["owner_id"]!
                        featuredArtist.name = featuredData[i]["owner_name"]!
                        featuredArtist.imageURLLarge = featuredData[i]["owner_image_large"]!
                        self.featuredArtists.append(featuredArtist)
                    }
                }
                
                // retrieve the lyrics
                if let lyricsData = trendingData["lyrics"] as? [[String : AnyObject]] {
                    for var i = 0; i < lyricsData.count; i++ {
                        var lyric = Lyric()
                        lyric.text = lyricsData[i]["lyric_text"] as! String
                        lyric.artistId = lyricsData[i]["owner_id"] as! String
                        lyric.arrow = lyricsData[i]["arrow"] as! String
                        lyric.owner = lyricsData[i]["owner_name"] as! String
                        
                        // need to put in lyrics and track count
                        
                        self.lyrics.append(lyric)
                    }
                }
            }
        })
    }
}
