//
//  SetUserProfileDescriptionViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 8/11/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class SetUserProfileDescriptionViewController: UIViewController {
    var userProfileDescription: SetUserProfileDescriptionView

    init(viewModel: UsernameViewModel) {
        userProfileDescription = SetUserProfileDescriptionView()
        userProfileDescription.translatesAutoresizingMaskIntoConstraints = false

        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = UIColor.oftWhiteColor()

        view.addSubview(userProfileDescription)

        setupLayout()
    }

    func setupLayout()  {
        view.addConstraints([
            userProfileDescription.al_top == view.al_top,
            userProfileDescription.al_bottom == view.al_bottom,
            userProfileDescription.al_left == view.al_left,
            userProfileDescription.al_right == view.al_right
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}