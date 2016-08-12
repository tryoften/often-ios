//
//  OnboardingHeader.swift
//  Often
//
//  Created by Kervins Valcourt on 8/12/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class OnboardingHeader: UIView {
    private var title: UILabel
    private var subtitle: UILabel
    
    var titleText: String? {
        didSet {
            title.setTextWith(UIFont(name: "Montserrat-Regular", size: 18)!, letterSpacing: 1.0, color: UIColor.oftBlackColor(), text: titleText!)
        }
    }
    
    var subtitleText: String? {
        didSet {
            subtitle.setTextWith(UIFont(name: "OpenSans", size: 13)!, letterSpacing: 0.5, color: UIColor.oftBlack74Color(), text: subtitleText!)
        }
    }

    var skipButton: UIButton
    var nextButton: UIButton

    override init(frame: CGRect) {
        title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .Center
        title.setTextWith(UIFont(name: "Montserrat-Regular", size: 18)!, letterSpacing: 1.0, color: UIColor.oftBlackColor(), text: "Let’s add some GIFs!")

        subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.numberOfLines = 0
        subtitle.textAlignment = .Center
        subtitle.setTextWith(UIFont(name: "OpenSans", size: 13)!, letterSpacing: 0.5, color: UIColor.oftBlack74Color(), text: "Choose an image to be the cover of your pack! Your friends will see this")

        skipButton = UIButton()
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.setTitle("Skip", forState: .Normal)
        skipButton.titleLabel?.font = UIFont(name: "OpenSans", size: 15.0)
        skipButton.setTitleColor(UIColor.oftBlack54Color(), forState: .Normal)

        nextButton = UIButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", forState: .Normal)
        nextButton.titleLabel?.font = UIFont(name: "OpenSans-Semibold", size: 15.0)
        nextButton.setTitleColor(UIColor.oftBlack90Color(), forState: .Normal)
        nextButton.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
        
        super.init(frame: frame)

        addSubview(title)
        addSubview(subtitle)
        addSubview(skipButton)
        addSubview(nextButton)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            title.al_top == al_top + 109,
            title.al_centerX == al_centerX,
            title.al_height == 20,

            subtitle.al_top == title.al_bottom + 5,
            subtitle.al_left == al_left + 60,
            subtitle.al_right == al_right - 60,
            subtitle.al_bottom == al_bottom,

            skipButton.al_top == al_top + 32,
            skipButton.al_left == al_left + 19,
            skipButton.al_height == 25,
            skipButton.al_width == 49.6,

            nextButton.al_top == al_top + 32,
            nextButton.al_right == al_right - 19,
            nextButton.al_height == 25,
            nextButton.al_width == 49.6,
            ])
    }
}