//
//  UsernameAlertViewController.swift
//  Often
//
//  Created by Katelyn Findlay on 7/20/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class UsernameAlertViewController: AlertViewController {
    var viewModel: PacksService
    
    init(alertView: AlertView.Type = UsernameAlertView.self, viewModel: PacksService) {
        self.viewModel = viewModel
        
        super.init(alertView: alertView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        if let alertView = alertView as? UsernameAlertView {
            alertView.textField.addTarget(self, action: #selector(UsernameAlertViewController.textChanged), forControlEvents: .EditingChanged)
            let name = viewModel.generateSuggestedUsername()
            alertView.textField.text = name
            
            if viewModel.usernameDoesExist(name) {
                alertView.actionButton.enabled = false
            }
            
            alertView.actionButton.addTarget(self, action: #selector(UsernameAlertViewController.didTapActionButton(_:)), forControlEvents: .TouchUpInside)
        }
    }
    
    func didTapActionButton(sender: UIButton) {
        if let alertView = alertView as? UsernameAlertView, let username = alertView.textField.text {
            SessionManagerFlags.defaultManagerFlags.userHasUsername = true
            viewModel.saveUsername(username)
            dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func textChanged() {
        if let alertView = alertView as? UsernameAlertView, text = alertView.textField.text {
            if viewModel.usernameDoesExist(text) {
                alertView.actionButton.enabled = false
                // tell username is taken
            } else {
                alertView.actionButton.enabled = true
            }
        }
    }

}