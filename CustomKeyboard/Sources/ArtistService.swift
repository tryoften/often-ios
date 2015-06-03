//
//  ArtistService.swift
//  Drizzy
//
//  Created by Luc Success on 4/15/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class ArtistService: NSObject {
    var artistsRef: Firebase
    var artists: [String: Artist]
    
    init(root: Firebase) {
        artistsRef = root.childByAppendingPath("owners")
        artists = [String: Artist]()
        super.init()
    }
    
    func requestData(completion: (success:Bool) -> Void) {
        artistsRef.observeEventType(.Value, withBlock: { (snapshot) -> Void in
            if let artistsData = snapshot.value as? [String: NSDictionary] {
                for (owner, data) in artistsData
                {
                    //let artistsRefKey = owner
                    let artistsRefName = Artist(id: owner, dictionary: data)
                    
                    //println(artistsRefKey)
                    println(artistsRefName.name)
                }
                
            }

        })
        
    }
}
