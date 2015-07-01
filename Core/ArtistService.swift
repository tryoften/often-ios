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
    var artists: [Artist]
    
    override init(root: Firebase, realm: Realm = Realm()) {
        artistsRef = root.childByAppendingPath("owners")
        artists = [Artist]()
        
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
        artists = sorted(realm.objects(Artist)) {$0.name < $1.name}
        delegate?.serviceDataDidLoad(self)
        completion(true)
    }
    
    /**
    
    */
    func fetchDataForArtistIds(artistIds: [String], completion: ([Artist]) -> ()) {
        var index = 0
        var artistCount = artistIds.count
        var artistList =  [Artist]()
        
        for artistId in artistIds {
            self.processArtistData(artistId, completion: { (artist, success) in
                artist.index = index++
                artistList.append(artist)
                
                if index + 1 >= artistCount {
                    self.artists = sorted(artistList) { $0.name < $1.name }
                    
                    self.realm.write {
                        self.realm.add(self.artists, update: true)
                    }
                    
                NSNotificationCenter.defaultCenter().postNotificationName("database:persist", object: nil)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.delegate?.serviceDataDidLoad(self)
                        completion(self.artists)
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
                    self.delegate?.serviceDataDidLoad(self)
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
    func requestData(completion: ([Artist]) -> Void) {
        fetchLocalData { success in
            if success {
                completion(self.artists)
            }
            
        }
        
        fetchRemoteData { success in
            if success {
                completion(self.artists)
            }
        }
    }

    /**
        Retrieve a specific artist from the dictionary of artists that we get from the requestData method
        by passing in that artist's ID.
    
        :param: id The ID of the artist object
    
        :returns: The Artist object that corresponds to the ID in the artistsList dictionary or nil because of an invalid ID
    */
    func getArtistForId(id: String) -> Artist? {
        for artist in artists {
            if artist.id == id {
                return artist
            }
        }
        return nil
    }
    
    
    /**
    Processes JSON Artist data and creates models objects
    
    :param: artistId The id from the key/value store, the artist object ID
    :param: completion callback which gets called when artist objects are done being created
    */
    func processArtistData(artistId: String, completion: (Artist, Bool) -> ()) {
        let artistRef = rootURL.childByAppendingPath("owners/\(artistId)")
        
        artistRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let data = snapshot.value as? [String: AnyObject] {
                var artist = Artist()
                artist.id = snapshot.key
                artist.name = data["name"] as! String
                artist.imageURLSmall = data["image_small"] as! String
                artist.imageURLLarge = data["image_large"] as! String
                artist.lyricCount = data["lyrics_count"] as! Int
                artist.keyboardId = data["keyboard"] as! String
                
                if let tracks = data["tracks"] as? [String : [String: AnyObject]] {
                    self.processTracksData(artist, data: tracks)
                }
                completion(artist, true)
            }
        })
    }
    
    private func processTracksData(artist: Artist, data: [String : [String : AnyObject]]) {
        let tracks = List<Track>()
        
        for (trackId, trackData)in data {
            var track = Track()
            track.id = trackId
            track.setValuesForKeysWithDictionary(trackData)
            tracks.append(track)
        }
        
        artist.tracks.extend(tracks)
    }    
}








