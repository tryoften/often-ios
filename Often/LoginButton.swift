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

        super.init(frame: CGRect.zero)

        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title.uppercased(), for: UIControlState())
        titleLabel?.font = UIFont(name: "Montserrat", size: 11)
        setTitleColor(UIColor.white(), for: UIControlState())
        layer.cornerRadius = 4.0
        clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func FacebookButton() -> LoginButton {
        let button = LoginButton(type: .facebook, title: "Facebook")
        button.backgroundColor = FacebookButtonNormalBackgroundColor
        return button
    }

    class func TwitterButton() -> LoginButton {
        let button = LoginButton(type: .twitter, title: "twitter")
        button.backgroundColor = CreateAccountViewSignupTwitterButtonColor
        return button
    }

    class func AnonymousButton() -> LoginButton {
        let button = LoginButton(type: .anonymous, title: "skip")
        return button
    }

    class func EmailButton() -> LoginButton {
        let button = LoginButton(type: .email, title: "sign up")
        button.backgroundColor = UIColor(fromHexString: "#D8D8D8")!
        return button
    }
}
