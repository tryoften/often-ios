//
//  AnimatedMenuButton.swift
//  Often
//
//  Created by Katelyn Findlay on 4/20/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class AnimatedMenuButton: AwesomeMenu {
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
        
        startMenuItem.layer.cornerRadius = 25
        startMenuItem.contentImageView.contentMode = .ScaleAspectFill
        startMenuItem.contentImageView.layer.borderColor = WhiteColor.CGColor
        startMenuItem.contentImageView.layer.borderWidth = 2.0
        startMenuItem.clipsToBounds = true
        startMenuItem.layer.borderColor = WhiteColor.CGColor
        startMenuItem.layer.borderWidth = 4.0
        
        super.init(frame: frame, startItem: startMenuItem, menuItems: [packsMenuItem, categoryMenuItem, quotesMenuItem, gifsMenuItem])
        
        startPoint = CGPointMake(frame.width-35, frame.height-40)
        rotateAngle = CGFloat(3 * M_PI_2)
        menuWholeAngle = CGFloat(M_PI / 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}