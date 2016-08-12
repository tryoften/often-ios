//
//  ReportAlertView.swift
//  Often
//
//  Created by Komran Ghahremani on 8/10/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class ReportAlertView: AlertView {
    override var subtitleLabelLeftRightMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 20
        }
        
        if Diagnostics.platformString().desciption == "iPhone 6 Plus" || Diagnostics.platformString().desciption == "iPhone 6S Plus" {
            return 60
        }
        
        return 40
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        actionButton.setTitle("got it".uppercaseString, forState: .Normal)
        actionButton.titleLabel!.font = UIFont(name: "Montserrat", size: 10.5)
        
        characterImageView.image = UIImage(named: "pushNotificationModal")
        characterImageView.contentMode = .ScaleAspectFill
        
        titleLabel.text = "Thanks for Reporting!"
        
        subtitleLabel.text = "We'll take a look and make sure they're not up to something"
        subtitleLabel.font = UIFont(name: "OpenSans", size: 13)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
