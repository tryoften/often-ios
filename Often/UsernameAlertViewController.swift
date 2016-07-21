//
//  UsernameAlertViewController.swift
//  Often
//
//  Created by Katelyn Findlay on 7/20/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class UsernameAlertViewController: AlertViewController, UITextFieldDelegate {
    var viewModel: PacksService
    
    private var alertViewBottomMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 200
        }
        return 238
    }
    
    private var alertViewTopMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 40
        }
        return 68
    }
    
    private var alertViewLeftAndRightMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 32
        }
        return 42
    }
    
    init(alertView: AlertView.Type = UsernameAlertView.self, viewModel: PacksService) {
        self.viewModel = viewModel
        
        super.init(alertView: alertView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        if let alertView = alertView as? UsernameAlertView {
            alertView.textField.delegate = self
            alertView.textField.addTarget(self, action: #selector(UsernameAlertViewController.checkUsername), forControlEvents: .EditingChanged)
            
            let name = viewModel.generateSuggestedUsername()
            alertView.setTextFieldText(name)
            
            checkUsername()
            
            alertView.actionButton.addTarget(self, action: #selector(UsernameAlertViewController.didTapActionButton(_:)), forControlEvents: .TouchUpInside)
        }
    }
    
    override func setupLayout() {
        view.addConstraints([
            alertView.al_centerX == view.al_centerX,
            alertView.al_centerY == view.al_centerY,
            alertView.al_top == view.al_top + alertViewTopMargin,
            alertView.al_bottom == view.al_bottom - alertViewBottomMargin,
            alertView.al_right == view.al_right - alertViewLeftAndRightMargin,
            alertView.al_left == view.al_left + alertViewLeftAndRightMargin,
            
            backgroundTintView.al_top == view.al_top,
            backgroundTintView.al_left == view.al_left,
            backgroundTintView.al_right == view.al_right,
            backgroundTintView.al_bottom == view.al_bottom - 49,
            ])
    }
    
    func didTapActionButton(sender: UIButton) {
        if let alertView = alertView as? UsernameAlertView, let username = alertView.textField.text {
            alertView.textField.resignFirstResponder()
            SessionManagerFlags.defaultManagerFlags.userHasUsername = true
            viewModel.saveUsername(username)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func checkUsername() {
        if let alertView = alertView as? UsernameAlertView, text = alertView.textField.text {
            viewModel.usernameDoesExist(text, completion: { exists in
                alertView.setActionButtonEnabled(!exists)
                if exists && !text.isEmpty {
                    DropDownErrorMessage().setMessage("Username taken! Try a new one", errorBackgroundColor: UIColor(fromHexString: "#152036"))
                }
            })
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}