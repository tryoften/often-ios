//
//  SetUserProfileBackgroundColorViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 8/11/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class SetUserProfileBackgroundColorViewController: UIViewController {
    var userProfileBackgroundColorView: SetUserProfileBackgroundColorView

    init(viewModel: UsernameViewModel) {
        userProfileBackgroundColorView = SetUserProfileBackgroundColorView()
        userProfileBackgroundColorView.translatesAutoresizingMaskIntoConstraints = false

        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = UIColor.oftWhiteColor()
        view.addSubview(userProfileBackgroundColorView)

        setupLayout()
    }

    func setupLayout()  {
        view.addConstraints([
            userProfileBackgroundColorView.al_top == view.al_top,
            userProfileBackgroundColorView.al_bottom == view.al_bottom,
            userProfileBackgroundColorView.al_left == view.al_left,
            userProfileBackgroundColorView.al_right == view.al_right
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}