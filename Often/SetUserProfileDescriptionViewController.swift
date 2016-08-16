//
//  SetUserProfileDescriptionViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 8/11/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class SetUserProfileDescriptionViewController: PresentingRootViewController,
    UITextFieldDelegate,
    MediaItemGroupViewModelDelegate {
    private var userProfileDescription: SetUserProfileDescriptionView
    private var onboardingHeader: OnboardingHeader
    private var viewModel: OnboardingPackViewModel
    private var loader: AnimatedLoaderView?
    private var completionView: KeyboardWalkthroughSuccessMessageView
    private var hudTimer: NSTimer?
    private var blurEffectView: UIVisualEffectView

    init(viewModel: OnboardingPackViewModel) {
        self.viewModel = viewModel

        completionView = KeyboardWalkthroughSuccessMessageView()
        completionView.translatesAutoresizingMaskIntoConstraints = false
        completionView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.72
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
    
        userProfileDescription = SetUserProfileDescriptionView()
        userProfileDescription.translatesAutoresizingMaskIntoConstraints = false
        
        onboardingHeader = OnboardingHeader()
        onboardingHeader.translatesAutoresizingMaskIntoConstraints = false
        onboardingHeader.titleText = "Add a title & description"
        onboardingHeader.subtitleText = "Tell your friends why they should follow you and what you’ll be sharing!"

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

        userProfileDescription.titleTextField.delegate = self

        completionView.finishedButton.addTarget(self, action: #selector(SetUserProfileDescriptionViewController.completeOnboarding), forControlEvents: .TouchUpInside)

        onboardingHeader.nextButton.addTarget(self, action: #selector(SetUserProfileDescriptionViewController.didTapNextButton(_:)), forControlEvents: .TouchUpInside)
        onboardingHeader.skipButton.addTarget(self, action: #selector(SetUserProfileDescriptionViewController.didTapSkipButton(_:)), forControlEvents: .TouchUpInside)

        view.backgroundColor = UIColor.oftWhiteColor()

        view.addSubview(onboardingHeader)
        view.addSubview(userProfileDescription)

        setupLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        showHUD()
    }

    func showHUD() {
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()
    }

    func hideHUD() {
        hudTimer?.invalidate()
        PKHUD.sharedHUD.hide(animated: true)
    }

    func setupLayout()  {
        view.addConstraints([
            onboardingHeader.al_top == view.al_top,
            onboardingHeader.al_left == view.al_left,
            onboardingHeader.al_right == view.al_right,
            onboardingHeader.al_height == 213,
            
            userProfileDescription.al_top == onboardingHeader.al_bottom + 40,
            userProfileDescription.al_bottom == view.al_bottom,
            userProfileDescription.al_left == view.al_left,
            userProfileDescription.al_right == view.al_right
            ])
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        
        if textField.hasText() {
            onboardingHeader.nextButton.enabled = true
        } else {
            onboardingHeader.nextButton.enabled = false
        }
        
        return true
    }
    
    func didTapNextButton(sender: UIButton) {
        guard let titleText = userProfileDescription.titleTextField.text else {
            return
        }
        
        var descriptionText = ""
        if let text = userProfileDescription.descriptionTextField.text {
            descriptionText = text
        }
        
        viewModel.saveChanges([
            "name": titleText,
            "description": descriptionText,
            ])

        showLoader()
    }
    
    func didTapSkipButton(sender: UIButton) {
        showLoader()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showLoader() {
        loader = AnimatedLoaderView()

        guard let loader = loader else {
            return
        }

        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)

        view.addSubview(blurEffectView)
        view.addSubview(loader)

        view.addConstraints([
            loader.al_top == view.al_top,
            loader.al_bottom == view.al_bottom,
            loader.al_left == view.al_left,
            loader.al_right == view.al_right,

            blurEffectView.al_top == view.al_top,
            blurEffectView.al_bottom == view.al_bottom,
            blurEffectView.al_left == view.al_left,
            blurEffectView.al_right == view.al_right
            ])

        delay(0.5) {
            self.removeLoader()
        }
    }

    func removeLoader() {
        delay(2.0) {
            self.loader?.removeFromSuperview()
            self.showCompleteMessage()
        }
    }

    func showCompleteMessage() {
        view.addSubview(completionView)
        view.addConstraints([
            completionView.al_top == view.al_top,
            completionView.al_bottom == view.al_bottom,
            completionView.al_left == view.al_left,
            completionView.al_right == view.al_right,
            ])
    }

    func completeOnboarding() {
        presentRootViewController(RootViewController())
    }

    func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        hideHUD()

        userProfileDescription.descriptionTextField.text = self.viewModel.pack?.description
        userProfileDescription.titleTextField.text = self.viewModel.pack?.name
    }
}