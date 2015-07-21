//
//  SearchBarServiceProviderTokenView.swift
//  Surf
//
//  Created by Luc Succes on 7/19/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import UIKit

class ServiceProviderSearchBarButton: SearchBarButton {
    var providerLogoImage: UIImage? {
        didSet {
            setImage(providerLogoImage, forState: .Normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(fromHexString: "#4D97D2")
    }
}