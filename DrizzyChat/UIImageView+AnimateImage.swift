//
//  UIImageView+AnimateImage.swift
//  Drizzy
//
//  Created by Luc Succes on 6/28/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImageWithAnimation(url: NSURL, blurRadius: CGFloat = 0, completion: ((Bool) -> ())? = nil) {
        alpha = 0.0
        var urlRequest = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 60 * 60)
        setImageWithURLRequest(urlRequest, placeholderImage: UIImage(named: "placeholder"), success: { (req, res, image) in
            UIView.animateWithDuration(0.3) {
                if blurRadius == 0 {
                    self.image = image
                } else {
                    self.image = image.blurredImageWithRadius(blurRadius, iterations: 9, tintColor: UIColor.clearColor())
                }
                
                self.alpha = 1.0
                completion?(true)
            }
            }, failure: { (req, res, err) in
                completion?(false)
        })
    }
    
}
