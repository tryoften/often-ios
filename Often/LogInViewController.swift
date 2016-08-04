//
//  LogInViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 9/8/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class LoginViewController: UserCreationViewController {
    var loginView: LoginView
    var launchScreenLoaderTimer: NSTimer?

    override init (viewModel: LoginViewModel) {
        loginView = LoginView()
        loginView.translatesAutoresizingMaskIntoConstraints = false

        super.init(viewModel: viewModel)

        view.addSubview(loginView)
        setupLayout()

        launchScreenLoaderTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(LoginViewController.userDataTimeOut), userInfo: nil, repeats: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        PKHUD.sharedHUD.hide(animated: true)

        viewModel.delegate = self

        loginView.emailButton.addTarget(self,  action: #selector(LoginViewController.didTapCreateAccountButton(_:)), forControlEvents: .TouchUpInside)
        loginView.signinButton.addTarget(self, action: #selector(LoginViewController.didTapSigninButton(_:)), forControlEvents: .TouchUpInside)
        loginView.facebookButton.addTarget(self, action: #selector(UserCreationViewController.didTapLoginButton(_:)), forControlEvents: .TouchUpInside)
        loginView.twitterButton.addTarget(self, action: #selector(UserCreationViewController.didTapLoginButton(_:)), forControlEvents: .TouchUpInside)

        if viewModel.sessionManager.sessionManagerFlags.isUserLoggedIn {
            loginView.launchScreenLoader.hidden = false
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return .Fade
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    func didTapCreateAccountButton(sender: UIButton) {
        let createAccount = CreateAccountViewController(viewModel: LoginViewModel(sessionManager: SessionManager.defaultManager))
        presentViewController(createAccount, animated: true, completion: nil)
    }
    
    func didTapSigninButton(sender: UIButton) {
        let signinAccount = SigninViewController(viewModel: LoginViewModel(sessionManager: SessionManager.defaultManager))
        presentViewController(signinAccount, animated: true, completion: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            loginView.al_bottom == view.al_bottom,
            loginView.al_top == view.al_top,
            loginView.al_left == view.al_left,
            loginView.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }

    func userDataTimeOut() {
        launchScreenLoaderTimer?.invalidate()
        loginView.launchScreenLoader.hidden = true
    }

    override func loginViewModelNoUserFound(userProfileViewModel: LoginViewModel) {
        launchScreenLoaderTimer?.invalidate()
        loginView.launchScreenLoader.hidden = true
    }

    override func loginViewModelDidLoginUser(userProfileViewModel: LoginViewModel, user: User?) {
        super.loginViewModelDidLoginUser(userProfileViewModel, user: user)

        launchScreenLoaderTimer?.invalidate()

        if viewModel.isNewUser {
           let vc = AddUsernameViewController(viewModel: LoginViewModel(sessionManager: SessionManager.defaultManager))
            presentViewController(vc, animated: true, completion: nil)

        } else {
            presentRootViewController(RootViewController())
        }
    }
}