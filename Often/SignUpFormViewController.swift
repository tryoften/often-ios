//
//  SignUpFormViewController.swift
//  Drizzy
//
//  Created by Luc Success on 2/8/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

enum TextFieldKey : Int {
    case FullName = 0, Email, Password, Submit
}

class SignUpFormViewController: UIViewController,
    UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var navigationBar: UINavigationBar!
    var tableView: UITableView!
    var cells: [UITableViewCell]!
    var viewModel: SignUpFormViewModel!
    var nameField: UITextField!
    var emailField: UITextField!
    var passwordField: UITextField!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        viewModel = SignUpFormViewModel()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        title = "Sign Up"

        tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0.1)
        tableView.scrollEnabled = false

        cells = [UITableViewCell]()

        var nameRow = SignUpFormTableViewCell()
        nameRow.icon = "\u{1F464}"
        nameField = nameRow.textField
        nameField.placeholder = "Full name"
        nameField.returnKeyType = .Next
        nameField.delegate = self
        nameField.autocapitalizationType = .Words
        nameField.tag = TextFieldKey.FullName.rawValue
        cells.append(nameRow)

        var emailRow = SignUpFormTableViewCell()
        emailRow.icon = "\u{2709}"
        emailField = emailRow.textField
        emailField.placeholder = "Email"
        emailField.returnKeyType = .Next
        emailField.delegate = self
        emailField.autocapitalizationType = .None
        emailField.tag = TextFieldKey.Email.rawValue
        cells.append(emailRow)

        var passwordRow = SignUpFormTableViewCell()
        passwordRow.icon = "\u{1F512}"
        passwordField = passwordRow.textField
        passwordField.placeholder = "Password"
        passwordField.secureTextEntry = true
        passwordField.delegate = self
        passwordField.autocapitalizationType = .None
        passwordField.tag = TextFieldKey.Password.rawValue

        cells.append(passwordRow)
        cells.append(provideSubmitButtonCell())

        var cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "didTapCancelButton")
        navigationItem.setLeftBarButtonItem(cancelButton, animated: true)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(tableView)
        setupLayout()
    
        nameField.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.setContentOffset(CGPointZero, animated: false)
    }
    
    func provideSubmitButtonCell() -> UITableViewCell {
        var cell = UITableViewCell()
        var actionButton = UIButton()

        actionButton.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        actionButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        actionButton.backgroundColor = UIColor(fromHexString: "#ffb61d")
        actionButton.setTitle("Submit", forState: .Normal)
        actionButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: 20)
        actionButton.titleLabel?.textColor = UIColor.whiteColor()
        actionButton.addTarget(self, action: "didTapSubmitButton", forControlEvents: .TouchUpInside)
        
        cell.contentView.addSubview(actionButton)
        
        cell.addConstraints([
            actionButton.al_left == cell.contentView.al_left,
            actionButton.al_top == cell.contentView.al_top,
            actionButton.al_width == cell.contentView.al_width,
            actionButton.al_height == cell.contentView.al_height
        ])
        
        return cell
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        switch textField.tag {
        case TextFieldKey.FullName.rawValue:
            viewModel.fullName = textField.text
            break
        case TextFieldKey.Email.rawValue:
            viewModel.email = textField.text
            break
        case TextFieldKey.Password.rawValue:
            viewModel.password = textField.text
            break
        default:
            break
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == nameField {
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            passwordField.resignFirstResponder()
        }

        return false
    }
    
    func didTapSubmitButton() {
        viewModel.fullName = nameField.text
        viewModel.email = emailField.text
        viewModel.password = passwordField.text

        var errorMessage = viewModel.validateForm()
        
        if errorMessage == nil {
            viewModel.submitForm({ (completed, error) in
                if completed {
                    var homeVC = TabBarController(sessionManager: SessionManager.defaultManager)
                    
                    self.presentViewController(homeVC, animated: true, completion: nil)
                } else {
                    var errorMessage = (error?.userInfo as! [String: AnyObject])["error"] as! String
                    var alertView = UIAlertView(title: "Sign up failed", message: "Sorry! \(errorMessage)", delegate: self, cancelButtonTitle: "Try again")
                    alertView.show()

                }
            })
        } else {
            var alertView = UIAlertView(title: "Form Invalid", message: errorMessage, delegate: self, cancelButtonTitle: "Try again")
            alertView.show()
        }
    }
    
    func didTapCancelButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupLayout() {
        let cellCount: CGFloat = CGFloat(cells.count) * 50
        let barFrame = self.navigationController!.navigationBar.frame
        let topMargin: CGFloat = 64

        view.addConstraints([
            tableView.al_top == view.al_top + topMargin,
            tableView.al_height == cellCount,
            tableView.al_left == view.al_left,
            tableView.al_width == view.al_width
        ])
    }
    
    // mark: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }

}
