//
//  SetUserProfilePictureViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 8/9/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class SetUserProfilePictureViewController: UIViewController,
    PackProfileImageUploaderViewControllerDelegate,
    MediaItemGroupViewModelDelegate {
    private var hudTimer: NSTimer?

    var userProfilePictureView: SetUserProfilePictureView
    var viewModel: OnboardingPackViewModel

    init(viewModel: OnboardingPackViewModel) {
        self.viewModel = viewModel

        userProfilePictureView = SetUserProfilePictureView()
        userProfilePictureView.translatesAutoresizingMaskIntoConstraints = false

        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self

        hudTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(SetUserProfileDescriptionViewController.hideHUD), userInfo: nil, repeats: false)

        do {
            try self.viewModel.setupUser { inner in
                if let favoriteID = viewModel.currentUser?.favoritesPackId {
                    viewModel.packId = favoriteID
                    viewModel.fetchData()
                }

            }
        } catch _ {
        }

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

        showHUD()

        userProfilePictureView.addPhotoButton.addTarget(self, action: #selector(SetUserProfilePictureViewController.addImageLoaderDidTap(_:)), forControlEvents: .TouchUpInside)
        userProfilePictureView.nextButton.addTarget(self, action: #selector(SetUserProfilePictureViewController.nextButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        userProfilePictureView.skipButton.addTarget(self, action: #selector(SetUserProfilePictureViewController.skipButtonDidTap(_:)), forControlEvents: .TouchUpInside)
    }

    func showHUD() {
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()
    }

    func hideHUD() {
        hudTimer?.invalidate()
        PKHUD.sharedHUD.hide(animated: true)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func nextButtonDidTap(sender: UIButton) {
        if userProfilePictureView.imageView.image != nil {
            let vc = AddSelectedGifsViewController(viewModel: OnboardingPackViewModel())
            presentViewController(vc, animated: true, completion: nil)
        }
    }

    func skipButtonDidTap(sender: UIButton) {
        let vc = AddSelectedGifsViewController(viewModel: OnboardingPackViewModel())
        presentViewController(vc, animated: true, completion: nil)
    }

    func addImageLoaderDidTap(sender: UIButton) {
        let vc = PackProfileImageUploaderViewController(viewModel: UserPackService.defaultInstance)
        vc.delegate = self
        presentViewController(vc, animated: true, completion: nil)
    }

    func packProfileImageUploaderViewControllerDidSuccessfullyUpload(imageUploader: PackProfileImageUploaderViewController, image: ImageMediaItem) {
        guard let imageLargeURL = image.largeImageURL, imageSmallURL = image.smallImageURL  else {
            return
        }

        userProfilePictureView.addPhotoButton.hidden = true
        viewModel.saveChanges([
            "image":[
                "large_url": imageLargeURL.absoluteString,
                "small_url": imageSmallURL.absoluteString
            ]
        ])
        
        delay(0.5) {
            self.userProfilePictureView.imageView.nk_setImageWith(imageLargeURL)
            PKHUD.sharedHUD.hide(animated: true)
        }

        let buttonAttributes: [String: AnyObject] = [
            NSKernAttributeName: NSNumber(float: 1.0),
            NSFontAttributeName: UIFont(name: "Montserrat", size: 10.5)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]

        userProfilePictureView.nextButton.selected = true
        userProfilePictureView.nextButton.layer.borderWidth = 0
        userProfilePictureView.nextButton.backgroundColor = TealColor
        userProfilePictureView.nextButton.setAttributedTitle( NSAttributedString(string: "next".uppercaseString, attributes: buttonAttributes), forState: .Normal)
    }

    func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        hideHUD()
    }
}