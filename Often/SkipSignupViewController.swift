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
    var viewModel: SignupViewModel
    
    init (viewModel: SignupViewModel) {
        self.viewModel = viewModel
        
        skipSignupView = SkipSignupView()
        skipSignupView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
        
        skipSignupView.twitterSignupButton.addTarget(self, action: "didSelectTwitterSignupButton:", forControlEvents: .TouchUpInside)
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
    

    func didSelectTwitterSignupButton(sender: UIButton) {
        self.view.endEditing(true)
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()
        viewModel.sessionManager.logout()
        do {
            try viewModel.sessionManager.login(.Twitter, completion: { results  -> Void in
                PKHUD.sharedHUD.hide(animated: true)
                switch results {
                case .Success(_): self.createProfileViewController()
                case .Error(let err): self.showErrorView(err)
                case .SystemError(let err): DropDownErrorMessage().setMessage(err.localizedDescription, errorBackgroundColor: UIColor(fromHexString: "#152036"))
                }
            })
        } catch {
            
        }
    }
    
    func didTapCreateAccountButton(sender: UIButton) {
        viewModel.sessionManager.logout()
        let signinAccount = CreateAccountViewController(viewModel:self.viewModel)
        presentViewController(signinAccount, animated: true, completion: nil)
        
    }
    
    func showErrorView(error:ErrorType) {
        switch error {
        case TwitterAccountManagerError.ReturnedEmptyUserObject:
            DropDownErrorMessage().setMessage("Unable to sign in. please try again", errorBackgroundColor: UIColor(fromHexString: "#152036"))
            break
        case TwitterAccountManagerError.NotConnectedOnline, SignupError.NotConnectedOnline:
            DropDownErrorMessage().setMessage("Need to be connected to the internet", errorBackgroundColor: UIColor(fromHexString: "#152036"))
            break
        case SessionManagerError.UnvalidSignUp:
            DropDownErrorMessage().setMessage("Unable to sign in. please try again", errorBackgroundColor: UIColor(fromHexString: "#152036"))
            break
        case SignupError.EmailNotVaild:
            DropDownErrorMessage().setMessage("Please enter a vaild email", errorBackgroundColor: UIColor(fromHexString: "#152036"))
            break
        case SignupError.PasswordNotVaild:
            DropDownErrorMessage().setMessage("Please enter a vaild password", errorBackgroundColor: UIColor(fromHexString: "#152036"))
            break
        default: break
        }
    }
    
    func createProfileViewController() {
        viewModel.sessionManager.userDefaults.setValue(false, forKey: UserDefaultsProperty.anonymousUser)
        viewModel.sessionManager.userDefaults.synchronize()
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
}
