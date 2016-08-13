//
//  SetUserProfilePictureViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 8/9/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class SetUserProfilePictureViewController: UIViewController, PackProfileImageUploaderViewControllerDelegate {
    var userProfilePictureView: SetUserProfilePictureView
    var viewModel: PacksService

    init(viewModel: PacksService) {
        self.viewModel = viewModel

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
        userProfilePictureView.nextButton.addTarget(self, action: #selector(SetUserProfilePictureViewController.nextButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        userProfilePictureView.skipButton.addTarget(self, action: #selector(SetUserProfilePictureViewController.skipButtonDidTap(_:)), forControlEvents: .TouchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func nextButtonDidTap(sender: UIButton) {
        if userProfilePictureView.imageView.image != nil {
            let vc = SetUserProfileDescriptionViewController(viewModel: viewModel)
            presentViewController(vc, animated: true, completion: nil)
        }
    }

    func skipButtonDidTap(sender: UIButton) {
        let vc = SetUserProfileDescriptionViewController(viewModel: viewModel)
        presentViewController(vc, animated: true, completion: nil)
    }

    func addImageLoaderDidTap(sender: UIButton) {
        let vc = PackProfileImageUploaderViewController(viewModel: UserPackService.defaultInstance)
        vc.delegate = self
        presentViewController(vc, animated: true, completion: nil)
    }

    func packProfileImageUploaderViewControllerDidSuccessfullyUpload(imageUploader: PackProfileImageUploaderViewController, image: ImageMediaItem) {
        guard let imageURL = image.largeImageURL else {
            return
        }
        
        print(imageURL.absoluteString)
        userProfilePictureView.addPhotoButton.hidden = true
        viewModel.updatePackProfileImage(image)
        
        delay(0.5, closure: {
            self.userProfilePictureView.imageView.nk_setImageWith(imageURL)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                PKHUD.sharedHUD.hide(animated: true)
            }
        })

        userProfilePictureView.nextButton.selected = true
        userProfilePictureView.nextButton.layer.borderWidth = 0
        userProfilePictureView.nextButton.backgroundColor = TealColor
    }
}