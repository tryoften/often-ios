//
//  TextConvoWalkthroughPage.swift
//  Drizzy
//
//  Created by Luc Success on 2/7/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class TextConvoWalkthroughPage: WalkthroughPage {
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        self.type = .TextConvoPage
    }
    
    override func setupPage() {
        
        var textImages = [
            UIImage(named: "text 1"),
            UIImage(named: "text 2"),
            UIImage(named: "text 3"),
            UIImage(named: "text 4"),
            UIImage(named: "text 5"),
            UIImage(named: "text 6"),
            UIImage(named: "text 7")
        ]
        
        var topConstraints = [NSLayoutConstraint]()
        var imageViews = [UIImageView]()
        var prevDelay: NSTimeInterval = 0
        var prevView: UIView = self.subtitleLabel
        var side: String
        
        for (i, image) in enumerate(textImages) {
            var scaledImage = (isIPhone5()) ? UIImage(CGImage: image?.CGImage, scale: CGFloat(0.5), orientation: UIImageOrientation.Up) : image
            println("image: \(image!.size) scaledImage: \(scaledImage?.size)")
            var imageView = UIImageView(image: scaledImage)
            imageView.alpha = 0.0
            imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
            imageView.contentMode = .ScaleAspectFit
            self.addSubview(imageView)
            
            var constraints = [NSLayoutConstraint]()
            
            var topConstraint: NSLayoutConstraint!
            
            if i == 0 || i == 2 || i == 5 {
                constraints.append(imageView.al_left ==  self.al_left + 20)
                topConstraint = imageView.al_top == prevView.al_bottom + ((i == 0) ? 125 : 115)
                constraints.append(topConstraint)
                side = "left"
            } else {
                if i != 3 {
                    constraints.append(imageView.al_right == self.al_right - 20)
                }
                topConstraint = imageView.al_top == prevView.al_bottom + 115
                constraints.append(topConstraint)
                side = "right"
            }
            
            constraints.append(imageView.al_width == image!.size.width)
            constraints.append(imageView.al_height == (isIPhone5() ? image!.size.height - 8 : image!.size.height))
            self.addConstraints(constraints)
            topConstraints.append(topConstraint)
            imageViews.append(imageView)
            prevView = imageView
        }
        
        self.addConstraint(imageViews[3].al_leading == imageViews[4].al_leading)
        
        for (i, imageView) in enumerate(imageViews) {
            var duration = NSTimeInterval(0.3)
            var delay = NSTimeInterval(i)
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDelay(delay)
            UIView.setAnimationDuration(duration)
            imageView.alpha = 1.0
            topConstraints[i].constant -= 105
            UIView.commitAnimations()
        }
    }
}
