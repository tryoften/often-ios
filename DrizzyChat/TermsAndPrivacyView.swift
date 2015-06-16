//
//  TermsAndPrivacyView.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/2/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class TermsAndPrivacyView: UIView {
    var termAndServiceLabel: UILabel!
    var andLabel: UILabel!
    var termsofServiceButton: UIButton!
    var privacyPolicyButton: UIButton!
    
     override init(frame: CGRect) {
        termAndServiceLabel = UILabel()
        termAndServiceLabel.textAlignment = .Center
        termAndServiceLabel.font = SubtitleFont
        termAndServiceLabel.textColor = SubtitleGreyColor
        termAndServiceLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        termAndServiceLabel.text = "By signin up to October you agree to our "
        
        andLabel = UILabel()
        andLabel.textAlignment = .Center
        andLabel.font = SubtitleFont
        andLabel.textColor = SubtitleGreyColor
        andLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        andLabel.text = "&"
        
        termsofServiceButton = UIButton()
        termsofServiceButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        termsofServiceButton.setTitle("Terms of Service", forState: .Normal)
        termsofServiceButton.titleLabel!.font = SubtitleFont
        termsofServiceButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
        privacyPolicyButton = UIButton()
        privacyPolicyButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        privacyPolicyButton.setTitle("Privacy Policy", forState: .Normal)
        privacyPolicyButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        privacyPolicyButton.titleLabel!.font = SubtitleFont
        privacyPolicyButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        addSubview(termAndServiceLabel)
        addSubview(andLabel)
        addSubview(termsofServiceButton)
        addSubview(privacyPolicyButton)
        
        setupLayout()
    }

     required init(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    func setupLayout() {
        addConstraints([
            termAndServiceLabel.al_top == al_top + 20,
            termAndServiceLabel.al_left == al_left,
            termAndServiceLabel.al_right == al_right,
            termAndServiceLabel.al_centerX == al_centerX,
            
            andLabel.al_top == termAndServiceLabel.al_bottom,
            andLabel.al_width == 15,
            andLabel.al_centerX == al_centerX,
            andLabel.al_height == 17,
            
            termsofServiceButton.al_top == termAndServiceLabel.al_bottom,
            termsofServiceButton.al_width == 95,
            termsofServiceButton.al_right == andLabel.al_left,
            termsofServiceButton.al_height == andLabel.al_height,
            
            privacyPolicyButton.al_top == termAndServiceLabel.al_bottom ,
            privacyPolicyButton.al_width == 80,
            privacyPolicyButton.al_left == andLabel.al_right,
            privacyPolicyButton.al_height == andLabel.al_height,
            ])
    }
    
}