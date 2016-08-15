//
//  AddSelectedQuotesViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 8/12/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class AddSelectedQuotesViewController: OnboardingMediaItemPickerViewController {
    var loader: AnimatedLoaderView?
    var completionView: KeyboardWalkthroughSuccessMessageView
    var blurEffectView: UIVisualEffectView

    override init(viewModel: OnboardingPackViewModel) {
        completionView = KeyboardWalkthroughSuccessMessageView()
        completionView.translatesAutoresizingMaskIntoConstraints = false
        completionView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.72
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false

        super.init(viewModel: viewModel)
        completionView.finishedButton.addTarget(self, action: #selector(AddSelectedQuotesViewController.completeOnboarding), forControlEvents: .TouchUpInside)

        viewModel.typeFilter = .Quote
        onboardingHeader.titleText = "Maybe some quotes..."
        onboardingHeader.subtitleText = "Need some quick one liners to get you out of convos? Here are some we like"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        onboardingHeader.nextButton.addTarget(self, action: #selector(AddSelectedQuotesViewController.nextButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        onboardingHeader.skipButton.addTarget(self, action: #selector(AddSelectedQuotesViewController.skipButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        onboardingHeader.nextButton.userInteractionEnabled = true
        onboardingHeader.skipButton.userInteractionEnabled = true
    }


    override func nextButtonDidTap(sender: UIButton) {
        if viewModel.selectedMediaItems.count > 0 {
              showLoader()
        }
    }

    override func skipButtonDidTap(sender: UIButton) {
          showLoader()
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

}