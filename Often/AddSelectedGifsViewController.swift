//
//  AddSelectedGifsViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 8/12/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class AddSelectedGifsViewController: OnboardingMediaItemPickerViewController {

    override init(viewModel: OnboardingPackViewModel) {
        super.init(viewModel: viewModel)
        onboardingHeader.titleText = "Let’s add stuff to your keyboard"
        onboardingHeader.subtitleText = "Pick at least 3 GIFs to add! You can add any you missed from GIPHY later too"
        progressBar = OnboardingProgressBar(progressIndex: 4.0, endIndex: 8.0, frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingHeader.nextButton.addTarget(self, action: #selector(AddSelectedGifsViewController.nextButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        onboardingHeader.skipButton.addTarget(self, action: #selector(AddSelectedGifsViewController.skipButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        onboardingHeader.nextButton.userInteractionEnabled = true
        onboardingHeader.skipButton.userInteractionEnabled = true
    }
    
    override func nextButtonDidTap(sender: UIButton) {
        if viewModel.selectedMediaItems.count > 0 {
            let vc = AddSelectedImageViewController(viewModel: OnboardingPackViewModel())
            presentViewController(vc, animated: true, completion: nil)
        }
    }

    override func skipButtonDidTap(sender: UIButton) {
        let vc = AddSelectedImageViewController(viewModel: OnboardingPackViewModel())
        presentViewController(vc, animated: true, completion: nil)
    }

}