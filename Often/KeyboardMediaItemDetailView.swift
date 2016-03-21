//
//  KeyboardMediaItemDetailView.swift
//  Often
//
//  Created by Kervins Valcourt on 3/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class KeyboardMediaItemDetailView: UIView {
    var mediaItemText: UILabel
    var mediaItemTitle: UILabel
    var mediaItemImage: UIImageView
    var mediaItemAuthor: UILabel
    var mediaItemCategoryButton: UIButton
    var favoriteButton: UIButton
    var cancelButton: UIButton
    var insertButton: UIButton
    var mediaItemTextSeperator: UIView
    var mediaItemTitleSeperator: UIView
    var firstButtonSeperator: UIView
    var secondButtonSeperator: UIView

    override init(frame: CGRect) {
        mediaItemText = UILabel()
        mediaItemText.translatesAutoresizingMaskIntoConstraints = false
        mediaItemText.textColor = BlackColor
        mediaItemText.textAlignment = .Center
        mediaItemText.font = UIFont(name: "OpenSans", size: 12.0)
        mediaItemText.numberOfLines = 0
        mediaItemText.text = "My bathtub the size of swimming pools, backstroke to my children room"

        mediaItemTitle = UILabel()
        mediaItemTitle.translatesAutoresizingMaskIntoConstraints = false
        mediaItemTitle.textColor = BlackColor
        mediaItemTitle.textAlignment = .Left
        mediaItemTitle.font = UIFont(name: "OpenSans", size: 12.0)
        mediaItemTitle.text = "3500"

        mediaItemAuthor = UILabel()
        mediaItemAuthor.translatesAutoresizingMaskIntoConstraints = false
        mediaItemAuthor.textColor = BlackColor
        mediaItemAuthor.textAlignment = .Left
        mediaItemAuthor.font = UIFont(name: "OpenSans", size: 12.0)
        mediaItemAuthor.alpha = 0.54
        mediaItemAuthor.text = "Travis Scott ft 2 Chainz & Future"

        mediaItemImage = UIImageView()
        mediaItemImage.translatesAutoresizingMaskIntoConstraints = false
        mediaItemImage.contentMode = .ScaleAspectFill
        mediaItemImage.layer.cornerRadius = 4
        mediaItemImage.image = UIImage(named: "future")
        mediaItemImage.clipsToBounds = true

        mediaItemCategoryButton = UIButton()
        mediaItemCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        mediaItemCategoryButton.titleLabel!.font = UIFont(name: "OpenSans-Semibold", size: 8)
        mediaItemCategoryButton.setTitleColor(WhiteColor , forState: .Normal)
        mediaItemCategoryButton.setTitle("SUCCESS", forState: .Normal)
        mediaItemCategoryButton.backgroundColor = BlackColor
        mediaItemCategoryButton.layer.cornerRadius = 12
        mediaItemCategoryButton.clipsToBounds = true

        insertButton = UIButton()
        insertButton.translatesAutoresizingMaskIntoConstraints = false
        insertButton.setImage(StyleKit.imageOfInsertbutton(scale: 0.45), forState: .Normal)

        favoriteButton = UIButton()
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(StyleKit.imageOfFavoritestab(scale: 0.5), forState: .Normal)

        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(StyleKit.imageOfCancelbutton(scale: 0.5), forState: .Normal)

        mediaItemTextSeperator = UIView()
        mediaItemTitleSeperator = UIView()
        firstButtonSeperator = UIView()
        secondButtonSeperator = UIView()

        let spacerArray =   [mediaItemTextSeperator, mediaItemTitleSeperator, firstButtonSeperator, secondButtonSeperator]

        for view in spacerArray as [UIView] {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor(fromHexString: "#D8D8D8")

        }

        super.init(frame: frame)

        backgroundColor = WhiteColor

        addSubview(mediaItemText)
        addSubview(mediaItemTitle)
        addSubview(mediaItemAuthor)
        addSubview(mediaItemImage)
        addSubview(mediaItemCategoryButton)
        addSubview(insertButton)
        addSubview(cancelButton)
        addSubview(favoriteButton)
        addSubview(mediaItemTextSeperator)
        addSubview(mediaItemTitleSeperator)
        addSubview(firstButtonSeperator)
        addSubview(secondButtonSeperator)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            mediaItemText.al_top == al_top + 19.3,
            mediaItemText.al_left == al_left + 56.6,
            mediaItemText.al_right == al_right - 57.8,
            mediaItemText.al_bottom == mediaItemTextSeperator.al_top - 19.7,

            mediaItemTextSeperator.al_top == al_top + 75,
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

            favoriteButton.al_bottom == al_bottom,
            favoriteButton.al_left == al_left,
            favoriteButton.al_top == mediaItemTitleSeperator.al_bottom,
            favoriteButton.al_width == al_width/3 - 1,

            firstButtonSeperator.al_left == favoriteButton.al_right,
            firstButtonSeperator.al_width == 1,
            firstButtonSeperator.al_centerY == favoriteButton.al_centerY,
            firstButtonSeperator.al_height == 25,

            cancelButton.al_bottom == al_bottom,
            cancelButton.al_left == firstButtonSeperator.al_right,
            cancelButton.al_top == mediaItemTitleSeperator.al_bottom,
            cancelButton.al_width == al_width/3 - 1,

            secondButtonSeperator.al_left == cancelButton.al_right,
            secondButtonSeperator.al_width == 1,
            secondButtonSeperator.al_centerY == cancelButton.al_centerY,
            secondButtonSeperator.al_height == 25,

            insertButton.al_bottom == al_bottom,
            insertButton.al_left == secondButtonSeperator.al_right,
            insertButton.al_top == mediaItemTitleSeperator.al_bottom,
            insertButton.al_right == al_right
            ])
    }
}