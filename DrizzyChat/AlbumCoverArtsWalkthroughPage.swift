//
//  AlbumCoverArtsWalkthroughPage.swift
//  Drizzy
//
//  Created by Luc Success on 2/7/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class AlbumCoverArtsWalkthroughPage: WalkthroughPage {
    
    var isAnimationDone: Bool
    
    required init(frame: CGRect) {
        self.isAnimationDone = false
        super.init(frame: frame)
        self.type = .AlbumCoverArtsPage
    }
    
    override func setupPage() {
        var images = [
            UIImage(named: "if you're reading this now, it's too late"),
            UIImage(named: "nothing was the same"),
            UIImage(named: "thank me later"),
            UIImage(named: "0 to 100"),
            UIImage(named: "take care"),
            UIImage(named: "trophies")
        ]
        var imageViews = [UIImageView]()
        
        // midpoint in screen
        var midX: CGFloat = CGRectGetWidth(self.frame) / 2
        // spacing between images
        var spacing: CGFloat = 2.5
        var topMargin: CGFloat = 0
        var prevPicLeft: UIImageView?
        var prevPicRight: UIImageView?
        var scale = UIScreen.mainScreen().scale
        
        if isIPhone5() {
            topMargin = 240
        } else {
            topMargin = 300
        }
    
        for (i, image) in enumerate(images) {
            var imageView = UIImageView(image: image)
            imageView.alpha = 0.0
            imageView.sizeToFit()
            var fullHeight = CGFloat(CGRectGetHeight(imageView.frame))
            var fullWidth = CGFloat(CGRectGetWidth(imageView.frame))
            
            if isIPhone5() {
                fullHeight -= 20
                fullWidth -= 20
                imageView.frame = CGRectMake(0, 0, fullWidth, fullHeight)
            } else if scale == 3.0 {
                fullHeight -= 30
                fullWidth -= 30
                imageView.frame = CGRectMake(0, 0, fullWidth, fullHeight)
            }
            
            if prevPicRight == nil {
                imageView.center = CGPointMake(midX + fullWidth / 2 + spacing,
                    topMargin)
                prevPicRight = imageView
            } else if prevPicLeft == nil {
                imageView.center = CGPointMake(midX - fullWidth / 2 - spacing,
                    topMargin + 20)
                prevPicLeft = imageView
            } else {
                if i % 2 == 0 {
                    imageView.frame = CGRectMake(midX + spacing, CGFloat(CGRectGetMaxY(prevPicRight!.frame) + spacing), CGRectGetWidth(prevPicRight!.frame), CGRectGetHeight(prevPicRight!.frame))
                    prevPicRight = imageView
                } else {
                    imageView.frame = CGRectMake(midX - fullWidth - spacing, CGFloat(CGRectGetMaxY(prevPicLeft!.frame) + spacing), CGRectGetWidth(prevPicLeft!.frame), CGRectGetHeight(prevPicLeft!.frame))
                    prevPicLeft = imageView
                }
            }
            
            self.addSubview(imageView)
            imageViews.append(imageView)
        }
        
        self.imageViews = imageViews
    }
    
    override func pageDidShow() {
        if isAnimationDone {
            return
        }

        for (i, imageView) in enumerate(self.imageViews!) {
            imageView.alpha = 0.0
            imageView.center = CGPointMake(imageView.center.x, imageView.center.y + 100)
            UIView.animateKeyframesWithDuration(NSTimeInterval(0.3), delay: NSTimeInterval(i) * 0.15, options: nil, animations: {
                imageView.alpha = 1.0
                imageView.center = CGPointMake(imageView.center.x, imageView.center.y - 100)
                }, completion: { completed in
                    self.delegate?.walkthroughPage(self, shouldHideControls: false)
                    return
            })
            
        }
        isAnimationDone = true
    }

}
