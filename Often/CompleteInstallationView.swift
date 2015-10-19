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
        checkMarkView = UIImageView()
        checkMarkView.translatesAutoresizingMaskIntoConstraints = false
        checkMarkView.contentMode = .ScaleAspectFit
        checkMarkView.image = UIImage(named: "checkMark")
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "OpenSan", size: 14)
        titleLabel.text = "Congrats!"
        titleLabel.textAlignment = .Center
        titleLabel.textColor = WhiteColor
        
        subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont(name: "OpenSan", size: 14)
        subtitleLabel.text = "You’ve successfully installed Often! Now go regulate on the homies"
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .Center
        subtitleLabel.textColor = WhiteColor
        
        finishedButton = UIButton()
        finishedButton.translatesAutoresizingMaskIntoConstraints = false
        finishedButton.backgroundColor = SignupViewCreateAccountButtonColor
        finishedButton.setTitle("Finish", forState: .Normal)
        finishedButton.titleLabel!.font = UIFont(name: "OpenSan", size: 11)
        finishedButton.setTitleColor(UIColor.whiteColor() , forState: .Normal)
        
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
            checkMarkView.al_height == 100,
            checkMarkView.al_width == 100,
            checkMarkView.al_centerX == al_centerX,
            
            titleLabel.al_top == checkMarkView.al_bottom + 20,
            titleLabel.al_height == 40,
            titleLabel.al_width == 100,
            titleLabel.al_centerX == al_centerX,
            
            subtitleLabel.al_top == titleLabel.al_bottom + 20,
            subtitleLabel.al_left == al_left + 40,
            subtitleLabel.al_right == al_right - 40,
            subtitleLabel.al_height == 70,
            
            finishedButton.al_top == subtitleLabel.al_bottom + 20,
            finishedButton.al_height == 70,
            finishedButton.al_width == 100,
            finishedButton.al_centerX == al_centerX
            ])
    }

}