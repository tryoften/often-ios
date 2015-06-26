//
//  ArtistService.swift
//  Drizzy
//
//  Created by Luc Success on 4/15/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit
import RealmSwift

class ArtistService: Service {
    var artistsRef: Firebase
    var artists: [String: Artist]
    
    override init(root: Firebase, realm: Realm = Realm()) {
        artistsRef = root.childByAppendingPath("owners")
        artists = [String: Artist]()
        
        super.init(root: root, realm: realm)
    }
    
    /**
    Fetches data from the local database and creates models
    
    :param: completion callback that gets called when data has loaded
    */
    func fetchLocalData(completion: (Bool) -> Void) {
        createArtistModels(completion)
    }
    
    /**
        Creates keyboard models from the default realm
    */
    private func createArtistModels(completion: (Bool) -> Void) {
        let artists = realm.objects(Artist)
        for artist in artists {
            self.artists[artist.id] = artist
        }
        
        delegate?.serviceDataDidLoad(self)
        completion(true)
    }
    
    /**
    
    */
    func fetchDataForArtistIds(artistIds: [String], completion: ([Artist]) -> ()) {
        var index = 0
        var artistCount = artistIds.count
        
        for artistId in artistIds {
            self.processArtistData(artistId, completion: { (artist, success) in
                artist.index = index++
                self.artists[artist.artistId] = artist
                
                if index + 1 >= artistCount {
                    self.realm.write {
                        self.realm.add(self.artists.values.array, update: true)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.delegate?.serviceDataDidLoad(self)
                        completion(self.artists.values.array)
                    })
                }
            })
        }
    }
    
    /**
    Listens for changes on the server (firebase) database and updates
    the local (realm) database, then notifies the delegate and calls the completion callback
    
    :param: completion callback that gets called when data has loaded
    */
    override func fetchRemoteData(completion: (Bool) -> Void) {
        artistsRef.observeEventType(.Value, withBlock: { snapshot in
            if let artistsData = snapshot.value as? [String: AnyObject] {
                self.fetchDataForArtistIds(artistsData.keys.array, completion: { keyboards in
                    completion(true)
                })
            }
            }) { err in
                completion(false)
        }
    }
    
    /**
    Fetches data from the local database first and notifies the delegate
    simultaneously, kicks off a request to the remote database and refreshes the data of the local one
    
    :param: completion callback that gets called when data has loaded
    */
//    func requestData(completion: ([String: Artist]) -> Void) {
//        fetchLocalData { success in
//            completion(self.artists)
//        }
//        
//        fetchRemoteData { success in
//            completion(self.artists)
//        }
//    }

    
    func requestData(completion: (artistsList:[String: Artist]) -> Void) {
        let tracks = List<Track>()
        var index = 0
        
        artistsRef.observeEventType(.Value, withBlock: { (snapshot) -> Void in
            println(snapshot.value)
            if let artistsData = snapshot.value as? [String: NSDictionary] {
                for (owner, data) in artistsData {
                    var artistData = data.mutableCopy() as! NSMutableDictionary
                    artistData["keyboardId"] = artistData["keyboard"]
                    var artist = Artist()
                    artist.id = owner
                    artist.name = data["name"] as! String
                    artist.imageURLLarge = data["image_large"] as! String
                    artist.lyricCount = data["lyrics_count"] as! Int
                    
                    self.artists[artist.id] = artist
                    
                    
                    var tracks = List<Track>()
                    for (key, value) in data["tracks"] as! [String : AnyObject]{
                        // var trackData = value.mutableCopy() as! NSDictionary
                        var track = Track()
                        track.setValuesForKeysWithDictionary(value as! [NSObject : AnyObject])
                        tracks.append(track)
                    }
                    artist.tracks.extend(tracks)
                    println(artist)
                    self.artists[artist.id] = artist
                    
                    if index + 1 >= artistsData.count {
                        self.realm.write {
                            self.realm.add(self.artists.values.array, update: true)
                        }
                    }

                }
                
                if self.artists.count >= 1 {
                    completion(artistsList: self.artists)
                }
            }
            
        })
    }
    
    
    /**
        Retrieve a specific artist from the dictionary of artists that we get from the requestData method
        by passing in that artist's ID.
    
        :param: id The ID of the artist object
    
        :returns: The Artist object that corresponds to the ID in the artistsList dictionary or nil because of an invalid ID
    */
    func getArtistForId(id: String) -> Artist? {
        for (key, value) in artists {
            if key == id {
                return value
            }
        }
        return nil
    }
    
    
    /**
    Processes JSON Artist data and creates models objects
    
    :param: artistId The id from the key/value store, the artist object ID
    :param: completion callback which gets called when artist objects are done being created
    */
    private func processArtistData(artistId: String, completion: (Artist, Bool) -> ()) {
        let artistRef = rootURL.childByAppendingPath("owner/\(artistId)")
        
        artistRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let artistData = snapshot.value as? [String: AnyObject] {
                var artist = Artist()
                artist.id = artistId
                
                
                if let tracks = artistData["tracks"] as? [String : [String : AnyObject]] {
                    self.processTrackData(artist, tracks: tracks, completion: { success in
                        
                    })
                }
            }
        })
    }
    
    private func processTrackData(artist: Artist, tracks: [String : [String : AnyObject]], completion: (Bool) -> ()) {
        let trackRef = rootURL.childByAppendingPath("/\(artist.id)/tracks")
        println(trackRef)
        
        trackRef.observeEventType(.Value, withBlock: { snapshot in
            if let artistData = snapshot.value as? [String : [String : AnyObject]] {
                for(key, data) in artistData {
                    var track = Track(value: [
                    "id": key
                    ])
                    artist.tracks.append(track)
                }
            }
        })
    }    
}








