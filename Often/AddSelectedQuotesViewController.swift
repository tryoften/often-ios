//
//  AddSelectedQuotesViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 8/12/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class AddSelectedQuotesViewController: OnboardingMediaItemPickerViewController {

    override init(viewModel: OnboardingPackViewModel) {
        super.init(viewModel: viewModel)
        viewModel.typeFilter = .Quote

        onboardingHeader.titleText = "Maybe some quotes..."
        onboardingHeader.subtitleText = "Need some quick one liners to get you out of convos? Here are some we like"
        progressBar = OnboardingProgressBar(progressIndex: 6.0, endIndex: 8.0, frame: CGRectZero)
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
            if let userId = SessionManagerFlags.defaultManagerFlags.userId {
                let vc = SetUserProfileDescriptionViewController(viewModel: OnboardingPackViewModel(userId: userId, packId: ""))
                presentViewController(vc, animated: true, completion: nil)
            }
        }
    }

    override func skipButtonDidTap(sender: UIButton) {
        if let userId = SessionManagerFlags.defaultManagerFlags.userId {
            let vc = SetUserProfileDescriptionViewController(viewModel: OnboardingPackViewModel(userId: userId, packId: ""))
            presentViewController(vc, animated: true, completion: nil)
        }
    }
}