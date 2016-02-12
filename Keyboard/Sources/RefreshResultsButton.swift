//
//  RefreshResultsButton.swift
//  Often
//
//  Created by Luc Succes on 10/14/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class RefreshResultsButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 15
        backgroundColor = UIColor(fromHexString: "#21CE99")
        titleLabel!.font = UIFont(name: "Montserrat-Regular", size: 9)
        setTitle("view latest results".uppercaseString, forState: .Normal)
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
