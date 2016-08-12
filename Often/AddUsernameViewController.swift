//
//  AddUsernameViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 8/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class AddUsernameViewController: UIViewController, UITextFieldDelegate {
    var usernameView: UsernameView
    var viewModel: UsernameViewModel

    init(viewModel: UsernameViewModel) {
        usernameView = UsernameView()
        usernameView.translatesAutoresizingMaskIntoConstraints = false

        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor.whiteColor()

        view.addSubview(usernameView)

        setupLayOut()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayOut() {
        view.addConstraints([
            usernameView.al_left == view.al_left,
            usernameView.al_right == view.al_right,
            usernameView.al_bottom == view.al_bottom,
            usernameView.al_top == view.al_top
            ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameView.textField.delegate = self

        usernameView.confirmButton.addTarget(self,  action: #selector(AddUsernameViewController.didTapConfirmButton(_:)), forControlEvents: .TouchUpInside)
    }

    func didTapConfirmButton(sender: UIButton) {
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)

        if !sender.selected {
            return
        }

        viewModel.usernameDoesExist(usernameView.textField.text!, completion: { exists in
            if !exists {
                SessionManagerFlags.defaultManagerFlags.userHasUsername = true
                self.viewModel.saveUsername(self.usernameView.textField.text!)
                let vc = SetUserProfilePictureViewController(viewModel: UsernameViewModel())
                self.presentViewController(vc, animated: true, completion: nil)
            } else {
                    DropDownErrorMessage().setMessage("Username taken! Try a new one", errorBackgroundColor: UIColor(fromHexString: "#E85769"))
            }
        })
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        let characterCount = usernameView.textField.text!.characters.count
        if characterCount >= 2 {
            usernameView.confirmButton.selected = true
            usernameView.confirmButton.layer.borderWidth = 0
            usernameView.confirmButton.backgroundColor = UIColor(fromHexString: "#152036")
        } else {
            usernameView.confirmButton.backgroundColor = UIColor.whiteColor()
            usernameView.confirmButton.selected = false
            usernameView.confirmButton.layer.borderColor = UIColor(hex: "#E3E3E3").CGColor
            usernameView.confirmButton.layer.borderWidth = 2
        }

        return true
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
