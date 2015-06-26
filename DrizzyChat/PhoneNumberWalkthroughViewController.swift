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
        
        addPhoneNumberPage = SignUpPhoneNumberView()
        addPhoneNumberPage.setTranslatesAutoresizingMaskIntoConstraints(false)
        addPhoneNumberPage.phoneNumberTxtField.delegate = self
        addPhoneNumberPage.phoneNumberTxtField.keyboardType = .PhonePad
        
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
        
        println("next button \(nextButton.frame)")
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
        if(textField == addPhoneNumberPage.phoneNumberTxtField){
            var newString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            var components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            var decimalString = "".join(components) as NSString
            var length = decimalString.length
            var lastCount = count(addPhoneNumberPage.phoneNumberTxtField.text)
            
            if length == 0 || lastCount == 12 {
                var newLength = (textField.text as NSString).length + (string as NSString).length - range.length as Int
                
                checkCharacterCountOfTextField()
                return (newLength > 10) ? false : true
            }
            
            var index = 0 as Int
            var formattedString = NSMutableString()
            

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
        } else {
        return true
        }
    }
    
    func checkCharacterCountOfTextField() {
        var characterCount = count(addPhoneNumberPage.phoneNumberTxtField.text)
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            if self.didAnimateUp && characterCount >= 1 {
                self.nextButton.hidden = false
                self.nextButton.frame.origin.y -= 50
                self.didAnimateUp = false
                self.addPhoneNumberPage.subtitleLabel.hidden = true
            } else if self.didAnimateUp == false && characterCount <= 1 {
                self.nextButton.frame.origin.y += 50
                self.didAnimateUp = true
                self.addPhoneNumberPage.subtitleLabel.hidden = false
                self.hideButton = true
            }
            }, completion: {
                (finished: Bool) in
                if self.hideButton {
                    self.nextButton.hidden = true
                    self.hideButton = false
                }
        })
    }
    
     override func didTapNavButton() {
        if count(addPhoneNumberPage.phoneNumberTxtField.text) != 0 {
            
            if PhoneIsValid(addPhoneNumberPage.phoneNumberTxtField.text) {
                viewModel.user.phone = addPhoneNumberPage.phoneNumberTxtField.text
            }
            else {
                println("redo you phonenumber")
                return
            }
        }
        
        let Namevc = SignUpNameWalkthroughViewController(viewModel:self.viewModel)
        navigationController?.pushViewController(Namevc, animated: true)
    }
}
