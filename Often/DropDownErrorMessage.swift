//
//  ErrorMessage.swift
//  Often
//
//  Created by Kervins Valcourt on 10/7/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class DropDownErrorMessage: UIButton {
    var errorMessageLabel: UILabel
    weak var delegate: DropDownErrorMessageDelegate?
    var isShowing: Bool = false
    let dropDownErrorViewHeight: CGFloat = 90
    var animationDuration: NSTimeInterval = 0.3
    
    override init(frame: CGRect) {
        errorMessageLabel = UILabel()
        errorMessageLabel.font = ErrorMessageFont
        errorMessageLabel.textColor = ErrorMessageFontColor
        errorMessageLabel.textAlignment = .Center
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        
        addSubview(errorMessageLabel)
        
        setupLayout()
        
        self.addTarget(self, action: "hideView:", forControlEvents: .TouchUpInside)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "dismissAlertView", name: "DismissAllNotification", object: nil)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

     deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func setupLayout() {
        addConstraints([
            errorMessageLabel.al_top == al_top ,
            errorMessageLabel.al_left == al_left + 10,
            errorMessageLabel.al_right == al_right - 10,
            errorMessageLabel.al_bottom == al_bottom
            ])
    }
    
    func viewWasTapped(alertView: UIButton) {
        self.delegate?.dropdownAlertWasTapped(self)
        self.hideView(self)
    }
    
    func hideView(alertView: UIButton) {
            UIView.animateWithDuration(animationDuration, animations: {
                var frame: CGRect = alertView.frame
                frame.origin.y = -self.dropDownErrorViewHeight
                alertView.frame = frame
                self.performSelector("removeView:", withObject: alertView, afterDelay: 0.3)
            })
    }
    
    func dismissAllAlert() {
        NSNotificationCenter.defaultCenter().postNotificationName("DismissAllNotification", object: nil)
    }
    
    func setMessage(message: String, errorBackgroundColor: UIColor) {
    DropDownErrorMessage(frame: CGRectMake(0, -dropDownErrorViewHeight, UIScreen.mainScreen().bounds.size.width, dropDownErrorViewHeight)).setErrorMessage(message, errorBackgroundColor: errorBackgroundColor)
    }
    
    func dismissAlertView() {
        self.hideView(self)
    }
    
    func removeView(alertView: UIButton) {
            alertView.removeFromSuperview()
            isShowing = false
            delegate?.dropdownAlertWasDismissed(true)
    }
    
    private func setErrorMessage(message: String, errorBackgroundColor: UIColor) {
        errorMessageLabel.text = message
        self.backgroundColor = errorBackgroundColor
        
        
        let frontToBackWindows = UIApplication.sharedApplication().windows.reverse()
        for window in frontToBackWindows {
            if (!window.hidden) {
                window.addSubview(self)
            }
        }
        
        isShowing = true
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.0, options: [], animations: {
            var frame: CGRect = self.frame
            frame.origin.y = 0
            self.frame = frame
            }, completion: nil)
        
        
        self.performSelector("viewWasTapped:", withObject: self, afterDelay: 1.6)
        
    }
    
}

protocol DropDownErrorMessageDelegate: class {
    func dropdownAlertWasDismissed(bool: Bool)
    func dropdownAlertWasTapped(alert:DropDownErrorMessage)
}
