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
    private var providerLogoImageView: UIImageView

    override init(frame: CGRect) {
        deleteButton = UIImageView(image: UIImage(named: "close"))
        deleteButton.setTranslatesAutoresizingMaskIntoConstraints(false)

        providerLogoImageView = UIImageView()
        providerLogoImageView.contentMode = .ScaleAspectFit
        providerLogoImageView.setTranslatesAutoresizingMaskIntoConstraints(false)

        super.init(frame: frame)
        
        setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView?.contentMode = .ScaleAspectFit
        
        addSubview(deleteButton)
        addSubview(providerLogoImageView)
        
        contentEdgeInsets = UIEdgeInsets(top: 3, left: 15, bottom: 3, right: 3)

        layer.cornerRadius = 3.0
        backgroundColor = UIColor(fromHexString: "#4D97D2")
        setupLayout()
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    func setupLayout() {
        addConstraints([
            al_height == 30,

            deleteButton.al_width == 8,
            deleteButton.al_height == 8,
            deleteButton.al_centerY == al_centerY,
            deleteButton.al_left == al_left + 8,
            
            providerLogoImageView.al_left == al_left + 5,
            providerLogoImageView.al_height == al_height - 8,
            providerLogoImageView.al_centerY == al_centerY
        ])
    }
}