//
//  CompleteInstallationView.swift
//  Often
//
//  Created by Kervins Valcourt on 10/15/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class CompleteInstallationView : UIView {
    var checkMarkView: UIImageView
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var finishedButton: UIButton
    
    override init(frame: CGRect) {
        let titleText = "Congrats!"
        let titleRange = NSMakeRange(0, titleText.characters.count)
        let title = NSMutableAttributedString(string: titleText)
        title.addAttribute(NSFontAttributeName, value: UIFont(name: "Montserrat-Regular", size: 19)!, range: titleRange)
        title.addAttribute(NSKernAttributeName, value: 0.2, range: titleRange)
        
        let buttonTitleText = "Finish"
        let buttonTitleRange = NSMakeRange(0, buttonTitleText.characters.count)
        let buttonTitleAttributedString = NSMutableAttributedString(string: buttonTitleText)
        buttonTitleAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Montserrat-Regular", size: 15)!, range: buttonTitleRange)
        buttonTitleAttributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: buttonTitleRange)
        buttonTitleAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: buttonTitleRange)
        
        checkMarkView = UIImageView()
        checkMarkView.translatesAutoresizingMaskIntoConstraints = false
        checkMarkView.contentMode = .ScaleAspectFit
        checkMarkView.image = UIImage(named: "checkMark")
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Montserrat-Regular", size: 19)
        titleLabel.attributedText = title
        titleLabel.textAlignment = .Center
        titleLabel.textColor = WhiteColor
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont(name: "OpenSans-Semibold", size: 14)
        subtitleLabel.text = "You’ve successfully installed Often! Now go regulate on the homies"
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .Center
        subtitleLabel.textColor = WhiteColor
        
        finishedButton = UIButton()
        finishedButton.translatesAutoresizingMaskIntoConstraints = false
        finishedButton.backgroundColor = SignupViewCreateAccountButtonColor
        finishedButton.setAttributedTitle(buttonTitleAttributedString, forState: .Normal)
    
        super.init(frame: frame)
        
        backgroundColor = TealColor
        
        addSubview(checkMarkView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(finishedButton)
        
         setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            checkMarkView.al_top == al_top + 40,
            checkMarkView.al_height == 80,
            checkMarkView.al_width == 80,
            checkMarkView.al_centerX == al_centerX,
            
            titleLabel.al_top == checkMarkView.al_bottom + 20,
            titleLabel.al_height == 40,
            titleLabel.al_width == 100,
            titleLabel.al_centerX == al_centerX,
            
            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_left == al_left + 50,
            subtitleLabel.al_right == al_right - 50,
            subtitleLabel.al_height == 50,
            
            finishedButton.al_top == subtitleLabel.al_bottom,
            finishedButton.al_height == 60,
            finishedButton.al_width == 100,
            finishedButton.al_centerX == al_centerX
            ])
    }

}