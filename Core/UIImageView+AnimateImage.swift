//
//  UIImageView+AnimateImage.swift
//  Often
//
//  Created by Luc Succes on 1/10/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

extension UIImageView {

    func setImageWithAnimation(url: NSURL, blurRadius: CGFloat = 0, placeholderImage: UIImage? = UIImage(named: "placeholder"), completion: ((Bool) -> ())? = nil) {
        alpha = 0.0

//        let urlRequest = NSURLRequest(URL: url, cachePolicy: .ReturnCacheDataElseLoad, timeoutInterval: 60 * 60)
//        self.cancelImageRequestOperation()
//        
//        self.setImageWithURLRequest(urlRequest, placeholderImage: UIImage(named: "placeholder"), success: { (req, res, image) in
//            let processedImage: UIImage = image
//                self.image = processedImage
//                UIView.animateWithDuration(0.3) {
//                    self.alpha = 1.0
//                    completion?(true)
//                }
//
//            }, failure: { (req, res, err) in
//                completion?(false)
//        })
    }

}
