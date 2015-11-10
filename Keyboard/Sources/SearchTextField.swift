//
//  SearchTextField.swift
//  Often
//
//  Created by Luc Succes on 7/28/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

/// This view represents a search text field including the search icon and cancel button
/// the API is partialy compatible with the UITextField one
class SearchTextField: UIControl, Layouteable {
    weak var delegate: SearchTextFieldDelegate?
    var id: String
    var editing: Bool
    
    private var backgroundView: UIView
    private var labelContainer: UIView
    private var label: UILabel
    private var indicator: UIView
    private var indicatorPositionConstraint: NSLayoutConstraint!
    private var searchIcon: UIImageView
    private var clearButton: UIButton
    private var labelContainerLeftConstraint: NSLayoutConstraint!
    private var cancelButtonLeftConstraint: NSLayoutConstraint!
    private var leftViewLeftConstraint: NSLayoutConstraint!
    private var inputPosition: Int
    private var indicatorBlinkingTimer: NSTimer?
    
    var font: UIFont? {
        didSet {
            label.font = font
        }
    }
    
    var textColor: UIColor? {
        didSet {
            label.textColor = textColor
        }
    }
    
    var enableCancelButton: Bool {
        didSet {
            clearButton.hidden = !enableCancelButton
        }
    }
    
    var text: String! {
        didSet {
            label.alpha = 1.0
            label.text = text
            if text == "" {
                placeholder = placeholderText
                indicatorPositionConstraint.constant = -40
            } else {
                indicatorPositionConstraint.constant = 0
            }
        }
    }
    
    var placeholder: String? {
        didSet {
            label.alpha = 0.65
            label.text = placeholder
        }
    }
    
    let placeholderText: String = "Search"
    
    override var selected: Bool {
        didSet {
            label.sizeToFit()
            
            if selected {
                becomeFirstResponder()
                startBlinkingIndicator()
                if !editing {
                    sendActionsForControlEvents(UIControlEvents.EditingDidBegin)
                }
                
                label.alpha = 0.45
                
                cancelButtonLeftConstraint.constant = -CGRectGetHeight(clearButton.frame) - 15
                labelContainerLeftConstraint.constant = UIScreen.mainScreen().bounds.width / 2
                
                if leftView != nil {
                    leftViewLeftConstraint.constant = 0
                }
                
                UIView.animateWithDuration(0.3) {
                    self.backgroundView.backgroundColor = UIColor(fromHexString: "#F3F3F3")
                    self.clearButton.alpha = 1.0
                    self.layoutIfNeeded()
                }
                editing = true
            } else {
                endBlinkingIndicator()
                if editing {
                    sendActionsForControlEvents(UIControlEvents.EditingDidEnd)
                }
                
                cancelButtonLeftConstraint.constant = 0
                labelContainerLeftConstraint.constant = 0
                
                if text == "" && placeholder != nil {
                    placeholder = placeholderText
                }
                
                UIView.animateWithDuration(0.3) {
                    let backgroundColor = UIColor(fromHexString: "#EBEBEB")
                    
                    if self.text == "" {
                        self.backgroundView.backgroundColor = backgroundColor
                    } else {
                        self.backgroundView.backgroundColor = backgroundColor
                    }
                    self.indicator.alpha = 0.0
                    self.clearButton.alpha = 0.0
                    self.backgroundView.layer.borderColor = backgroundColor.CGColor
                    self.layoutIfNeeded()
                }
                editing = false
            }
        }
    }
    
