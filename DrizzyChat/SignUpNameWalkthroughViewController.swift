//
//  SignUpNameWalkthroughViewController.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/15/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class SignUpNameWalkthroughViewController: WalkthroughViewController  {
    var addNamePage: SignUpNameView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNamePage = SignUpNameView()
        addNamePage.setTranslatesAutoresizingMaskIntoConstraints(false)
        addNamePage.fullNameTxtField.delegate = self
        self.nextButton.hidden = true
        
        view.addSubview(addNamePage)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        delay(0.05) {
            addNamePage.fullNameTxtField.becomeFirstResponder()
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        var constraints: [NSLayoutConstraint] = [
            addNamePage.al_top == view.al_top,
            addNamePage.al_bottom == view.al_bottom,
            addNamePage.al_left == view.al_left,
            addNamePage.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        checkCharacterCountOfTextField()
        
        return true
    }
    
    func checkCharacterCountOfTextField() {
        var characterCount = count(addNamePage.fullNameTxtField.text)
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            if self.didAnimateUp && characterCount >= 2 {
                self.nextButton.hidden = false
                self.nextButton.frame.origin.y -= 50
                self.didAnimateUp = false
                self.addNamePage.termsAndPrivacyView.hidden = true
            } else if self.didAnimateUp == false && characterCount < 2 {
                self.nextButton.frame.origin.y += 50
                self.didAnimateUp = true
                self.addNamePage.termsAndPrivacyView.hidden = false
                self.hideButton = true
            }
            }, completion: {
                (finished: Bool) in
                if self.hideButton {
                    self.nextButton.hidden = true
                    self.hideButton = false
                }
        })
    }

    override func didTapNavButton() {
        if NameIsValid(addNamePage.fullNameTxtField.text) {
            viewModel.user.name = addNamePage.fullNameTxtField.text
        }
        else {
            println("enter name")
            return
        }
        
        let Emailvc = SignUpEmailWalkthroughViewController(viewModel: self.viewModel)
        navigationController?.pushViewController(Emailvc, animated: true)
    }
    
}
