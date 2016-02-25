//
//  EmojiKeyboardCollectionViewCell.swift
//  Often
//
//  Created by Komran Ghahremani on 2/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class EmojiKeyboardTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = ClearColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
