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
        
        setupNavBar("next")
        
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
    
    override func didTapNavButton() {
        if NameIsValid(addNamePage.fullNameTxtField.text) {
            viewModel.fullName = addNamePage.fullNameTxtField.text
        }
        else {
            println("enter name")
            return
        }
        
        let Emailvc = SignUpEmailWalkthroughViewController()
        Emailvc.viewModel = viewModel
        
        navigationController?.pushViewController(Emailvc, animated: true)
    }
    
}
