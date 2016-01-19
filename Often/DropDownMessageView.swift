//
//  DropDownMessageView.swift
//  Often
//
//  Created by Komran Ghahremani on 1/16/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class DropDownMessageView: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(fromHexString: "#E95769")
        textAlignment = .Center
        textColor = WhiteColor
        font = UIFont(name: "Montserrat", size: 13.0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
