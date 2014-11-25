//
//  Lyric.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/15/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class Lyric: NSObject {
    var id: String
    var text: String
    var categoryId: String
    var trackId: String?
    
    init(id: String, text: String, categoryId: String, trackId: String?) {
        self.id = id
        self.text = text
        self.categoryId = categoryId
        self.trackId = trackId

        super.init()
    }
}
