//
//  KeyboardMediaItemDetailView.swift
//  Often
//
//  Created by Kervins Valcourt on 3/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Spring

class MediaItemDetailView: UIView {
    var mediaItemText: UILabel
    var mediaItemTitle: UILabel
    var mediaItemImage: UIImageView
    var mediaItemAuthor: UILabel
    var mediaItemCategoryButton: UIButton
    var favoriteButton: SpringButton
    var cancelButton: UIButton
    var insertButton: SpringButton
    var copyButton: SpringButton
    var snapchatButton: SpringButton
    var mediaItemTextSeperator: UIView
    var mediaItemTitleSeperator: UIView
    var firstButtonSeperator: UIView
    var secondButtonSeperator: UIView
    var cancelButtonBackground: UIImageView

    var style: ButtonStyle = .Insert {
        didSet {
            setupButtonStyle()
        }
    }
    
    override init(frame: CGRect) {
        cancelButtonBackground = UIImageView()
        cancelButtonBackground = UIImageView(image: UIImage(named: "collapse-keyboard"))
        cancelButtonBackground.contentMode = .ScaleToFill
        cancelButtonBackground.translatesAutoresizingMaskIntoConstraints = false

        mediaItemText = UILabel()
        mediaItemText.translatesAutoresizingMaskIntoConstraints = false
        mediaItemText.textColor = BlackColor
        mediaItemText.textAlignment = .Center
        mediaItemText.font = UIFont(name: "OpenSans", size: 12.0)
        mediaItemText.numberOfLines = 0

        mediaItemTitle = UILabel()
        mediaItemTitle.translatesAutoresizingMaskIntoConstraints = false
        mediaItemTitle.textColor = BlackColor
        mediaItemTitle.textAlignment = .Left
        mediaItemTitle.font = UIFont(name: "OpenSans", size: 12.0)

        mediaItemAuthor = UILabel()
        mediaItemAuthor.translatesAutoresizingMaskIntoConstraints = false
        mediaItemAuthor.textColor = BlackColor
        mediaItemAuthor.textAlignment = .Left
        mediaItemAuthor.font = UIFont(name: "OpenSans", size: 12.0)
        mediaItemAuthor.alpha = 0.54

        mediaItemImage = UIImageView()
        mediaItemImage.translatesAutoresizingMaskIntoConstraints = false
        mediaItemImage.contentMode = .ScaleAspectFill
        mediaItemImage.layer.cornerRadius = 4
        mediaItemImage.image = UIImage(named: "placeholder")
        mediaItemImage.clipsToBounds = true

        mediaItemCategoryButton = UIButton()
        mediaItemCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        mediaItemCategoryButton.titleLabel!.font = UIFont(name: "OpenSans-Semibold", size: 8)
        mediaItemCategoryButton.setTitleColor(WhiteColor , forState: .Normal)
        mediaItemCategoryButton.setTitle("SUCCESS", forState: .Normal)
        mediaItemCategoryButton.backgroundColor = BlackColor
        mediaItemCategoryButton.layer.cornerRadius = 12
        mediaItemCategoryButton.clipsToBounds = true

        insertButton = SpringButton()
        insertButton.translatesAutoresizingMaskIntoConstraints = false
        insertButton.setImage(StyleKit.imageOfInsertbutton(scale: 0.45), forState: .Normal)
        
        copyButton = SpringButton()
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        copyButton.setImage(StyleKit.imageOfClipboard_button(scale: 0.45), forState: .Normal)
        

        favoriteButton = SpringButton()
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(StyleKit.imageOfFavoritestab(scale: 0.5), forState: .Normal)
        favoriteButton.setImage(StyleKit.imageOfFavoritestab(scale: 0.5, favorited: true), forState: .Selected)

        snapchatButton = SpringButton()
        snapchatButton.translatesAutoresizingMaskIntoConstraints = false
        snapchatButton.setImage(StyleKit.imageOfSnapchat(scale: 0.60), forState: .Normal)
        snapchatButton.setImage(StyleKit.imageOfSnapchat(scale: 0.60, snapchatSelect: true), forState: .Selected)

        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(StyleKit.imageOfLyricsclosebutton(scale: 0.5), forState: .Normal)
        cancelButton.contentEdgeInsets = UIEdgeInsets(top: 7.2, left: 7.2, bottom: 7.2, right: 7.2)
        cancelButton.layer.shadowOffset = CGSizeMake(0, 0)
        cancelButton.layer.shadowOpacity = 0.9
        cancelButton.layer.shadowColor = DarkGrey.CGColor
        cancelButton.layer.shadowRadius = 2

        mediaItemTextSeperator = UIView()
        mediaItemTitleSeperator = UIView()
        firstButtonSeperator = UIView()
        secondButtonSeperator = UIView()

        super.init(frame: frame)

        backgroundColor = WhiteColor

        for seperator in [mediaItemTextSeperator, mediaItemTitleSeperator, firstButtonSeperator, secondButtonSeperator] {
            seperator.translatesAutoresizingMaskIntoConstraints = false
            seperator.backgroundColor = UIColor(fromHexString: "#D8D8D8")
            addSubview(seperator)
        }

        for button in [insertButton, copyButton, favoriteButton, snapchatButton] {
            button.addTarget(self, action: "didTouchUpButton:", forControlEvents: .TouchUpInside)
        }

        addSubview(cancelButtonBackground)
        addSubview(cancelButton)
        addSubview(mediaItemText)
        addSubview(mediaItemTitle)
        addSubview(mediaItemAuthor)
        addSubview(mediaItemImage)
        addSubview(mediaItemCategoryButton)
        addSubview(insertButton)
        addSubview(copyButton)
        addSubview(favoriteButton)
        addSubview(snapchatButton)

        setupLayout()
        setupButtonStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            mediaItemText.al_top == al_top + 27.3,
            mediaItemText.al_left == al_left + 25,
            mediaItemText.al_right == al_right - 25,
            mediaItemText.al_bottom == mediaItemTextSeperator.al_top - 10,

            mediaItemTextSeperator.al_top == al_top + 95,
            mediaItemTextSeperator.al_height == 0.5,
            mediaItemTextSeperator.al_left == al_left,
            mediaItemTextSeperator.al_right == al_right,

            mediaItemImage.al_top == mediaItemTextSeperator.al_bottom + 12,
            mediaItemImage.al_left == al_left + 12,
            mediaItemImage.al_height == 40,
            mediaItemImage.al_width == 40,

            mediaItemTitle.al_top == mediaItemTextSeperator.al_bottom + 17,
            mediaItemTitle.al_left == mediaItemImage.al_right + 12,
            mediaItemTitle.al_right == mediaItemCategoryButton.al_left - 10,
            mediaItemTitle.al_height == 16.5,

            mediaItemAuthor.al_top == mediaItemTitle.al_bottom,
            mediaItemAuthor.al_left == mediaItemImage.al_right + 12,
            mediaItemAuthor.al_right == mediaItemCategoryButton.al_left - 10,
            mediaItemAuthor.al_height == 15,

            mediaItemTitleSeperator.al_top == mediaItemTextSeperator.al_bottom + 64,
            mediaItemTitleSeperator.al_height == 0.5,
            mediaItemTitleSeperator.al_left == al_left,
            mediaItemTitleSeperator.al_right == al_right,

            mediaItemCategoryButton.al_top == mediaItemTextSeperator.al_bottom + 19.5,
            mediaItemCategoryButton.al_right == al_right - 18,
            mediaItemCategoryButton.al_bottom == mediaItemTitleSeperator.al_bottom - 19.5,
            mediaItemCategoryButton.al_width == 72,

            snapchatButton.al_bottom == al_bottom,
            snapchatButton.al_left == al_left,
            snapchatButton.al_top == mediaItemTitleSeperator.al_bottom,
            snapchatButton.al_width == al_width/3 - 1,

            firstButtonSeperator.al_left == snapchatButton.al_right,
            firstButtonSeperator.al_width == 1,
            firstButtonSeperator.al_centerY == snapchatButton.al_centerY,
            firstButtonSeperator.al_height == 25,

            insertButton.al_bottom == al_bottom,
            insertButton.al_left == firstButtonSeperator.al_right,
            insertButton.al_top == mediaItemTitleSeperator.al_bottom,
            insertButton.al_width == al_width/3 - 1,
            
            copyButton.al_bottom == al_bottom,
            copyButton.al_left == firstButtonSeperator.al_right,
            copyButton.al_top == mediaItemTitleSeperator.al_bottom,
            copyButton.al_width == al_width/3 - 1,

            secondButtonSeperator.al_left == insertButton.al_right,
            secondButtonSeperator.al_width == 1,
            secondButtonSeperator.al_centerY == insertButton.al_centerY,
            secondButtonSeperator.al_height == 25,

            favoriteButton.al_bottom == al_bottom,
            favoriteButton.al_left == secondButtonSeperator.al_right,
            favoriteButton.al_top == mediaItemTitleSeperator.al_bottom,
            favoriteButton.al_right == al_right,

            cancelButtonBackground.al_bottom == mediaItemText.al_top - 2,
            cancelButtonBackground.al_centerX == al_centerX,
            cancelButtonBackground.al_height == 45,
            cancelButtonBackground.al_width == 45,

            cancelButton.al_height == cancelButtonBackground.al_height,
            cancelButton.al_width == cancelButtonBackground.al_width,
            cancelButton.al_centerX == cancelButtonBackground.al_centerX,
            cancelButton.al_centerY == cancelButtonBackground.al_centerY
            ])
    }
    
    func setupButtonStyle() {
        switch style {
        case .Copy:
            copyButton.hidden = false
            insertButton.hidden = true
        case .Insert:
            copyButton.hidden = true
            insertButton.hidden = false
        }
    }

    func didTouchUpButton(button: SpringButton?) {
        button?.animation = "pop"
        button?.duration = 0.3
        button?.curve = "easeIn"
        button?.animate()
    }
    
    enum ButtonStyle {
        case Copy
        case Insert
    }
}