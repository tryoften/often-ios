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
        termAndServiceLabel.text = "By registering, I accept the "
        
        andLabel = UILabel()
        andLabel.textAlignment = .Center
        andLabel.font = SubtitleFont
        andLabel.textColor = SubtitleGreyColor
        andLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        andLabel.text = "&"
        
        termsofServiceButton = UIButton()
        termsofServiceButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        termsofServiceButton.setTitle("Terms of Service", forState: .Normal)
        termsofServiceButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
        privacyPolicyButton = UIButton()
        privacyPolicyButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        privacyPolicyButton.setTitle("Privacy Policy", forState: .Normal)
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
            
            andLabel.al_top == termAndServiceLabel.al_bottom + 6,
            andLabel.al_width == 20,
            andLabel.al_centerX == al_centerX,
            
            termsofServiceButton.al_top == termAndServiceLabel.al_bottom + 2,
            termsofServiceButton.al_width == 140,
            termsofServiceButton.al_right == andLabel.al_left - 4,
            
            privacyPolicyButton.al_top == termAndServiceLabel.al_bottom + 2,
            privacyPolicyButton.al_width == 120,
            privacyPolicyButton.al_left == andLabel.al_right + 4,
            
            ])
    }
    
}