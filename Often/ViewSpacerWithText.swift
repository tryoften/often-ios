//
//  ViewSpacerWithText.swift
//  Often
//
//  Created by Kervins Valcourt on 1/8/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class ViewSpacerWithText: UIView {
    let orSpacerOne: UIView
    let orSpacerTwo: UIView
    let orLabel: UILabel

     init(title: String) {
        orLabel = UILabel()
        orLabel.textAlignment = .center
        orLabel.font = UIFont(name: "OpenSans-Italic", size: 10)
        orLabel.textColor = UIColor(fromHexString: "#A0A0A0")
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        orLabel.text = title
        orLabel.alpha = 0.90

        orSpacerOne = UIView()
        orSpacerOne.translatesAutoresizingMaskIntoConstraints = false
        orSpacerOne.backgroundColor = UIColor(fromHexString: "#D8D8D8")

        orSpacerTwo = UIView()
        orSpacerTwo.translatesAutoresizingMaskIntoConstraints = false
        orSpacerTwo.backgroundColor = UIColor(fromHexString: "#D8D8D8")

        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear()

        addSubview(orSpacerOne)
        addSubview(orSpacerTwo)
        addSubview(orLabel)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
//        addConstraints([
//            orLabel.al_top == al_top + 5,
//            orLabel.al_width == 70,
//            orLabel.al_centerX == al_centerX,
//            orLabel.al_bottom == al_bottom,
//
//            orSpacerOne.al_centerY == orLabel.al_centerY,
//            orSpacerOne.al_right == orLabel.al_left,
//            orSpacerOne.al_left == al_left,
//            orSpacerOne.al_height == 1,
//
//            orSpacerTwo.al_centerY == orLabel.al_centerY,
//            orSpacerTwo.al_right == al_right,
//            orSpacerTwo.al_left == orLabel.al_right,
//            orSpacerTwo.al_height == 1
//        ])
    }

}
