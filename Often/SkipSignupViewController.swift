//
//  SkipSignupViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 11/10/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class SkipSignupViewController: UIViewController {
    var skipSignupView: SkipSignupView
    var viewModel: LoginViewModel

     init (viewModel: LoginViewModel) {
        self.viewModel = viewModel
        
        skipSignupView = SkipSignupView()
        skipSignupView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)

        skipSignupView.oftenAccountButton.addTarget(self, action: "didTapCreateAccountButton:", for: .touchUpInside)
        
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

       func didTapCreateAccountButton(_ sender: UIButton) {
        viewModel.sessionManager.logout()

        SessionManagerFlags.defaultManagerFlags.userIsAnonymous = false

        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()

        let loginViewModel = LoginViewModel(sessionManager: SessionManager.defaultManager)
        let vc = LoginViewController(viewModel: loginViewModel)
        vc.loginView.launchScreenLoader.isHidden = true
        
        present(vc, animated: true, completion: nil)

    }

    func setupLayout() {
        view.addConstraints([
            skipSignupView.al_bottom == view.al_bottom,
            skipSignupView.al_top == view.al_top,
            skipSignupView.al_left == view.al_left,
            skipSignupView.al_right == view.al_right,
            ])
    }
}