    var leftView: UIView? {
        didSet {
            if oldValue != nil {
                oldValue?.removeFromSuperview()
            }
            
            if let leftView = leftView {
                leftView.translatesAutoresizingMaskIntoConstraints = false
                
                leftViewLeftConstraint = leftView.al_left == al_left
                
                addSubview(leftView)
                addConstraints([
                    labelContainerLeftConstraint,
                    leftViewLeftConstraint,
                    leftView.al_height == al_height,
                    leftView.al_width == leftView.al_height,
                    leftView.al_centerY == al_centerY
                ])
                
                UIView.animateWithDuration(0.3) {
                    self.layoutIfNeeded()
                }
            }
        }
    }
    override init(frame: CGRect) {
        enableCancelButton = true
        editing = false
        inputPosition = 0
        text = ""
        id = ""
        
        backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor(fromHexString: "#EBEBEB")
        backgroundView.layer.cornerRadius = 5
        backgroundView.userInteractionEnabled = false
        
        labelContainer = UIView()
        labelContainer.translatesAutoresizingMaskIntoConstraints = false
        labelContainer.clipsToBounds = true
        labelContainer.userInteractionEnabled = false

        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Semibold", size: 12)
        
        indicator = UIView()
        indicator.backgroundColor = UIColor(fromHexString: "#14E09E")
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.alpha = 0.0
        
        clearButton = UIButton()
        clearButton.setImage(UIImage(named: "close-textfield"), forState: .Normal)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.alpha = 0.0
        
        searchIcon = UIImageView(image: UIImage(named: "search"))
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchIcon.contentMode = .ScaleAspectFit
        
        super.init(frame: frame)
        
        id = description

        clearButton.addTarget(self, action: "didTapClearButton", forControlEvents: .TouchUpInside)
        
        addSubview(backgroundView)
        addSubview(labelContainer)
        addSubview(indicator)
        addSubview(clearButton)
        
        labelContainer.addSubview(searchIcon)
        labelContainer.addSubview(label)
        cancelButtonLeftConstraint = clearButton.al_left == al_right - 15
        labelContainerLeftConstraint = labelContainer.al_left == al_left
        indicatorPositionConstraint =  indicator.al_left == label.al_right - 40
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(CGRectGetWidth(label.frame) + 10, 19.5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func becomeFirstResponder() -> Bool {
        delay(0.5) {
            NSNotificationCenter.defaultCenter().postNotificationName(TextProcessingManagerProxyEvent, object: self, userInfo: [
                "id": self.id,
                "setDefault": true
            ])
        }
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        selected = false
        return super.resignFirstResponder()
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        if !selected {
            selected = true
        }
        return true
    }
   
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        
    }
    
    func startBlinkingIndicator() {
        blinkingAction()
        indicatorBlinkingTimer =  NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("blinkingAction"), userInfo: nil, repeats: true)
    }
    
    func blinkingAction() {
        UIView.animateWithDuration(0.3) {
            self.indicator.alpha = (self.indicator.alpha == 0.0) ? 1.0 : 0.0
        }
    }
    
    func endBlinkingIndicator() {
        indicator.alpha = 0.0
        indicatorBlinkingTimer?.invalidate()
    }
    
    func didTapCancelButton() {
        text = ""
        placeholder = placeholderText
        selected = false
        sendActionsForControlEvents(UIControlEvents.EditingDidEnd)
        
        let center = NSNotificationCenter.defaultCenter()
        center.postNotificationName(KeyboardResetSearchBar, object: nil)
        center.postNotificationName(RestoreKeyboardEvent, object: nil)
        center.postNotificationName(ToggleButtonKeyboardEvent, object: nil, userInfo: ["hide": true])
    }
    
    func didTapClearButton() {
        text = ""
        placeholder = placeholderText
    }
    
    func setupLayout() {
        addConstraints([
            cancelButtonLeftConstraint,

            backgroundView.al_left == al_left + 5,
            backgroundView.al_right == al_right - 5,
            backgroundView.al_top == al_top + 1.5,
            backgroundView.al_bottom == al_bottom,
            
            searchIcon.al_left == labelContainer.al_left + 10,
            searchIcon.al_centerY == labelContainer.al_centerY - 1,
            searchIcon.al_height == 15,
            searchIcon.al_width == 20,
            
            labelContainer.al_left == al_left,
            labelContainer.al_height == al_height - 2,
            labelContainer.al_top == al_top,
            labelContainer.al_right == al_right,
            
            label.al_left == searchIcon.al_right + 3,
            label.al_centerY == labelContainer.al_centerY,
            label.al_height >= 19.5,
            
            indicator.al_height == 2.0,
            indicator.al_width == 10,
            indicatorPositionConstraint,
            indicator.al_bottom == label.al_bottom,
            
            clearButton.al_height == 15,
            clearButton.al_width == clearButton.al_height,
            clearButton.al_centerY == al_centerY
        ])
    }
}

extension SearchTextField: UITextDocumentProxy {
    func adjustTextPositionByCharacterOffset(offset: Int) {
        inputPosition += offset
    }
    
    var documentContextBeforeInput: String? {
        return text
    }
    
    var documentContextAfterInput: String? {
        return ""
    }
    
    // MARK: UIKeyInput
    
    func hasText() -> Bool {
        return !text.isEmpty
    }
    
    func insertText(character: String) {
        if (character != "\n") {
            text = text.stringByAppendingString(character)
        }
        sendActionsForControlEvents(UIControlEvents.EditingChanged)
    }
    
    func deleteBackward() {
        if !text.isEmpty {
            text = text.substringToIndex(text.endIndex.advancedBy(-1))
        }
        sendActionsForControlEvents(UIControlEvents.EditingChanged)
    }
}

protocol Layouteable {
    func setupLayout()
}

protocol SearchTextFieldDelegate: class, UITextFieldDelegate {
    
}