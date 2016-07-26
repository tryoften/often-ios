//
//  PowerByGiphyView.swift
//  Often
//
//  Created by Kervins Valcourt on 7/21/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation


class PowerByGiphyView: UIButton {
    var giphyTitle: UILabel
    var giphyImage: UIImageView

    override init(frame: CGRect) {
        giphyTitle = UILabel()
        giphyTitle.translatesAutoresizingMaskIntoConstraints = false
        giphyTitle.setTextWith(UIFont(name: "OpenSans-Semibold", size: 9)!, letterSpacing: 1.0, color: BlackColor, text: "POWERED BY".uppercaseString)

        giphyImage = UIImageView()
        giphyImage.translatesAutoresizingMaskIntoConstraints = false
        giphyImage.image = UIImage(named: "giphyLogo")
        giphyImage.contentMode = .ScaleAspectFit

        super.init(frame: frame)

        backgroundColor = WhiteColor

        layer.cornerRadius = 15
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.2
        layer.shadowColor = MediumLightGrey.CGColor
        layer.shadowOffset = CGSizeMake(0, 2)

        addSubview(giphyTitle)
        addSubview(giphyImage)

        setupLayout()
    }

    func setupLayout() {
        addConstraints([
            giphyTitle.al_top == al_top,
            giphyTitle.al_left == al_left + 14.5,
            giphyTitle.al_bottom == al_bottom,
            giphyTitle.al_right == al_centerX + 10,

            giphyImage.al_top == al_top + 2,
            giphyImage.al_left == al_centerX + 2,
            giphyImage.al_bottom == al_bottom - 2,
            giphyImage.al_width == 59
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}