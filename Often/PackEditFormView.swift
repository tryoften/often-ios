//
//  PackEditFormView.swift
//  Often
//
//  Created by Luc Succes on 8/12/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class PackEditFormView: UIScrollView {
    let packBackgroundColor: UIView
    let coverPhotoContainer: UIView
    let coverPhoto: UIImageView

    let titleLabel: UILabel
    let descriptionLabel: UILabel

    let titleField: UITextField
    let titleFieldDivider: UIView

    let descriptionField: UITextField
    let descriptionFieldDivider: UIView

    init() {
        packBackgroundColor = UIView()
        packBackgroundColor.translatesAutoresizingMaskIntoConstraints = false
        packBackgroundColor.backgroundColor = BlackColor

        let layer = CAShapeLayer()
        layer.path = MediaItemPageHeaderView.drawPackBackgroundMask().CGPath
        layer.fillColor = UIColor.whiteColor().CGColor
        layer.backgroundColor = UIColor.clearColor().CGColor
        packBackgroundColor.layer.mask = layer

        coverPhotoContainer = UIView()
        coverPhotoContainer.translatesAutoresizingMaskIntoConstraints = false
        coverPhotoContainer.layer.shadowRadius = 2
        coverPhotoContainer.layer.shadowOpacity = 0.4
        coverPhotoContainer.layer.shadowColor = MediumLightGrey.CGColor
        coverPhotoContainer.layer.shadowOffset = CGSizeMake(0, 1)

        coverPhoto = UIImageView()
        coverPhoto.backgroundColor = VeryLightGray
        coverPhoto.translatesAutoresizingMaskIntoConstraints = false
        coverPhoto.contentMode = .ScaleAspectFill
        coverPhoto.layer.cornerRadius = 4.0
        coverPhoto.layer.shadowRadius = 2
        coverPhoto.layer.shadowOpacity = 0.2
        coverPhoto.layer.shadowColor = MediumLightGrey.CGColor
        coverPhoto.layer.shadowOffset = CGSizeMake(0, 1)
        coverPhoto.clipsToBounds = true

        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setTextWith(UIFont(name: "OpenSans-Semibold", size: 9),
                               letterSpacing: 1.0,
                               color: UIColor.oftBlack54Color(),
                               text: "Title".uppercaseString)

        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.setTextWith(UIFont(name: "OpenSans-Semibold", size: 9),
                                     letterSpacing: 1.0,
                                     color: UIColor.oftBlack54Color(),
                                     text: "Description".uppercaseString)

        titleField = UITextField()
        titleField.placeholder = "Enter pack title"
        titleField.translatesAutoresizingMaskIntoConstraints = false
        titleField.font = UIFont(name: "Montserrat-Regular", size: 11)

        titleFieldDivider = UIView()
        titleFieldDivider.translatesAutoresizingMaskIntoConstraints = false
        titleFieldDivider.backgroundColor = UIColor(fromHexString: "#D8D8D8")

        descriptionField = UITextField()
        descriptionField.placeholder = "Enter description"
        descriptionField.translatesAutoresizingMaskIntoConstraints = false
        descriptionField.font = UIFont(name: "Montserrat-Regular", size: 11)

        descriptionFieldDivider = UIView()
        descriptionFieldDivider.translatesAutoresizingMaskIntoConstraints = false
        descriptionFieldDivider.backgroundColor = UIColor(fromHexString: "#D8D8D8")

        super.init(frame: CGRectZero)

        coverPhotoContainer.addSubview(coverPhoto)

        addSubview(packBackgroundColor)
        addSubview(coverPhotoContainer)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(titleField)
        addSubview(titleFieldDivider)
        addSubview(descriptionField)
        addSubview(descriptionFieldDivider)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            packBackgroundColor.al_top == al_top,
            packBackgroundColor.al_left == al_left,
            packBackgroundColor.al_width == al_width,
            packBackgroundColor.al_height == al_height,

            coverPhotoContainer.al_centerX == al_centerX,
            coverPhotoContainer.al_top == al_top + 93,
            coverPhotoContainer.al_width == 175,
            coverPhotoContainer.al_height == 175,

            coverPhoto.al_top == coverPhotoContainer.al_top,
            coverPhoto.al_left == coverPhotoContainer.al_left,
            coverPhoto.al_right == coverPhotoContainer.al_right,
            coverPhoto.al_bottom == coverPhotoContainer.al_bottom,

            titleLabel.al_top == coverPhotoContainer.al_bottom + 40,
            titleLabel.al_width == al_width - 40,
            titleLabel.al_left == al_left + 20,
            titleLabel.al_right == al_right - 20,

            titleField.al_top == titleLabel.al_bottom,
            titleField.al_left == titleLabel.al_left,
            titleField.al_right == titleLabel.al_right,
            titleField.al_width == titleLabel.al_width,
            titleField.al_height == 30,

            titleFieldDivider.al_top == titleField.al_bottom,
            titleFieldDivider.al_left == titleField.al_left,
            titleFieldDivider.al_right == titleField.al_right,
            titleFieldDivider.al_height == 1,

            descriptionLabel.al_top == titleFieldDivider.al_top + 20,
            descriptionLabel.al_left == titleLabel.al_left,
            descriptionLabel.al_right == titleLabel.al_right,

            descriptionField.al_top == descriptionLabel.al_bottom,
            descriptionField.al_left == descriptionLabel.al_left,
            descriptionField.al_right == descriptionLabel.al_right,
            descriptionField.al_height == titleField.al_height,

            descriptionFieldDivider.al_top == descriptionField.al_bottom,
            descriptionFieldDivider.al_left == descriptionField.al_left,
            descriptionFieldDivider.al_right == descriptionField.al_right,
            descriptionFieldDivider.al_height == 1
        ])
    }
}
