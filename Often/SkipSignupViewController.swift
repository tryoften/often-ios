//
//  SkipSignupViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 11/10/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class SkipSignupViewController: UserCreationViewController {
    var skipSignupView: SkipSignupView

    override init (viewModel: LoginViewModel) {
        skipSignupView = SkipSignupView()
        skipSignupView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(viewModel: viewModel)

        skipSignupView.oftenAccountButton.addTarget(self, action: "didTapCreateAccountButton:", forControlEvents: .TouchUpInside)
        
        view.addSubview(skipSignupView)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func didTapFacebookButton(sender: UIButton) {
        viewModel.sessionManager.logout()
        super.didTapFacebookButton(sender)

    }

    override func didTapTwitterButton(sender: UIButton) {
        viewModel.sessionManager.logout()
        super.didTapTwitterButton(sender)
    }

    func didTapCreateAccountButton(sender: UIButton) {
        timer?.invalidate()
        viewModel.sessionManager.logout()

        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()

        let loginViewModel = LoginViewModel(sessionManager: SessionManager.defaultManager)
        let vc = LoginViewController(viewModel: loginViewModel)
        vc.loginView.launchScreenLoader.hidden = true
        
        presentViewController(vc, animated: true, completion: nil)

    }

    func createProfileViewController() {
        viewModel.sessionManager.sessionManagerFlags.userIsAnonymous = false
        presentViewController(RootViewController(), animated: true, completion: nil)
    }

    func setupLayout() {
        view.addConstraints([
            skipSignupView.al_bottom == view.al_bottom,
            skipSignupView.al_top == view.al_top,
            skipSignupView.al_left == view.al_left,
            skipSignupView.al_right == view.al_right,
            ])
    }

    override func loginViewModelDidLoginUser(userProfileViewModel: LoginViewModel, user: User?) {
        super.loginViewModelDidLoginUser(userProfileViewModel, user: user)
        createProfileViewController()

    }
}
