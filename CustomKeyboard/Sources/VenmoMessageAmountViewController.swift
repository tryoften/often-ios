//
//  VenmoMessageAmountViewController.swift
//  Surf
//
//  Created by Luc Succes on 7/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class VenmoMessageAmountViewController: ServiceProviderSupplementaryViewController {
    private var height: CGFloat = 50.0
    override var supplementaryViewHeight: CGFloat {
        return height
    }
    
    var messageTextField: UITextField!
    var amountTextField: UITextField!
    var requestOrPayView: VenmoRequestOrPayView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField = UITextField()
        messageTextField.placeholder = "Message"
        messageTextField.font = SubtitleFont
        messageTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        amountTextField = UITextField()
        amountTextField.placeholder = "$0.00"
        amountTextField.font = SubtitleFont
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
            messageTextField.al_centerY == view.al_centerY,
            messageTextField.al_right == amountTextField.al_left - 10,
            
            amountTextField.al_right == view.al_right - 10,
            amountTextField.al_centerY == view.al_centerY,
            
            requestOrPayView.al_top == view.al_top + 50.0,
            requestOrPayView.al_left == view.al_left,
            requestOrPayView.al_right == view.al_right,
            requestOrPayView.al_height == 50.0
        ])
    }
    
    func amountTextFieldDidEndEditing() {
        height = 100.0
    }
}
