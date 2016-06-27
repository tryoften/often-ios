//
//  MediaItemDetailView.swift
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
    var cancelButton: UIButton
    var insertButton: SpringButton
    var copyButton: SpringButton
    var mediaItemTextSeperator: UIView
    var mediaItemTitleSeperator: UIView
    var firstButtonSeperator: UIView
    var cancelButtonBackground: UIImageView

    var style: ButtonStyle = .insert {
        didSet {
            setupButtonStyle()
        }
    }
    
    override init(frame: CGRect) {
        cancelButtonBackground = UIImageView()
        cancelButtonBackground = UIImageView(image: UIImage(named: "collapse-keyboard"))
        cancelButtonBackground.contentMode = .scaleToFill
        cancelButtonBackground.translatesAutoresizingMaskIntoConstraints = false

        mediaItemText = UILabel()
        mediaItemText.translatesAutoresizingMaskIntoConstraints = false
        mediaItemText.textColor = BlackColor
        mediaItemText.textAlignment = .center
        mediaItemText.font = UIFont(name: "OpenSans", size: 12.0)
        mediaItemText.numberOfLines = 0

        mediaItemTitle = UILabel()
        mediaItemTitle.translatesAutoresizingMaskIntoConstraints = false
        mediaItemTitle.textColor = BlackColor
        mediaItemTitle.textAlignment = .left
        mediaItemTitle.font = UIFont(name: "OpenSans", size: 12.0)

        mediaItemAuthor = UILabel()
        mediaItemAuthor.translatesAutoresizingMaskIntoConstraints = false
        mediaItemAuthor.textColor = BlackColor
        mediaItemAuthor.textAlignment = .left
        mediaItemAuthor.font = UIFont(name: "OpenSans", size: 12.0)
        mediaItemAuthor.alpha = 0.54

        mediaItemImage = UIImageView()
        mediaItemImage.translatesAutoresizingMaskIntoConstraints = false
        mediaItemImage.contentMode = .scaleAspectFill
        mediaItemImage.layer.cornerRadius = 4
        mediaItemImage.image = UIImage(named: "placeholder")
        mediaItemImage.clipsToBounds = true

        mediaItemCategoryButton = UIButton()
        mediaItemCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        mediaItemCategoryButton.titleLabel!.font = UIFont(name: "OpenSans-Semibold", size: 8)
        mediaItemCategoryButton.setTitleColor(WhiteColor , for: UIControlState())
        mediaItemCategoryButton.setTitle("SUCCESS", for: UIControlState())
        mediaItemCategoryButton.backgroundColor = BlackColor
        mediaItemCategoryButton.layer.cornerRadius = 12
        mediaItemCategoryButton.clipsToBounds = true

        let insertNormalText = AttributedString(string: "remove".uppercased(), attributes: [
            NSKernAttributeName: NSNumber(value: 1.0),
            NSFontAttributeName: UIFont(name: "Montserrat", size: 10.5)!,
            NSForegroundColorAttributeName: BlackColor!
            ])

        let insertSelectedText = AttributedString(string: "share".uppercased(), attributes: [
            NSKernAttributeName: NSNumber(value: 1.0),
            NSFontAttributeName: UIFont(name: "Montserrat", size: 10.5)!,
            NSForegroundColorAttributeName: BlackColor!
            ])
        let copyText = AttributedString(string: "Share".uppercased(), attributes: [
            NSKernAttributeName: NSNumber(value: 1.0),
            NSFontAttributeName: UIFont(name: "Montserrat", size: 10.5)!,
            NSForegroundColorAttributeName: BlackColor!
            ])

        insertButton = SpringButton()
        insertButton.backgroundColor = VeryLightGray
        insertButton.translatesAutoresizingMaskIntoConstraints = false
        insertButton.setAttributedTitle(insertNormalText, for: UIControlState())
        insertButton.setAttributedTitle(insertSelectedText, for: .selected)

        copyButton = SpringButton()
        copyButton.backgroundColor = VeryLightGray
        copyButton.translatesAutoresizingMaskIntoConstraints = false


        copyButton.setAttributedTitle(copyText, for: UIControlState())


        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(StyleKit.imageOfLyricsclosebutton(scale: 0.5), for: UIControlState())
        cancelButton.contentEdgeInsets = UIEdgeInsets(top: 7.2, left: 7.2, bottom: 7.2, right: 7.2)
        cancelButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        cancelButton.layer.shadowOpacity = 0.9
        cancelButton.layer.shadowColor = DarkGrey?.cgColor
        cancelButton.layer.shadowRadius = 2

        mediaItemTextSeperator = UIView()
        mediaItemTitleSeperator = UIView()
        firstButtonSeperator = UIView()

        super.init(frame: frame)

        backgroundColor = WhiteColor

        for seperator in [mediaItemTextSeperator, mediaItemTitleSeperator, firstButtonSeperator] {
            seperator.translatesAutoresizingMaskIntoConstraints = false
            seperator.backgroundColor = UIColor(fromHexString: "#D8D8D8")
            addSubview(seperator)
        }

        for button in [insertButton, copyButton] {
            button.addTarget(self, action: #selector(MediaItemDetailView.didTouchUpButton(_:)), for: .touchUpInside)
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

        setupLayout()
        setupButtonStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        var constraints = [
            mediaItemText.al_top == al_top + 27.3,
            mediaItemText.al_left == al_left + 25,
            mediaItemText.al_right == al_right - 25,
            mediaItemText.al_bottom == mediaItemTextSeperator.al_top - 10
        ]

        constraints += [
            mediaItemTextSeperator.al_top == al_top + 95,
            mediaItemTextSeperator.al_height == 0.5,
            mediaItemTextSeperator.al_left == al_left,
            mediaItemTextSeperator.al_right == al_right
        ]

        constraints += [
            mediaItemImage.al_top == mediaItemTextSeperator.al_bottom + 12,
            mediaItemImage.al_left == al_left + 12,
            mediaItemImage.al_height == 40,
            mediaItemImage.al_width == 40
        ]

        constraints += [
            mediaItemTitle.al_top == mediaItemTextSeperator.al_bottom + 17,
            mediaItemTitle.al_left == mediaItemImage.al_right + 12,
            mediaItemTitle.al_right == mediaItemCategoryButton.al_left - 10,
            mediaItemTitle.al_height == 16.5
        ]

        constraints += [
            mediaItemAuthor.al_top == mediaItemTitle.al_bottom,
            mediaItemAuthor.al_left == mediaItemImage.al_right + 12,
            mediaItemAuthor.al_right == mediaItemCategoryButton.al_left - 10,
            mediaItemAuthor.al_height == 15
        ]

        constraints += [
            mediaItemTitleSeperator.al_top == mediaItemTextSeperator.al_bottom + 64,
            mediaItemTitleSeperator.al_height == 0.5,
            mediaItemTitleSeperator.al_left == al_left,
            mediaItemTitleSeperator.al_right == al_right
        ]

        constraints += [
            mediaItemCategoryButton.al_top == mediaItemTextSeperator.al_bottom + 19.5,
            mediaItemCategoryButton.al_right == al_right - 18,
            mediaItemCategoryButton.al_bottom == mediaItemTitleSeperator.al_bottom - 19.5,
            mediaItemCategoryButton.al_width == 72
        ]

        constraints += [
            insertButton.al_bottom == al_bottom,
            insertButton.al_left == al_left,
            insertButton.al_top == mediaItemTitleSeperator.al_bottom,
            insertButton.al_width == al_width
        ]

        constraints += [
            firstButtonSeperator.al_left == insertButton.al_right,
            firstButtonSeperator.al_width == 1,
            firstButtonSeperator.al_centerY == insertButton.al_centerY,
            firstButtonSeperator.al_height == 25
        ]

        constraints += [
            copyButton.al_bottom == insertButton.al_bottom,
            copyButton.al_left == insertButton.al_left,
            copyButton.al_top == insertButton.al_top,
            copyButton.al_width == insertButton.al_width
        ]

        constraints += [
            cancelButtonBackground.al_bottom == mediaItemText.al_top - 2,
            cancelButtonBackground.al_centerX == al_centerX,
            cancelButtonBackground.al_height == 45,
            cancelButtonBackground.al_width == 45
        ]

        constraints += [
            cancelButton.al_height == cancelButtonBackground.al_height,
            cancelButton.al_width == cancelButtonBackground.al_width,
            cancelButton.al_centerX == cancelButtonBackground.al_centerX,
            cancelButton.al_centerY == cancelButtonBackground.al_centerY
        ]

        addConstraints(constraints)
    }
    
    func setupButtonStyle() {
        switch style {
        case .copy:
            copyButton.isHidden = false
            insertButton.isHidden = true
        case .insert:
            copyButton.isHidden = true
            insertButton.isHidden = false
        }
    }

    func didTouchUpButton(_ button: SpringButton?) {
        button?.animation = "pop"
        button?.duration = 0.3
        button?.curve = "easeIn"
        button?.animate()
    }
    
    enum ButtonStyle {
        case copy
        case insert
    }
}
