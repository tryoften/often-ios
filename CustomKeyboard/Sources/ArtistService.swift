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
    
    func requestData(completion: (Bool) -> Void) {
        
    }
}
