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
    
    // test
    var oldArray: [Lyric]
    var firstRound: Bool
    
    init(root: Firebase, artistService: ArtistService? = nil) {
        artists = [Artist]()
        lyrics = [Lyric]()
        featuredArtists = [Artist]()
        trendingRef = root.childByAppendingPath("trending")
        featuredRef = root.childByAppendingPath("/trending/featured_artists/")
        
        //test
        oldArray = [Lyric]()
        firstRound = true

        if let artistService = artistService {
            self.artistService = artistService
        } else {
            self.artistService = ArtistService(root: root.childByAppendingPath("owners"))
        }
        
        super.init(root: root)
    } 
    
    
    /**
        One method to retrieve everything for the Trending view. Populates the artist, lyrics, and header featured
        content inside the class arrays
    
        :param: callback function for completion maybe -- but need 3?
    */
    func requestData() {
        
        /// get the artists for the trending view
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
                            let tracksCount = artistData["tracks_count"] as? Int,
                            let imageLarge = artistData["image_large"] as? String {
                                var artist = Artist()
                                artist.id = artistId
                                artist.name = name
                                artist.score = score
                                artist.lyricCount = lyricCount
                                artist.tracksCount = tracksCount
                                artist.imageURLLarge = imageLarge
                                
                                appendArtist(artist)
                        }
                    }
                    self.delegate?.artistsDidUpdate(self.artists)
                }
        })
        
        /// get the lyrics for the trending view
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
                            let text = lyricData["text"] as? String,
                            let owner = lyricData["owner_name"] as? String,
                            let ownerId = lyricData["owner_id"] as? String {
                            
                            let lyric = Lyric()
                            lyric.id = lyricId
                            lyric.score = score
                            lyric.text = text
                            lyric.owner = owner
                            lyric.artistId = ownerId
                                
                            appendLyric(lyric)
                        }
                    }
                    println(data)
                    
                    if self.firstRound == false {
                        self.hashDiff(self.oldArray, newArray: self.lyrics)
                    } else {
                        self.firstRound = false
                    }
                    
                    self.delegate?.lyricsDidUpdate(self.lyrics)
                }
            })
        
        /// get the featured artists for the trending view
        trendingRef.observeEventType(.Value, withBlock: { snapshot in
            //println(snapshot.value)
            // snapshot of the trending branch
            if let trendingData = snapshot.value as? [String : AnyObject] {
                // next retrieve the featured artist data and populate [featuredArtists]
                if let featuredData = trendingData["featured_artists"] as? [[String : String]] {
                    for var i = 0; i < featuredData.count; i++ {
                        if let id = featuredData[i]["owner_id"],
                            let name = featuredData[i]["owner_name"],
                            let imageLarge = featuredData[i]["owner_image_large"] {
                                var featuredArtist = Artist()
                                featuredArtist.id = id
                                featuredArtist.name = name
                                featuredArtist.imageURLLarge = imageLarge
                                self.featuredArtists.append(featuredArtist)
                        }
                    }
                    self.delegate?.serviceDataDidLoad(self)
                }
            }
        })
    }
    
    /**
        Take in old and new array and for each index in the old array check if the value at that index is
        at a different position in the new array
    
        :param: oldArray Previous array logged from Firebase
        :param: newArray New array from Firebase event to be checked against old array
    
        :returns: Couplet of old v new position if there was a difference
    */
    func hashDiff(oldArray: [Lyric], newArray: [Lyric]) -> (Int, Int){
        if oldArray.count == newArray.count {
            for var i = 0; i < oldArray.count; i++ {
                if oldArray[i] == newArray[i] {
                    return (0,0)
                } else {
                    for var j = 0; j < newArray.count; j++ {
                        if oldArray[i] == newArray[j] {
                            println("Couplet: \(i),\(j)")
                            return (i,j)
                        }
                    }
                }
            }
        } else {
            println("Old and New array not the same length")
        }
    
        return (1,1)
    }
}
