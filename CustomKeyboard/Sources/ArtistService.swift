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
    var artistsList: [String: Artist]
    
    init(root: Firebase) {
        artistsRef = root.childByAppendingPath("owners")
        artistsList = [String: Artist]()
        super.init()
    }
    
    func requestData(completion: (artistsList:[String: Artist]) -> Void) {
        artistsRef.observeEventType(.Value, withBlock: { (snapshot) -> Void in
            if let artistsData = snapshot.value as? [String: NSDictionary] {
                for (owner, data) in artistsData
                {
                    let artistsRefName = Artist(id: owner, dictionary: data)
                    self.artistsList[owner] = artistsRefName
                }
    
                if self.artistsList.count >= 1{
                    completion(artistsList: self.artistsList)
                }
            }

        })
    }
    
    
    
}








