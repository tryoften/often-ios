//
//  AddContentView.swift
//  Often
//
//  Created by Kervins Valcourt on 7/25/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Spring

class AddContentView: UIView {
    private var gifTitleLabel: UILabel
    private var imageTitleLabel: UILabel
    private var quoteTitleLabel: UILabel
    var addImageButton: SpringButton
    var addGifButton: SpringButton
    var addQuoteButton: SpringButton
    var cancelButton: UIButton

    override init(frame: CGRect) {
        gifTitleLabel = UILabel()
        gifTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        gifTitleLabel.setTextWith(UIFont(name: "Montserrat", size: 14.5)!, letterSpacing: 0.5, color: UIColor.oftWhiteColor(), text: " GIF".uppercaseString)
        gifTitleLabel.textAlignment = .Center

        imageTitleLabel = UILabel()
        imageTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageTitleLabel.setTextWith(UIFont(name: "Montserrat", size: 14.5)!, letterSpacing: 0.5, color: UIColor.oftWhiteColor(), text: "Photo")
        imageTitleLabel.textAlignment = .Center

        quoteTitleLabel = UILabel()
        quoteTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        quoteTitleLabel.setTextWith(UIFont(name: "Montserrat", size: 14.5)!, letterSpacing: 0.5, color: UIColor.oftWhiteColor(), text: " Quote")
        quoteTitleLabel.textAlignment = .Center

        addGifButton = SpringButton()
        addGifButton.translatesAutoresizingMaskIntoConstraints = false
        addGifButton.setImage(StyleKit.imageOfGifMenuButton(scale: 0.8, color: UIColor(fromHexString: "#FF7D92")), forState: .Normal)
        addGifButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 4, 6)
        addGifButton.backgroundColor = UIColor(fromHexString: "#FFE6EA")
        addGifButton.layer.cornerRadius = 32.5
        addGifButton.clipsToBounds = true

        addImageButton = SpringButton()
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.setImage(StyleKit.imageOfCameraIcon(scale:0.4), forState: .Normal)
        addImageButton.backgroundColor = UIColor(fromHexString: "#D7EEF4")
        addImageButton.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 0, 0)
        addImageButton.layer.cornerRadius = 32.5
        addImageButton.clipsToBounds = true

        addQuoteButton = SpringButton()
        addQuoteButton.translatesAutoresizingMaskIntoConstraints = false
        addQuoteButton.setImage(StyleKit.imageOfQuotesMenuButton(scale: 0.8, color: UIColor(fromHexString: "#FFA960")), forState: .Normal)
        addQuoteButton.backgroundColor = UIColor(fromHexString: "#FFF2E7")
        addQuoteButton.layer.cornerRadius = 32.5
        addQuoteButton.clipsToBounds = true

        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(StyleKit.imageOfTabBarCancel(), forState: .Normal)

        let buttons = [addGifButton, addImageButton, addQuoteButton]
        for button in buttons {
            button.hidden = true
            button.animation = "slideUp"
            button.duration = 0.5
            button.curve = "easeIn"
        }

        super.init(frame: frame)

        addSubview(addGifButton)
        addSubview(addImageButton)
        addSubview(addQuoteButton)
        addSubview(cancelButton)
        addSubview(gifTitleLabel)
        addSubview(imageTitleLabel)
        addSubview(quoteTitleLabel)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func animateButtons() {
        let buttons = [addGifButton, addImageButton, addQuoteButton]
        for button in buttons {
            button.hidden = false
            button.animate()
        }
    }

    func setupLayout() {
        addConstraints([
            addGifButton.al_bottom == al_bottom - 108,
            addGifButton.al_left == al_left + 54.5,
            addGifButton.al_height == 65,
            addGifButton.al_width == 65,

            cancelButton.al_bottom == al_bottom - 7.5,
            cancelButton.al_centerX == al_centerX,
            cancelButton.al_height == 43,
            cancelButton.al_width == 43,

            gifTitleLabel.al_top == addGifButton.al_bottom + 4,
            gifTitleLabel.al_centerX == addGifButton.al_centerX,
            gifTitleLabel.al_width == addGifButton.al_width,

            addImageButton.al_centerX == al_centerX,
            addImageButton.al_height == 65,
            addImageButton.al_width == 65,
            addImageButton.al_bottom == al_bottom - 165.5,

            imageTitleLabel.al_top == addImageButton.al_bottom + 4,
            imageTitleLabel.al_centerX == addImageButton.al_centerX,
            imageTitleLabel.al_width == addImageButton.al_width,

            addQuoteButton.al_bottom == al_bottom - 108,
            addQuoteButton.al_right == al_right - 54.5,
            addQuoteButton.al_height == 65,
            addQuoteButton.al_width == 65,

            quoteTitleLabel.al_top == addQuoteButton.al_bottom + 4,
            quoteTitleLabel.al_centerX == addQuoteButton.al_centerX,
            quoteTitleLabel.al_width == addQuoteButton.al_width,
            ])
    }
}