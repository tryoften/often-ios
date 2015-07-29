//
//  VenmoMessageAmountViewController.swift
//  Surf
//
//  Created by Luc Succes on 7/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class VenmoMessageAmountViewController: ServiceProviderSupplementaryViewController {
    private var height: CGFloat = 100.0
    override var supplementaryViewHeight: CGFloat {
        return height
    }
    
    var messageTextField: SearchTextField!
    var amountTextField: SearchTextField!
    var requestOrPayView: VenmoRequestOrPayView!
    
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
        amountTextField.addTarget(self, action: "amountTextFieldDidEndEditing", forControlEvents: UIControlEvents.EditingDidEnd)
        
        requestOrPayView = VenmoRequestOrPayView()
        requestOrPayView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        view.addSubview(messageTextField)
        view.addSubview(amountTextField)
        view.addSubview(requestOrPayView)
        
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
            requestOrPayView.al_height == 45.0
        ])
    }
    
    func amountTextFieldDidEndEditing() {
        height = 100.0
    }
}
