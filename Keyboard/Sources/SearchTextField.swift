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
    
    var shareButton: UIButton
    
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
            label.alpha = 0.80
            label.text = placeholder
            if !selected {
                labelContainerLeftConstraint.constant = labelContainerCenterMargin
            }
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
                
                label.alpha = text == "" ? 0.45 : 1.0
                
                cancelButtonLeftConstraint.constant = -CGRectGetHeight(clearButton.frame) - 15
                labelContainerLeftConstraint.constant = 0
                shareButton.hidden = true
                
                if leftView != nil {
                    leftViewLeftConstraint.constant = 0
                }
                
                UIView.animateWithDuration(0.3) {
                    self.searchIcon.image = StyleKit.imageOfSearchbaricon(color: UIColor(fromHexString: "#BEBEBE"), scale: 1.0)
                    self.backgroundView.layer.borderColor = UIColor.clearColor().CGColor
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
                
                if text == "" && placeholder != nil {
                    placeholder = placeholderText
                    shareButton.hidden = false
                } else {
                    shareButton.hidden = true
                }
                
                UIView.animateWithDuration(0.3) {
                    if self.text == "" {
                        self.textColor = LightBlackColor
                        self.cancelButtonLeftConstraint.constant = 0
                        self.backgroundView.layer.borderColor = UIColor(fromHexString: "#E3E3E3").CGColor
                        self.labelContainerLeftConstraint.constant = self.labelContainerCenterMargin
                        self.searchIcon.image = StyleKit.imageOfSearchbaricon(color: LightBlackColor, scale: 1.0)
                    } else {
                        self.backgroundView.layer.borderColor = UIColor.clearColor().CGColor
                        self.labelContainerLeftConstraint.constant = 0
                    }
                    
                    self.backgroundView.backgroundColor = WhiteColor
                    self.indicator.alpha = 0.0
                    self.clearButton.alpha = 0.0
                    self.layoutIfNeeded()
                }
                editing = false
            }
        }
    }
    
    
    var labelContainerCenterMargin: CGFloat {
        label.sizeToFit()

        let containerWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let labelWidth = (CGRectGetWidth(label.frame) + CGRectGetWidth(searchIcon.frame) + 40)
        
        print("Container width: ", containerWidth, " labelWidth: ", labelWidth)
        return (containerWidth / 2) - labelWidth / 2
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
        backgroundView.backgroundColor = WhiteColor
        backgroundView.userInteractionEnabled = false
        backgroundView.layer.borderWidth = 1.0
        backgroundView.layer.cornerRadius = 3.0
        
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
        
        searchIcon = UIImageView(image: StyleKit.imageOfSearchbaricon(color: LightBlackColor, scale: 1.0))
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchIcon.contentMode = .ScaleAspectFit
        
        shareButton = UIButton()
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setImage(StyleKit.imageOfSharebutton(), forState: .Normal)
        shareButton.alpha = 0.40
        shareButton.hidden = true
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        id = description

        clearButton.addTarget(self, action: "didTapClearButton", forControlEvents: .TouchUpInside)
        
        addSubview(backgroundView)
        addSubview(labelContainer)
        addSubview(indicator)
        addSubview(clearButton)
        
        labelContainer.addSubview(searchIcon)
        labelContainer.addSubview(label)
        labelContainer.addSubview(shareButton)
        
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
        endBlinkingIndicator()
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
            backgroundView.al_top == al_top,
            backgroundView.al_bottom == al_bottom,
            
            searchIcon.al_left == labelContainer.al_left + 10,
            searchIcon.al_centerY == labelContainer.al_centerY,
            searchIcon.al_height == 15,
            searchIcon.al_width == 20,
            
            labelContainerLeftConstraint,
            labelContainer.al_height == al_height,
            labelContainer.al_top == al_top,
            labelContainer.al_right == backgroundView.al_right,
            
            label.al_left == searchIcon.al_right + 3,
            label.al_centerY == labelContainer.al_centerY,
            label.al_height == 16.5,
            
            indicator.al_height == 2.0,
            indicator.al_width == 10,
            indicatorPositionConstraint,
            indicator.al_bottom == label.al_bottom,
            
            clearButton.al_height == 15,
            clearButton.al_width == clearButton.al_height,
            clearButton.al_centerY == al_centerY,
            
            shareButton.al_right == labelContainer.al_right,
            shareButton.al_centerY == labelContainer.al_centerY
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