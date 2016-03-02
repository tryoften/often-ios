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

    func didTapButton(button: LoginButton?) {
        guard let button = button else {
            return
        }

        view.endEditing(true)

        if button.type != .Twitter {
            showHud()
        }

        do {
            try viewModel.login(button.type, completion: { results in
                switch results {
                case .Success(_): PKHUD.sharedHUD.hide(animated: true)
                case .Error(let err): self.showErrorView(err)
                case .SystemError(let err): self.showSystemErrorView(err)
                }
            })
        } catch {

        }

    }

    func showHud() {
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()
    }

    func showErrorView(error: ErrorType) {
        PKHUD.sharedHUD.hide(animated: true)

        switch error {
        case AccountManagerError.ReturnedEmptyUserObject:
            DropDownErrorMessage().setMessage("Unable to sign in. Please try again", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case AccountManagerError.NotConnectedOnline, SignupError.NotConnectedOnline:
            DropDownErrorMessage().setMessage("Need to be connected to the internet", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case SessionManagerError.UnvalidSignUp:
            DropDownErrorMessage().setMessage("Unable to sign in. Please try again", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case SignupError.EmailNotVaild:
            DropDownErrorMessage().setMessage("Please enter a valid email", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case SignupError.PasswordNotVaild:
            DropDownErrorMessage().setMessage("Please enter a valid password", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case AccountManagerError.NotConnectedOnline, SignupError.NotConnectedOnline:
            DropDownErrorMessage().setMessage("No internet connection fam :(", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        default:
            DropDownErrorMessage().setMessage("Unable to sign in. Please try again", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        }
    }

    func showSystemErrorView(error: NSError) {
        PKHUD.sharedHUD.hide(animated: true)
        DropDownErrorMessage().setMessage(error.localizedDescription, errorBackgroundColor: UIColor(fromHexString: "#152036"))

    }
    
    func loginViewModelDidLoginUser(userProfileViewModel: LoginViewModel, user: User?) {
        PKHUD.sharedHUD.hide(animated: true)
    }

    func loginViewModelNoUserFound(userProfileViewModel: LoginViewModel) {
        PKHUD.sharedHUD.hide(animated: true)
    }
}