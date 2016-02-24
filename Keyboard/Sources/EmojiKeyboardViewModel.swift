//
//  EmojiKeyboardViewModel.swift
//  Often
//
//  Created by Komran Ghahremani on 2/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class EmojiKeyboardViewModel: NSObject {
    var emojis: [String : AnyObject]?
    
    override init() {
        if let emojisPath = NSBundle.mainBundle().pathForResource("EmojisList", ofType: "plist") {
            emojis = NSDictionary(contentsOfFile: emojisPath) as? [String : AnyObject]
        } else {
            emojis = [String : AnyObject]()
        }
        
        super.init()
    }
}
