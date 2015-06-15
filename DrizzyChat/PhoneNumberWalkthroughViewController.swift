//
//  PhoneNumberWalkthroughViewController.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 6/15/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class PhoneNumberWalkthroughViewController: WalkthroughViewController {
    var addPhoneNumberPage: SignUpPhoneNumberView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SignUpWalkthroughViewModel(artistService: artistService)
        
        addPhoneNumberPage = SignUpPhoneNumberView()
        addPhoneNumberPage.setTranslatesAutoresizingMaskIntoConstraints(false)
        addPhoneNumberPage.phoneNumberTxtField.delegate = self
        addPhoneNumberPage.phoneNumberTxtField.keyboardType = .PhonePad
        
        setupNavBar("skip")
        
        view.addSubview(addPhoneNumberPage)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        delay(0.05) {
            addPhoneNumberPage.phoneNumberTxtField.becomeFirstResponder()
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        var constraints: [NSLayoutConstraint] = [
            addPhoneNumberPage.al_top == view.al_top,
            addPhoneNumberPage.al_bottom == view.al_bottom,
            addPhoneNumberPage.al_left == view.al_left,
            addPhoneNumberPage.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        checkCharacterCountOfTextField()
        
        if textField == addPhoneNumberPage.phoneNumberTxtField {
            var newString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            var components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            var decimalString = "".join(components) as NSString
            var length = decimalString.length
            var hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                var newLength = (textField.text as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            
            var index = 0 as Int
            var formattedString = NSMutableString()
            
            if hasLeadingOne {
                formattedString.appendString("1 ")
                index += 1
            }
            
            if (length - index) > 3 {
                var areaCode = decimalString.substringWithRange(NSMakeRange(index, 3))
                
                formattedString.appendFormat("%@-", areaCode)
                index += 3
            }
            
            if length - index > 3 {
                var prefix = decimalString.substringWithRange(NSMakeRange(index, 3))
                
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            var remainder = decimalString.substringFromIndex(index)
            
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            
            return false
        }
            
        else {
            return true
        }
    }
    
    func checkCharacterCountOfTextField() {
        if (count(addPhoneNumberPage.phoneNumberTxtField.text) >= 2) {
            navigationItem.rightBarButtonItem?.title = "next".uppercaseString
        } else {
            navigationItem.rightBarButtonItem?.title = "skip".uppercaseString
        }
    }
    
    override func didTapNavButton() {
        if count(addPhoneNumberPage.phoneNumberTxtField.text) != 0 {
            
            if PhoneIsValid(addPhoneNumberPage.phoneNumberTxtField.text) {
                viewModel.phoneNumber = addPhoneNumberPage.phoneNumberTxtField.text
            }
            else {
                println("redo you phonenumber")
                return
            }
        }
        
        let Namevc = SignUpNameWalkthroughViewController()
        Namevc.viewModel = viewModel
        
        navigationController?.pushViewController(Namevc, animated: true)
    }
}
