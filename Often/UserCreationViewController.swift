//
//  UserCreationViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 1/14/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class UserCreationViewController: UIViewController, LoginViewModelDelegate {
    var viewModel: LoginViewModel
    var timer: NSTimer?

    init (viewModel: LoginViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.viewModel.delegate = nil

    }

    func didTapSignupButton(sender: UIButton) {
        self.view.endEditing(true)
        setupTimer()

    }

    override func viewDidAppear(animated: Bool) {

    }

    override func viewWillDisappear(animated: Bool) {
        
    }

    func didTapSigninButton(sender: UIButton) {
        self.view.endEditing(true)
        setupTimer()

    }

    func didTapFacebookButton(sender: UIButton) {
        self.view.endEditing(true)
        setupTimer()

        do {
            try viewModel.loginWithFacebook({ (results) -> Void in
                switch results {
                case .Success(_): print("success")
                case .Error(let err): self.showErrorView(err)
                case .SystemError(let err): DropDownErrorMessage().setMessage(err.localizedDescription, errorBackgroundColor: UIColor(fromHexString: "#152036"))
                }
            })

        } catch {
            
        }
    }


    func didTapTwitterButton(sender: UIButton) {
        self.view.endEditing(true)
        setupTimer()

        do {
            try viewModel.loginWithTwitter({ (results) -> Void in
                switch results {
                case .Success(_): print("success")
                case .Error(let err): self.showErrorView(err)
                case .SystemError(let err): DropDownErrorMessage().setMessage(err.localizedDescription, errorBackgroundColor: UIColor(fromHexString: "#152036"))
                }
            })

        } catch {

        }
    }

    func didTapAnonymousButton(sender: UIButton) {
        self.view.endEditing(true)
        setupTimer()

        do {
            try viewModel.loginAnonymously({ (results) -> Void in
                switch results {
                case .Success(_): print("success")
                case .Error(let err): self.showErrorView(err)
                case .SystemError(let err): DropDownErrorMessage().setMessage(err.localizedDescription, errorBackgroundColor: UIColor(fromHexString: "#152036"))
                }
            })

        } catch {

        }

    }

    func userDataTimeOut() {
        timer?.invalidate()
        viewModel.sessionManager.logout()
//        showErrorView(SignupError.TimeOut)
    }

    func setupTimer() {
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()
//        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "userDataTimeOut", userInfo: nil, repeats: true)
    }


    func showErrorView(error: ErrorType) {
        timer?.invalidate()
        PKHUD.sharedHUD.hide(animated: true)

        switch error {
        case TwitterAccountManagerError.ReturnedEmptyUserObject:
            DropDownErrorMessage().setMessage("Unable to sign in. please try again", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case TwitterAccountManagerError.NotConnectedOnline, SignupError.NotConnectedOnline:
            DropDownErrorMessage().setMessage("Need to be connected to the internet", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case SessionManagerError.UnvalidSignUp:
            DropDownErrorMessage().setMessage("Unable to sign in. please try again", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case SignupError.EmailNotVaild:
            DropDownErrorMessage().setMessage("Please enter a vaild email", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case SignupError.PasswordNotVaild:
            DropDownErrorMessage().setMessage("Please enter a vaild password", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case FacebookAccountManagerError.ReturnedEmptyUserObject:
            DropDownErrorMessage().setMessage("Unable to create account. Please try again", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case FacebookAccountManagerError.NotConnectedOnline, SignupError.NotConnectedOnline:
            DropDownErrorMessage().setMessage("No internet connection fam :(", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        default:
            DropDownErrorMessage().setMessage("Unable to sign in. please try again", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        }
    }
    
    func loginViewModelDidLoginUser(userProfileViewModel: LoginViewModel, user: User?) {
        timer?.invalidate()
        PKHUD.sharedHUD.hide(animated: true)
    }

    func loginViewModelNoUserFound(userProfileViewModel: LoginViewModel) {
        timer?.invalidate()
        PKHUD.sharedHUD.hide(animated: true)
    }
}