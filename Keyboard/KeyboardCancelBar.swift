//
//  KeyboardCancelBar.swift
//  Often
//
//  Created by Kervins Valcourt on 4/21/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class KeyboardCancelBar: UIView {
    var cancelButton: UIButton

    override init(frame: CGRect) {
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(StyleKit.imageOfCancelbutton(), for: UIControlState())


        super.init(frame: frame)
        backgroundColor = WhiteColor
        layer.shadowOffset = CGSize(width: 0.5, height: 0)
        layer.shadowRadius = 0.5
        layer.shadowColor = UIColor.black().cgColor
        layer.shadowOpacity = 0.10

        addSubview(cancelButton)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            cancelButton.al_centerX == al_centerX,
            cancelButton.al_centerY == al_centerY,
            cancelButton.al_width == 35,
            cancelButton.al_height == cancelButton.al_width
            ])
    }
}
