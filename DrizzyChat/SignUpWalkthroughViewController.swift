//
//  SignUpWalkthroughViewController.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 5/25/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class SignUpLoginWalkthroughViewController: UIViewController {
    var viewModel: SignUpWalkthroughViewModel!
    var loginSignUpPage: SignUpOrLoginView!
    var artistService: ArtistService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var firebaseRoot = Firebase(url: BaseURL)
        self.artistService = ArtistService(root: firebaseRoot)
        viewModel = SignUpWalkthroughViewModel(artistService: self.artistService)
        
        loginSignUpPage = SignUpOrLoginView()
        loginSignUpPage.setTranslatesAutoresizingMaskIntoConstraints(false)
        loginSignUpPage.signUpButton.addTarget(self, action: "didTapSignUpButton", forControlEvents: .TouchUpInside)
        loginSignUpPage.loginButton.addTarget(self, action: "didTapLoginButton", forControlEvents: .TouchUpInside)
        
        
        
        view.addSubview(loginSignUpPage)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
        setupLayout()
    }
    
    func setupLayout() {
        var constraints: [NSLayoutConstraint] = [
            loginSignUpPage.al_top == view.al_top,
            loginSignUpPage.al_bottom == view.al_bottom,
            loginSignUpPage.al_left == view.al_left,
            loginSignUpPage.al_right == view.al_right,
        ]
        view.addConstraints(constraints)
    }
    
    func didTapSignUpButton() {
        let phoneNumbervc = PhoneNumberWalkthroughViewController()
        self.navigationController?.pushViewController(phoneNumbervc, animated: true)
    }
    
    func didTapLoginButton () {
        return
    }
}

class PhoneNumberWalkthroughViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate  {
    var viewModel: SignUpWalkthroughViewModel!
    var addPhoneNumberPage: SignUpPhoneNumberView!
    var artistService: ArtistService!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPhoneNumberPage = SignUpPhoneNumberView()
        addPhoneNumberPage.setTranslatesAutoresizingMaskIntoConstraints(false)
        addPhoneNumberPage.phoneNumberTxtField.delegate = self
        addPhoneNumberPage.phoneNumberTxtField.keyboardType = .PhonePad
    
        setupNavBar()
        
        view.addSubview(addPhoneNumberPage)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.hidden = false
        
        setupLayout()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        delay(0.05) {
            addPhoneNumberPage.phoneNumberTxtField.becomeFirstResponder()
        }
    }
    func setupNavBar () {
        var skipButton = UIBarButtonItem(title: "skip".uppercaseString, style: .Plain, target: self, action: "didTapSkipButton")
        self.navigationItem.setRightBarButtonItem(skipButton, animated: true)
        self.navigationItem.title = "sign up".uppercaseString
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = BlackColor
    }
    func setupLayout() {
        var constraints: [NSLayoutConstraint] = [
            addPhoneNumberPage.al_top == view.al_top,
            addPhoneNumberPage.al_bottom == view.al_bottom,
            addPhoneNumberPage.al_left == view.al_left,
            addPhoneNumberPage.al_right == view.al_right,
        ]
        view.addConstraints(constraints)
    }
    
    func didTapSkipButton() {
        let Namevc = SignUpNameWalkthroughViewController()
        self.navigationController?.pushViewController(Namevc, animated: true)
    }
}

class SignUpNameWalkthroughViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate  {
    var viewModel: SignUpWalkthroughViewModel!
    var addNamePage: SignUpNameView!
    var artistService: ArtistService!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNamePage = SignUpNameView()
        addNamePage.setTranslatesAutoresizingMaskIntoConstraints(false)
        addNamePage.fullNameTxtField.delegate = self
        
        setupNavBar()
        
        view.addSubview(addNamePage)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.hidden = false
        
        setupLayout()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        delay(0.05) {
            addNamePage.fullNameTxtField.becomeFirstResponder()
        }
    }
    func setupNavBar () {
        var skipButton = UIBarButtonItem(title: "next".uppercaseString, style: .Plain, target: self, action: "didTapNextButton")
        self.navigationItem.setRightBarButtonItem(skipButton, animated: true)
        self.navigationItem.title = "sign up".uppercaseString
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = BlackColor
    }
    func setupLayout() {
        var constraints: [NSLayoutConstraint] = [
            addNamePage.al_top == view.al_top,
            addNamePage.al_bottom == view.al_bottom,
            addNamePage.al_left == view.al_left,
            addNamePage.al_right == view.al_right,
        ]
        view.addConstraints(constraints)
    }
    
    func didTapNextButton() {
        return
    }

}

