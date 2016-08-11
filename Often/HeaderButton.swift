//
//  HeaderButton.swift
//  Often
//
//  Created by Katelyn Findlay on 8/9/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class HeaderButton: UIButton {
    var textLabel: UILabel
    
    var text: String? {
        didSet {
            textLabel.setTextWith(UIFont(name: "Montserrat", size: 10.5)!, letterSpacing: 1.0, color: WhiteColor, text: text!.uppercaseString)
        }
    }
    
    override init(frame: CGRect) {
        textLabel = UILabel()
        textLabel.textAlignment = .Left
        textLabel.backgroundColor = ClearColor
        
        super.init(frame: frame)
        addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func intrinsicContentSize() -> CGSize {
        guard let titleLabel = titleLabel, let imageView = imageView else {
            return CGSizeZero
        }

        let textSize = titleLabel.intrinsicContentSize()
        let imageSize = imageView.intrinsicContentSize()

        return CGSizeMake(textSize.width + imageSize.width, max(textSize.height, imageSize.height))
    }
}

