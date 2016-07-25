//
//  AddPackView.swift
//  Often
//
//  Created by Kervins Valcourt on 7/25/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class AddPackView: UIView {
    private var titleLabel: UILabel
    private var descriptionLabel: UILabel
    private var gifTitleLabel: UILabel
    private var imageTitleLabel: UILabel
    private var quoteTitleLabel: UILabel
    var imageView: UIImageView
    var addImageButton: UIButton
    var addGifButton: UIButton
    var addQuoteButton: UIButton

    override init(frame: CGRect) {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "majorkeycharacter")

        gifTitleLabel = UILabel()
        gifTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        gifTitleLabel.setTextWith(UIFont(name: "Montserrat", size: 14.5)!, letterSpacing: 0.5, color: UIColor.oftBlackColor(), text: " GIF".uppercaseString)
        gifTitleLabel.textAlignment = .Center

        imageTitleLabel = UILabel()
        imageTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageTitleLabel.setTextWith(UIFont(name: "Montserrat", size: 14.5)!, letterSpacing: 0.5, color: UIColor.oftBlackColor(), text: "Photo")
        imageTitleLabel.textAlignment = .Center

        quoteTitleLabel = UILabel()
        quoteTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        quoteTitleLabel.setTextWith(UIFont(name: "Montserrat", size: 14.5)!, letterSpacing: 0.5, color: UIColor.oftBlackColor(), text: " Quote")
        quoteTitleLabel.textAlignment = .Center

        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.setTextWith(UIFont(name: "OpenSans", size: 13)!, letterSpacing: 0.5, color: UIColor.oftDarkGrey74Color(), text: "Add your favorite GIF’s, Photo’s, and Quotes for your friends to share")
        descriptionLabel.textAlignment = .Center

        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setTextWith(UIFont(name: "Montserrat", size: 15)!, letterSpacing: 0.8, color: UIColor.oftBlackColor(), text: "Let’s start making your pack")
        titleLabel.textAlignment = .Center

        addGifButton = UIButton()
        addGifButton.translatesAutoresizingMaskIntoConstraints = false
        addGifButton.setImage(StyleKit.imageOfGifMenuButton(color: UIColor(fromHexString: "#FF7D92")), forState: .Normal)
        addGifButton.backgroundColor = UIColor(fromHexString: "#FFE6EA")
        addGifButton.layer.cornerRadius = 32.5
        addGifButton.clipsToBounds = true

        addImageButton = UIButton()
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.setImage(StyleKit.imageOfCamera(scale:0.4), forState: .Normal)
        addImageButton.backgroundColor = UIColor(fromHexString: "#D7EEF4")
        addImageButton.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 0, 0)
        addImageButton.layer.cornerRadius = 32.5
        addImageButton.clipsToBounds = true

        addQuoteButton = UIButton()
        addQuoteButton.translatesAutoresizingMaskIntoConstraints = false
        addQuoteButton.setImage(StyleKit.imageOfQuotesMenuButton(color: UIColor(fromHexString: "#FFA960")), forState: .Normal)
        addQuoteButton.backgroundColor = UIColor(fromHexString: "#FFF2E7")
        addQuoteButton.layer.cornerRadius = 32.5
        addQuoteButton.clipsToBounds = true

        super.init(frame: frame)

        backgroundColor = UIColor.oftWhiteColor()

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(addGifButton)
        addSubview(addImageButton)
        addSubview(addQuoteButton)
        addSubview(gifTitleLabel)
        addSubview(imageTitleLabel)
        addSubview(quoteTitleLabel)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            imageView.al_top == al_top + 92.5,
            imageView.al_left == al_left + 113,
            imageView.al_right == al_right - 113,
            imageView.al_height == 175,

            titleLabel.al_top == imageView.al_bottom,
            titleLabel.al_left == al_left + 71,
            titleLabel.al_right == al_right - 71,

            descriptionLabel.al_top == titleLabel.al_bottom + 9,
            descriptionLabel.al_right == al_right - 62,
            descriptionLabel.al_left == al_left + 62,
            descriptionLabel.al_centerX == al_centerX,

            addGifButton.al_bottom == al_bottom - 59,
            addGifButton.al_left == al_left + 54.5,
            addGifButton.al_height == 65,
            addGifButton.al_width == 65,

            gifTitleLabel.al_top == addGifButton.al_bottom + 4,
            gifTitleLabel.al_centerX == addGifButton.al_centerX,
            gifTitleLabel.al_width == addGifButton.al_width,

            addImageButton.al_centerX == al_centerX,
            addImageButton.al_height == 65,
            addImageButton.al_width == 65,
            addImageButton.al_bottom == al_bottom - 117,

            imageTitleLabel.al_top == addImageButton.al_bottom + 4,
            imageTitleLabel.al_centerX == addImageButton.al_centerX,
            imageTitleLabel.al_width == addImageButton.al_width,

            addQuoteButton.al_bottom == al_bottom - 59,
            addQuoteButton.al_right == al_right - 54.5,
            addQuoteButton.al_height == 65,
            addQuoteButton.al_width == 65,

            quoteTitleLabel.al_top == addQuoteButton.al_bottom + 4,
            quoteTitleLabel.al_centerX == addQuoteButton.al_centerX,
            quoteTitleLabel.al_width == addQuoteButton.al_width,
            ])
    }
}