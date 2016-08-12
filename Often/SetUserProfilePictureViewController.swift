//
//  SetUserProfilePictureViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 8/9/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class SetUserProfilePictureViewController: UIViewController {
    var userProfilePictureView: SetUserProfilePictureView

    init(viewModel: UsernameViewModel) {
        userProfilePictureView = SetUserProfilePictureView()
        userProfilePictureView.translatesAutoresizingMaskIntoConstraints = false

        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = UIColor.oftWhiteColor()

        view.addSubview(userProfilePictureView)

        setupLayout()
    }

    func setupLayout()  {
        view.addConstraints([
            userProfilePictureView.al_top == view.al_top,
            userProfilePictureView.al_bottom == view.al_bottom,
            userProfilePictureView.al_left == view.al_left,
            userProfilePictureView.al_right == view.al_right
            ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        userProfilePictureView.addPhotoButton.addTarget(self, action: #selector(SetUserProfilePictureViewController.addImageLoaderDidTap(_:)), forControlEvents: .TouchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addImageLoaderDidTap(sender: UIButton) {
        let vc = ImageUploaderViewController(viewModel: UserPackService.defaultInstance)
         presentViewController(vc, animated: true, completion: nil)
    }
}