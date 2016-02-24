//
//  ErrorMessage.swift
//  Often
//
//  Created by Kervins Valcourt on 10/7/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class DropDownErrorMessage: UIButton {
    private var errorMessageTitleLabel: UILabel
    private var errorMessageSubtitle: UILabel
    weak var delegate: DropDownErrorMessageDelegate?
    private var isShowing: Bool = false
    private let dropDownErrorViewHeight: CGFloat = 90
    private var animationDuration: NSTimeInterval = 0.3
    private var dropDownDuration: NSTimeInterval = 1.3
    
    override init(frame: CGRect) {
        errorMessageTitleLabel = UILabel()
        errorMessageTitleLabel.font = ErrorMessageFont
        errorMessageTitleLabel.textColor = ErrorMessageFontColor
        errorMessageTitleLabel.textAlignment = .Center
        errorMessageTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        errorMessageSubtitle = UILabel()
        errorMessageSubtitle.font = UIFont(name: "OpenSans", size: 11)
        errorMessageSubtitle.textColor = ErrorMessageFontColor
        errorMessageSubtitle.textAlignment = .Center
        errorMessageSubtitle.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: frame)
        
        addSubview(errorMessageTitleLabel)
        addSubview(errorMessageSubtitle)
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
            errorMessageTitleLabel.al_top == al_top + dropDownErrorViewHeight/3,
            errorMessageTitleLabel.al_left == al_left + 10,
            errorMessageTitleLabel.al_right == al_right - 10,
            errorMessageTitleLabel.al_bottom == al_centerY,
            
            errorMessageSubtitle.al_top == errorMessageTitleLabel.al_top,
            errorMessageSubtitle.al_left == al_left + 10,
            errorMessageSubtitle.al_right == al_right - 10,
            errorMessageSubtitle.al_bottom == al_bottom,
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
    
    func setMessage(title: String, subtitle: String, duration: NSTimeInterval, errorBackgroundColor: UIColor) {
        DropDownErrorMessage(frame: CGRectMake(0, -dropDownErrorViewHeight, UIScreen.mainScreen().bounds.size.width, dropDownErrorViewHeight)).setErrorMessage(title, duration: duration, subtitle: subtitle,  errorBackgroundColor: errorBackgroundColor)
    }
    
    func dismissAlertView() {
        self.hideView(self)
    }
    
    func removeView(alertView: UIButton) {
            alertView.removeFromSuperview()
            isShowing = false
            delegate?.dropdownAlertWasDismissed(true)
    }
    
    private func setErrorMessage(title: String, duration: NSTimeInterval, subtitle: String, errorBackgroundColor: UIColor) {
        dropDownDuration = duration
        errorMessageSubtitle.text = subtitle
        
        setErrorMessage(title, errorBackgroundColor: errorBackgroundColor)
    }
    
    private func setErrorMessage(message: String, errorBackgroundColor: UIColor) {
        errorMessageTitleLabel.text = message
        self.backgroundColor = errorBackgroundColor
        
        
        let frontToBackWindows = UIApplication.sharedApplication().windows.reverse()
        for window in frontToBackWindows {
            if !window.hidden {
                window.addSubview(self)
            }
        }
        
        isShowing = true
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            var frame: CGRect = self.frame
            frame.origin.y = -10
            self.frame = frame
            }, completion: nil)
        
        
        self.performSelector("viewWasTapped:", withObject: self, afterDelay: dropDownDuration)
        
    }
    
}

protocol DropDownErrorMessageDelegate: class {
    func dropdownAlertWasDismissed(bool: Bool)
    func dropdownAlertWasTapped(alert: DropDownErrorMessage)
}
