//
//  AnimatedMenuButton.swift
//  Often
//
//  Created by Katelyn Findlay on 4/20/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

enum AnimatedMenuItem: Int {
    case Packs = 0
    case Categories = 1
    case Quotes = 3
    case Gifs = 4
}

class AnimatedMenu: AwesomeMenu {
    var packsMenuItem: AwesomeMenuItem
    var categoryMenuItem: AwesomeMenuItem
    var quotesMenuItem: AwesomeMenuItem
    var gifsMenuItem: AwesomeMenuItem
    var startMenuItem: AwesomeMenuItem

    override init(frame: CGRect) {
        
        let menuButton: UIImage = StyleKit.imageOfMenuButton(selected: false)
        let menuButtonSelected: UIImage = StyleKit.imageOfMenuButton(selected: true)
        
        startMenuItem = AwesomeMenuItem(image: menuButton, highlightedImage: nil, contentImage: StyleKit.imageOfPacktab(), highlightedContentImage: nil)
        packsMenuItem = AwesomeMenuItem(image: menuButton, highlightedImage: menuButtonSelected, contentImage: StyleKit.imageOfPacktab(), highlightedContentImage: nil)
        categoryMenuItem = AwesomeMenuItem(image: menuButton, highlightedImage: menuButtonSelected, contentImage: StyleKit.imageOfCategoryButton(), highlightedContentImage: nil)
        quotesMenuItem = AwesomeMenuItem(image: menuButton, highlightedImage: menuButtonSelected, contentImage: StyleKit.imageOfPacktab(), highlightedContentImage: nil)
        gifsMenuItem = AwesomeMenuItem(image: menuButton, highlightedImage: menuButtonSelected, contentImage: StyleKit.imageOfPacktab(), highlightedContentImage: nil)

        let blankMenuItem = AwesomeMenuItem(image: UIImage(), highlightedImage: UIImage(), contentImage: nil, highlightedContentImage: nil)
        
        startMenuItem.layer.cornerRadius = 25
        startMenuItem.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.19).CGColor
        startMenuItem.layer.shadowOffset = CGSizeMake(0, 3)
        startMenuItem.layer.shadowRadius = 6
        startMenuItem.layer.shadowOpacity = 1.0
        startMenuItem.layer.borderColor = WhiteColor.CGColor
        startMenuItem.layer.borderWidth = 4.0
        startMenuItem.contentImageView.contentMode = .ScaleAspectFill
        startMenuItem.contentImageView.layer.borderColor = WhiteColor.CGColor
        startMenuItem.contentImageView.layer.borderWidth = 2.0
        startMenuItem.contentImageView.clipsToBounds = true
        startMenuItem.contentImageView.layer.cornerRadius = 25
        
        super.init(frame: frame, startItem: startMenuItem, menuItems: [packsMenuItem, categoryMenuItem, blankMenuItem, quotesMenuItem, gifsMenuItem])

        rotateAngle = CGFloat(3 * M_PI_2)
        menuWholeAngle = CGFloat(M_PI_2)
        endRadius = 130.0
        resetStartPoint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func resetStartPoint() {
        startPoint = CGPointMake(frame.width - 40, frame.height - 70)
    }
}