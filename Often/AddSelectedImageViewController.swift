//
//  AddSelectedImageViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 8/12/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class AddSelectedImageViewController: OnboardingMediaItemPickerViewController {

    override init(viewModel: OnboardingPackViewModel) {
        super.init(viewModel: viewModel)
        viewModel.typeFilter = .Image
        onboardingHeader.titleText = "Maybe some memes..."
        onboardingHeader.subtitleText = "Pick at least 3 images to add! You can also add from your camera roll later"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        onboardingHeader.nextButton.addTarget(self, action: #selector(AddSelectedImageViewController.nextButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        onboardingHeader.skipButton.addTarget(self, action: #selector(AddSelectedImageViewController.skipButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        onboardingHeader.nextButton.userInteractionEnabled = true
        onboardingHeader.skipButton.userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func nextButtonDidTap(sender: UIButton) {
        if viewModel.selectedMediaItems.count > 0 {
            let vc = AddSelectedQuotesViewController(viewModel: OnboardingPackViewModel())
            presentViewController(vc, animated: true, completion: nil)
        }
    }

    override func skipButtonDidTap(sender: UIButton) {
        let vc = AddSelectedQuotesViewController(viewModel: OnboardingPackViewModel())
        presentViewController(vc, animated: true, completion: nil)
    }
    
}