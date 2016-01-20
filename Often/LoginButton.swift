//
//  LoginButton.swift
//  Often
//
//  Created by Kervins Valcourt on 1/19/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class LoginButton: UIButton {
    var type: AccountManagerType

    init(type: AccountManagerType, title: String) {
        self.type = type

        super.init(frame: CGRectZero)

        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title.uppercaseString, forState: .Normal)
        titleLabel?.font = UIFont(name: "Montserrat", size: 11)
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        layer.cornerRadius = 4.0
        clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func FacebookButton() -> LoginButton {
        let button = LoginButton(type: .Facebook, title: "Facebook")
        button.backgroundColor = FacebookButtonNormalBackgroundColor
        return button
    }

    class func TwitterButton() -> LoginButton {
        let button = LoginButton(type: .Twitter, title: "twitter")
        button.backgroundColor = CreateAccountViewSignupTwitterButtonColor
        return button
    }

    class func AnonymousButton() -> LoginButton {
        let button = LoginButton(type: .Anonymous, title: "skip")
        return button
    }

    class func EmailButton() -> LoginButton {
        let button = LoginButton(type: .Email, title: "sign up")
        button.backgroundColor = UIColor(fromHexString: "#D8D8D8")!
        return button
    }
}
