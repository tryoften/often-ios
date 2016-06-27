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
    private var animationDuration: TimeInterval = 0.3
    private var dropDownDuration: TimeInterval = 1.3
    
    override init(frame: CGRect) {
        errorMessageTitleLabel = UILabel()
        errorMessageTitleLabel.font = ErrorMessageFont
        errorMessageTitleLabel.textColor = ErrorMessageFontColor
        errorMessageTitleLabel.textAlignment = .center
        errorMessageTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        errorMessageSubtitle = UILabel()
        errorMessageSubtitle.font = UIFont(name: "OpenSans", size: 11)
        errorMessageSubtitle.textColor = ErrorMessageFontColor
        errorMessageSubtitle.textAlignment = .center
        errorMessageSubtitle.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: frame)
        
        addSubview(errorMessageTitleLabel)
        addSubview(errorMessageSubtitle)
        setupLayout()
        
        self.addTarget(self, action: "hideView:", for: .touchUpInside)
        
        NotificationCenter.default().addObserver(self, selector: "dismissAlertView", name: "DismissAllNotification", object: nil)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

     deinit {
        NotificationCenter.default().removeObserver(self)
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
    
    
    func viewWasTapped(_ alertView: UIButton) {
        self.delegate?.dropdownAlertWasTapped(self)
        self.hideView(self)
    }
    
    func hideView(_ alertView: UIButton) {
            UIView.animate(withDuration: animationDuration, animations: {
                var frame: CGRect = alertView.frame
                frame.origin.y = -self.dropDownErrorViewHeight
                alertView.frame = frame
                self.perform("removeView:", with: alertView, afterDelay: 0.3)
            })
    }
    
    func dismissAllAlert() {
        NotificationCenter.default().post(name: Foundation.Notification.Name(rawValue: "DismissAllNotification"), object: nil)
    }
    
    func setMessage(_ message: String, errorBackgroundColor: UIColor) {
    DropDownErrorMessage(frame: CGRect(x: 0, y: -dropDownErrorViewHeight, width: UIScreen.main().bounds.size.width, height: dropDownErrorViewHeight)).setErrorMessage(message, errorBackgroundColor: errorBackgroundColor)
    }
    
    func setMessage(_ title: String, subtitle: String, duration: TimeInterval, errorBackgroundColor: UIColor) {
        DropDownErrorMessage(frame: CGRect(x: 0, y: -dropDownErrorViewHeight, width: UIScreen.main().bounds.size.width, height: dropDownErrorViewHeight)).setErrorMessage(title, duration: duration, subtitle: subtitle,  errorBackgroundColor: errorBackgroundColor)
    }
    
    func dismissAlertView() {
        self.hideView(self)
    }
    
    func removeView(_ alertView: UIButton) {
            alertView.removeFromSuperview()
            isShowing = false
            delegate?.dropdownAlertWasDismissed(true)
    }
    
    private func setErrorMessage(_ title: String, duration: TimeInterval, subtitle: String, errorBackgroundColor: UIColor) {
        dropDownDuration = duration
        errorMessageSubtitle.text = subtitle
        
        setErrorMessage(title, errorBackgroundColor: errorBackgroundColor)
    }
    
    private func setErrorMessage(_ message: String, errorBackgroundColor: UIColor) {
        errorMessageTitleLabel.text = message
        self.backgroundColor = errorBackgroundColor
        
        
        let frontToBackWindows = UIApplication.shared().windows.reversed()
        for window in frontToBackWindows {
            if !window.isHidden {
                window.addSubview(self)
            }
        }
        
        isShowing = true
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            var frame: CGRect = self.frame
            frame.origin.y = -10
            self.frame = frame
            }, completion: nil)

        
        self.perform("viewWasTapped:", with: self, afterDelay: dropDownDuration)
        
    }
    
}

protocol DropDownErrorMessageDelegate: class {
    func dropdownAlertWasDismissed(_ bool: Bool)
    func dropdownAlertWasTapped(_ alert: DropDownErrorMessage)
}
