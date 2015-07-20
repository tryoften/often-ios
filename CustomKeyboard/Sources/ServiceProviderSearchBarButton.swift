//
//  SearchBarServiceProviderTokenView.swift
//  Surf
//
//  Created by Luc Succes on 7/19/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import UIKit

class ServiceProviderSearchBarButton: UIButton {
    var deleteButton: UIView
    var providerLogoImage: UIImage? {
        didSet {
            setImage(providerLogoImage, forState: .Normal)
        }
    }

    override init(frame: CGRect) {
        deleteButton = UIImageView(image: UIImage(named: "close"))

        super.init(frame: frame)
        
        setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView?.contentMode = .ScaleAspectFit
        
        addSubview(deleteButton)
        
        contentEdgeInsets = UIEdgeInsets(top: 3, left: 15, bottom: 3, right: 3)
        layer.cornerRadius = 3.0
        backgroundColor = UIColor(fromHexString: "#4D97D2")
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let topMargin = CGRectGetHeight(frame) / 2 - 4.0
        deleteButton.frame = CGRectMake(8.0, topMargin, 8.0, 8.0)
    }
}