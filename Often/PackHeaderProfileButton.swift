//
//  PackHeaderProfileButton.swift
//  Often
//
//  Created by Luc Succes on 8/8/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class PackHeaderProfileButton: UIButton {
    var profileImageView: UIImageView

    var text: String? {
        didSet {
            titleLabel?.setTextWith(UIFont(name: "Montserrat", size: 10.5)!, letterSpacing: 1.0, color: WhiteColor, text: text!.uppercaseString)

            setTitle(text!.uppercaseString, forState: .Normal)
        }
    }

    private var profileImageViewWidth: CGFloat {
        return 30
    }

    override init(frame: CGRect) {
        profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .ScaleAspectFit
        profileImageView.image = UIImage(named: "userprofileplaceholder")
        profileImageView.layer.borderColor = UserProfileHeaderViewProfileImageViewBackgroundColor
        profileImageView.layer.borderWidth = 2
        profileImageView.alpha = 0
        profileImageView.clipsToBounds = true

        super.init(frame: frame)

        addSubview(profileImageView)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            profileImageView.al_top >= al_top + 5,
            profileImageView.al_left == al_left + 5,
            profileImageView.al_height == profileImageViewWidth,
            profileImageView.al_width == profileImageViewWidth
        ])

        guard let titleLabel = titleLabel else {
            return
        }

        addConstraint(titleLabel.al_left == profileImageView.al_right + 5)
    }
}
