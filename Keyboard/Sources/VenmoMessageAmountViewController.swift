//
//  VenmoMessageAmountViewController.swift
//  Surf
//
//  Created by Luc Succes on 7/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class VenmoMessageAmountViewController: ServiceProviderSupplementaryViewController {
    override var supplementaryViewHeight: CGFloat {
        return 100.0
    }
    
    var messageTextField: SearchTextField!
    var amountTextField: SearchTextField!
    var requestOrPayView: VenmoRequestOrPayView!
    var confirmButton: UIButton!
    var confirmButtonTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField = SearchTextField()
        messageTextField.placeholder = "Message"
        messageTextField.font = SubtitleFont
        messageTextField.enableCancelButton = false
        messageTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        amountTextField = SearchTextField()
        amountTextField.placeholder = "$0.00"
        amountTextField.font = SubtitleFont
        amountTextField.enableCancelButton = false
        amountTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        amountTextField.addTarget(self, action: "amountTextFieldDidEdit", forControlEvents: .EditingChanged)
        amountTextField.addTarget(self, action: "amountTextFieldDidEndEditing", forControlEvents: .EditingDidEnd)
        
        requestOrPayView = VenmoRequestOrPayView()
        requestOrPayView.setTranslatesAutoresizingMaskIntoConstraints(false)
        requestOrPayView.requestButton.addTarget(self, action: "didTapRequestButton", forControlEvents: .TouchUpInside)
        requestOrPayView.payButton.addTarget(self, action: "didTapPayButton", forControlEvents: .TouchUpInside)
        
        confirmButton = UIButton()
        confirmButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        confirmButton.backgroundColor = UIColor(fromHexString: "#7ED321")
        confirmButton.setTitle("Confirm Payment", forState: .Normal)
        confirmButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        confirmButton.titleLabel!.font = UIFont(name: "OpenSans-Semibold", size: 16)
        confirmButton.addTarget(self, action: "didTapConfirmButton", forControlEvents: .TouchUpInside)
        
        confirmButtonTopConstraint = confirmButton.al_top == view.al_bottom
        
        view.addSubview(messageTextField)
        view.addSubview(amountTextField)
        view.addSubview(requestOrPayView)
        view.addSubview(confirmButton)
        
        setupLayout()
    }
    
    override func viewDidAppear(animated: Bool) {
        messageTextField.becomeFirstResponder()
    }
    
    func setupLayout() {
        view.addConstraints([
            messageTextField.al_left == view.al_left + 10,
            messageTextField.al_top == view.al_top + 10,
            messageTextField.al_width == view.al_width - 80,
            {
                let constraint = self.amountTextField.al_right == self.view.al_right - 10
                constraint.priority = 1000
                return constraint
            }(),
            amountTextField.al_top == view.al_top + 10,
            amountTextField.al_left == messageTextField.al_right + 10,
            
            requestOrPayView.al_bottom == view.al_bottom,
            requestOrPayView.al_left == view.al_left,
            requestOrPayView.al_right == view.al_right,
            requestOrPayView.al_height == 45.0,
            
            confirmButtonTopConstraint,
            confirmButton.al_height == requestOrPayView.al_height,
            confirmButton.al_left == requestOrPayView.al_left,
            confirmButton.al_width == requestOrPayView.al_width
        ])
    }
    
    func didTapRequestButton() {
        confirmButtonTopConstraint.constant = -45.0
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func didTapPayButton() {
        confirmButtonTopConstraint.constant = -45.0
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func didTapConfirmButton() {
        confirmButton.userInteractionEnabled = false
        confirmButton.setTitle("Sending Payment...", forState: .Normal)
        
        delay(2.0) {
            self.confirmButton.userInteractionEnabled = true
            self.confirmButton.setTitle("Payment Successful!!", forState: .Normal)
            delay(1.0) {
                self.height = 0.0
            NSNotificationCenter.defaultCenter().postNotificationName("SearchBarController.resetSearchBar", object: nil)
            }
        }
    }
    
    func amountTextFieldDidEdit() {
        requestOrPayView.active = true
    }
    
    func amountTextFieldDidEndEditing() {
        height = 100.0
    }
}
