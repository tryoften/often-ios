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

    func didTapButton(_ button: LoginButton?) {
        guard let button = button else {
            return
        }

        UIApplication.shared().sendAction("resignFirstResponder", to: nil, from: nil, for: nil)

        if button.type != .twitter {
            showHud()
        }

        let accountStore = ACAccountStore()

        if let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter),
            let accounts = accountStore.accounts(with: accountType) where accounts.count > 0 {
            if button.type == .twitter {
                showHud()
            }
        }

        do {
            try viewModel.login(button.type, completion: { results in
                switch results {
                case .success(_): PKHUD.sharedHUD.hide(animated: true)
                case .error(let err): self.showErrorView(err)
                case .systemError(let err): self.showSystemErrorView(err)
                }
            })
        } catch {

        }

    }

    func showHud() {
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()
    }

    func showErrorView(_ error: ErrorProtocol) {
        PKHUD.sharedHUD.hide(animated: true)

        switch error {
        case AccountManagerError.returnedEmptyUserObject:
            DropDownErrorMessage().setMessage("Unable to sign in. Please try again", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case AccountManagerError.notConnectedOnline, SignupError.notConnectedOnline:
            DropDownErrorMessage().setMessage("Need to be connected to the internet", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case SessionManagerError.unvalidSignUp:
            DropDownErrorMessage().setMessage("Unable to sign in. Please try again", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case SignupError.emailNotVaild:
            DropDownErrorMessage().setMessage("Please enter a valid email", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case SignupError.passwordNotVaild:
            DropDownErrorMessage().setMessage("Please enter a valid password", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        case AccountManagerError.notConnectedOnline, SignupError.notConnectedOnline:
            DropDownErrorMessage().setMessage("No internet connection fam :(", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        default:
            DropDownErrorMessage().setMessage("Unable to sign in. Please try again", errorBackgroundColor: UIColor(fromHexString: "#152036"))
        }
    }

    func showSystemErrorView(_ error: NSError) {
        PKHUD.sharedHUD.hide(animated: true)
        DropDownErrorMessage().setMessage(error.localizedDescription, errorBackgroundColor: UIColor(fromHexString: "#152036"))

    }
    
    func loginViewModelDidLoginUser(_ userProfileViewModel: LoginViewModel, user: User?) {
        PKHUD.sharedHUD.hide(animated: true)
    }

    func loginViewModelNoUserFound(_ userProfileViewModel: LoginViewModel) {
        PKHUD.sharedHUD.hide(animated: true)
    }
}
