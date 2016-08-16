//
//  SetUserProfileDescriptionViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 8/11/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class SetUserProfileDescriptionViewController: UIViewController, UITextFieldDelegate {
    var userProfileDescription: SetUserProfileDescriptionView
    var onboardingHeader: OnboardingHeader
    var viewModel: OnboardingPackViewModel

    init(viewModel: OnboardingPackViewModel) {
        self.viewModel = viewModel
    
        userProfileDescription = SetUserProfileDescriptionView()
        userProfileDescription.translatesAutoresizingMaskIntoConstraints = false
        
        onboardingHeader = OnboardingHeader()
        onboardingHeader.translatesAutoresizingMaskIntoConstraints = false
        onboardingHeader.titleText = "Add a title & description"
        onboardingHeader.subtitleText = "Tell your friends why they should follow you and what you’ll be sharing!"
        onboardingHeader.nextButton.enabled = false

        super.init(nibName: nil, bundle: nil)
        
        userProfileDescription.titleTextField.delegate = self
        onboardingHeader.nextButton.addTarget(self, action: #selector(SetUserProfileDescriptionViewController.didTapNextButton(_:)), forControlEvents: .TouchUpInside)
        onboardingHeader.skipButton.addTarget(self, action: #selector(SetUserProfileDescriptionViewController.didTapSkipButton(_:)), forControlEvents: .TouchUpInside)

        view.backgroundColor = UIColor.oftWhiteColor()

        view.addSubview(onboardingHeader)
        view.addSubview(userProfileDescription)

        setupLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileDescription.descriptionTextField.placeholder = viewModel.pack?.description
        userProfileDescription.titleTextField.placeholder = viewModel.pack?.name
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

        let vc = AddSelectedGifsViewController(viewModel: OnboardingPackViewModel())
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func didTapSkipButton(sender: UIButton) {
        let vc = AddSelectedGifsViewController(viewModel: OnboardingPackViewModel())
        presentViewController(vc, animated: true, completion: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}