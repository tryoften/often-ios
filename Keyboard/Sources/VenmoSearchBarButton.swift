//
//  VenmoSearchBarButton.swift
//  Surf
//
//  Created by Luc Succes on 7/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class VenmoSearchBarButton: ServiceProviderSearchBarButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(fromHexString: "#4D97D2")
        addConstraint(al_width == 90)
        contentEdgeInsets = UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 3)
        setImage(UIImage(named: "venmo-logo"), forState: .Normal)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
}