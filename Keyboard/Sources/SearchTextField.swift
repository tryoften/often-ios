//
//  SearchTextField.swift
//  Surf
//
//  Created by Luc Succes on 7/28/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class SearchTextField: UIControl, Layouteable {
    weak var delegate: SearchTextFieldDelegate?
    var id: String
    var editing: Bool
    
    private var labelContainer: UIView
    private var label: TOMSMorphingLabel
    private var indicator: UIView
    private var cancelButton: UIButton
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
            cancelButton.hidden = !enableCancelButton
        }
    }
    
    var text: String! {
        didSet {
            label.alpha = 1.0
            label.text = text
        }
    }
    
    var placeholder: String? {
        didSet {
            label.alpha = 0.65
            label.text = placeholder
            endBlinkingIndicator()
        }
    }
    
    override var selected: Bool {
        didSet {
            if selected {
                becomeFirstResponder()
                startBlinkingIndicator()
                if !editing {
                    sendActionsForControlEvents(UIControlEvents.EditingDidBegin)
                }
                text = "\(text!)"
                label.morphingEnabled = false
                
                cancelButtonLeftConstraint.constant = -CGRectGetHeight(cancelButton.frame)
                
                if leftView != nil {
                    leftViewLeftConstraint.constant = 5
                }
                
                UIView.animateWithDuration(0.3) {
                    self.cancelButton.alpha = 1.0
                    self.layoutIfNeeded()
                }
                editing = true
            } else {
                endBlinkingIndicator()
                if editing {
                    sendActionsForControlEvents(UIControlEvents.EditingDidEnd)
                }
                label.morphingEnabled = true
                cancelButtonLeftConstraint.constant = 0
                
                if let leftView = leftView {
                    leftViewLeftConstraint.constant = (CGRectGetWidth(frame) - CGRectGetWidth(leftView.frame)) / 2
                }
                
                if text == "" {
                    placeholder = "\(placeholder!)"
                }
                
                UIView.animateWithDuration(0.3) {
                    self.indicator.alpha = 0.0
                    self.cancelButton.alpha = 0.0
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
                removeConstraint(labelContainerLeftConstraint)
                leftView.setTranslatesAutoresizingMaskIntoConstraints(false)
                
                labelContainerLeftConstraint = labelContainer.al_left == leftView.al_right + 10
                
                var leftPadding: CGFloat = 5
                if centerLeftView {
                    leftPadding = (CGRectGetWidth(frame) - CGRectGetWidth(leftView.frame)) / 2
                }
                leftViewLeftConstraint = leftView.al_left == al_left + leftPadding
                
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
    var rightView: UIView? // e.g. bookmarks button
    
    var centerLeftView: Bool
    
    override init(frame: CGRect) {
        enableCancelButton = true
        centerLeftView = false
        editing = false
        inputPosition = 0
        text = ""
        id = ""
        
        labelContainer = UIView()
        labelContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
        labelContainer.clipsToBounds = true
        labelContainer.userInteractionEnabled = false

        label = TOMSMorphingLabel()
        label.animationDuration = 0.2
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont(name: "OpenSans-Semibold", size: 12)
        
        indicator = UIView()
        indicator.backgroundColor = UIColor(fromHexString: "#14E09E")
        indicator.setTranslatesAutoresizingMaskIntoConstraints(false)
        indicator.alpha = 0.0
        
        cancelButton = UIButton()
        cancelButton.setImage(UIImage(named: "close"), forState: .Normal)
        cancelButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        cancelButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        cancelButton.alpha = 0.0
        
        super.init(frame: frame)
        
        id = description
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        cancelButton.addTarget(self, action: "didTapCancelButton", forControlEvents: .TouchUpInside)
        
        addGestureRecognizer(tapGestureRecognizer)
        addSubview(labelContainer)
        addSubview(indicator)
        addSubview(cancelButton)
        
        labelContainer.addSubview(label)
        labelContainerLeftConstraint = labelContainer.al_left == al_left
        cancelButtonLeftConstraint = cancelButton.al_left == al_right
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDefaultLeftView() {
        let searchImageView = UIImageView(image: StyleKit.imageOfSearch(frame: CGRectMake(0, 0, CGRectGetHeight(frame), CGRectGetHeight(frame)), color: UIColor.blackColor(), scale: 0.5))
        searchImageView.contentMode = .ScaleAspectFit
        leftView = searchImageView
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
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        if !selected {
            selected = true
        }
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        
    }
    
    func handleTap(gestureRecogniser: UITapGestureRecognizer) {
        var location = gestureRecogniser.locationInView(self)
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
        placeholder = placeholder == nil ? "" : "\(placeholder!)"
        selected = false
        sendActionsForControlEvents(UIControlEvents.EditingDidEnd)
        NSNotificationCenter.defaultCenter().postNotificationName(RestoreKeyboardEvent, object: nil, userInfo: nil)
    }
    
    func setupLayout() {
        addConstraints([
            labelContainerLeftConstraint,
            cancelButtonLeftConstraint,
            
            labelContainer.al_height == al_height,
            labelContainer.al_top == al_top,
            labelContainer.al_right == cancelButton.al_left,
            
            label.al_left == labelContainer.al_left,
            label.al_centerY == labelContainer.al_centerY,
            label.al_height >= 19.5,
            
            indicator.al_height == 2.0,
            indicator.al_width == 10,
            indicator.al_left == label.al_right,
            indicator.al_bottom == label.al_bottom,
            
            cancelButton.al_height == al_height,
            cancelButton.al_width == cancelButton.al_height,
            cancelButton.al_centerY == al_centerY
        ])
    }
}

extension SearchTextField: UITextDocumentProxy {
    func adjustTextPositionByCharacterOffset(offset: Int) {
        inputPosition += offset
    }
    
    var documentContextBeforeInput: String! {
        return text
    }
    
    var documentContextAfterInput: String! {
        return ""
    }
    
    // MARK: UIKeyInput
    
    func hasText() -> Bool {
        return !text.isEmpty
    }
    
    func insertText(character: String) {
        text = text.stringByAppendingString(character)
        sendActionsForControlEvents(UIControlEvents.EditingChanged)
    }
    
    func deleteBackward() {
        if !text.isEmpty {
            text = text.substringToIndex(advance(text.endIndex, -1))
        }
    }
}

protocol Layouteable {
    func setupLayout()
}

protocol SearchTextFieldDelegate: class, UITextFieldDelegate {
    
}