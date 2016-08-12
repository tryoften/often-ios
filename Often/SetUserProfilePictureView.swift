//
//  SetUserProfilePictureView.swift
//  Often
//
//  Created by Kervins Valcourt on 8/9/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class SetUserProfilePictureView: UIView {
    private var title: UILabel
    private var subtitle: UILabel
    private var loadingBar: UIView

    var skipButton: UIButton
    var nextButton: UIButton
    var imageView: UIImageView
    var addPhotoButton: UploadPhotoButton

    override init(frame: CGRect) {
        title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .Center
        title.setTextWith(UIFont(name: "Montserrat-Regular", size: 18)!, letterSpacing: 1.0, color: UIColor.oftBlackColor(), text: "Let’s set up your profile")

        subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.numberOfLines = 0
        subtitle.textAlignment = .Center
        subtitle.setTextWith(UIFont(name: "OpenSans", size: 13)!, letterSpacing: 0.5, color: UIColor.oftBlack74Color(), text: "Choose a cover pic for your keyboard! Your friends will see this btw")

        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFit

        loadingBar = UIView()
        loadingBar.translatesAutoresizingMaskIntoConstraints = false
        loadingBar.backgroundColor = TealColor

        let buttonAttributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(float: 1.0),
            NSFontAttributeName: UIFont(name: "Montserrat", size: 10.5)!,
            NSForegroundColorAttributeName: UIColor.oftBlack54Color()
        ]

        skipButton = UIButton()
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.backgroundColor = UIColor.whiteColor()
        skipButton.setAttributedTitle( NSAttributedString(string: "skip".uppercaseString, attributes: buttonAttributes), forState: .Normal)
        skipButton.layer.cornerRadius = 25
        skipButton.layer.borderColor = UIColor(hex: "#E3E3E3").CGColor
        skipButton.layer.borderWidth = 2
        skipButton.clipsToBounds = true

        nextButton = UIButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.backgroundColor = UIColor.whiteColor()
        nextButton.setAttributedTitle( NSAttributedString(string: "next".uppercaseString, attributes: buttonAttributes), forState: .Normal)
        nextButton.layer.cornerRadius = 25
        nextButton.layer.borderColor = UIColor(hex: "#E3E3E3").CGColor
        nextButton.layer.borderWidth = 2
        nextButton.clipsToBounds = true

        addPhotoButton = UploadPhotoButton()
        addPhotoButton.backgroundColor = WhiteColor
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.layer.shadowRadius = 5
        addPhotoButton.layer.shadowOpacity = 0.2
        addPhotoButton.layer.shadowColor = MediumLightGrey.CGColor
        addPhotoButton.layer.shadowOffset = CGSizeMake(0, 1)

        super.init(frame: frame)

        addSubview(title)
        addSubview(subtitle)
        addSubview(skipButton)
        addSubview(nextButton)
        addSubview(addPhotoButton)
        addSubview(imageView)
        addSubview(loadingBar)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            title.al_top == al_top + 109,
            title.al_left == al_left + 20,
            title.al_right == al_right - 20,
            title.al_height == 20,

            subtitle.al_top == title.al_bottom + 17.5,
            subtitle.al_left == al_left + 60,
            subtitle.al_right == al_right - 60,
            subtitle.al_height == 42,

            addPhotoButton.al_top == subtitle.al_bottom + 69,
            addPhotoButton.al_centerY == al_centerY,
            addPhotoButton.al_centerX == al_centerX,
            addPhotoButton.al_height == 175,
            addPhotoButton.al_width == 175,

            imageView.al_top == addPhotoButton.al_top ,
            imageView.al_centerY == addPhotoButton.al_centerY,
            imageView.al_centerX == addPhotoButton.al_centerX,
            imageView.al_height == addPhotoButton.al_height,
            imageView.al_width == addPhotoButton.al_width,

            skipButton.al_left == al_left + 40.5,
            skipButton.al_right == al_centerX - 3.5,
            skipButton.al_height == 52,
            skipButton.al_bottom == al_bottom - 40.5,

            nextButton.al_right == al_right - 40.5,
            nextButton.al_left == al_centerX + 3.5,
            nextButton.al_height == 52,
            nextButton.al_bottom == al_bottom - 40.5,

            loadingBar.al_left == al_left,
            loadingBar.al_right == al_right,
            loadingBar.al_bottom == al_bottom,
            loadingBar.al_height == 5
            ])
    }
}