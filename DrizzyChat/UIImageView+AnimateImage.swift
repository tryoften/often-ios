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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            var urlRequest = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 60 * 60)
            self.cancelImageRequestOperation()
            self.setImageWithURLRequest(urlRequest, placeholderImage: UIImage(named: "placeholder"), success: { (req, res, image) in
                var processedImage: UIImage = image
                
                if blurRadius != 0 {
                    processedImage = image.blurredImageWithRadius(blurRadius, iterations: 9, tintColor: UIColor.clearColor())
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.image = processedImage
                    UIView.animateWithDuration(0.3) {
                        self.alpha = 1.0
                        completion?(true)
                    }
                }
                
                }, failure: { (req, res, err) in
                    completion?(false)
            })
        }
    }
    
}
