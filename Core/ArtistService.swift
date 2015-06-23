//
//  ArtistService.swift
//  Drizzy
//
//  Created by Luc Success on 4/15/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class ArtistService: NSObject {
    var firebase: Firebase
    var artistsList: [String: Artist]
    
    init(root: Firebase) {
        firebase = root.childByAppendingPath("owners")
        artistsList = [String: Artist]()
        super.init()
    }
    
    func requestData(completion: (artistsList:[String: Artist]) -> Void) {
        firebase.observeEventType(.Value, withBlock: { (snapshot) -> Void in
            if let artistsData = snapshot.value as? [String: NSDictionary] {
                for (owner, data) in artistsData {
                    var artistData = data.mutableCopy() as! NSMutableDictionary
                    artistData["keyboardId"] = artistData["keyboard"]
                    var artist = Artist(value: artistData)
                    artist.id = owner
                    artist.imageURLLarge = data["image_large"] as! String
                    artist.lyricCount = data["lyrics_count"] as! Int
                    self.artistsList[owner] = artist
                }
    
                if self.artistsList.count >= 1 {
                    completion(artistsList: self.artistsList)
                }
            }

        })
    }
    
    
    
}








