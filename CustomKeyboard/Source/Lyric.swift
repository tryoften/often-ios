//
//  Lyric.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/15/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class Lyric: NSObject {
    var text: String
    var categoryId: String
    var trackId: String
    
    init(text: String, categoryId: String, trackId: String) {
        self.text = text
        self.categoryId = categoryId
        self.trackId = trackId

        super.init()
    }
}
