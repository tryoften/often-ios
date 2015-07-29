//
//  SearchTextField.swift
//  Surf
//
//  Created by Luc Succes on 7/28/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class SearchTextField: UIControl, Layouteable {
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
        }
    }
    
    private var label: TOMSMorphingLabel
    private var indicator: UIView
    private var cancelButton: UIButton
    private var labelLeftConstraint: NSLayoutConstraint!
    private var cancelButtonLeftConstraint: NSLayoutConstraint!
    private var inputPosition: Int
    private var indicatorBlinkingTimer: NSTimer?
    
    override var selected: Bool {
        didSet {
            if selected {
                becomeFirstResponder()
                startBlinkingIndicator()
                sendActionsForControlEvents(UIControlEvents.EditingDidBegin)
                text = ""
                label.morphingEnabled = false
                
                cancelButtonLeftConstraint.constant = -CGRectGetHeight(cancelButton.frame) - 10
                
                UIView.animateWithDuration(0.3) {
                    self.cancelButton.alpha = 1.0
                    self.layoutIfNeeded()
                }
            } else {
                resignFirstResponder()
                endBlinkingIndicator()
                sendActionsForControlEvents(UIControlEvents.EditingDidEnd)
                label.morphingEnabled = true
                text = ""
                placeholder = "\(placeholder!)"
                
                cancelButtonLeftConstraint.constant = 0
                
                UIView.animateWithDuration(0.3) {
                    self.indicator.alpha = 0.0
                    self.cancelButton.alpha = 0.0
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    weak var delegate: SearchTextFieldDelegate?
    var editing: Bool
    
    var leftView: UIView? {
        didSet {
            if let leftView = leftView {
                removeConstraint(labelLeftConstraint)
                leftView.setTranslatesAutoresizingMaskIntoConstraints(false)
                labelLeftConstraint = label.al_left == leftView.al_right + 10
                
                addSubview(leftView)
                addConstraints([
                    labelLeftConstraint,

                    leftView.al_height == al_height - 15,
                    leftView.al_left == al_left + 5,
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
    
    override init(frame: CGRect) {
        editing = false
        inputPosition = 0
        text = ""

        label = TOMSMorphingLabel()
        label.animationDuration = 0.2
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont(name: "OpenSans", size: 22)
        
        indicator = UIView()
        indicator.backgroundColor = UIColor(fromHexString: "#14E09E")
        indicator.setTranslatesAutoresizingMaskIntoConstraints(false)
        indicator.alpha = 0.0
        
        cancelButton = UIButton()
        cancelButton.setImage(UIImage(named: "close"), forState: .Normal)
        cancelButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        cancelButton.alpha = 0.0
        
        super.init(frame: frame)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        cancelButton.addTarget(self, action: "didTapCancelButton", forControlEvents: .TouchUpInside)
        addGestureRecognizer(tapGestureRecognizer)
        addSubview(label)
        addSubview(indicator)
        addSubview(cancelButton)
        
        labelLeftConstraint = label.al_left == al_left
        cancelButtonLeftConstraint = cancelButton.al_left == al_right
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func becomeFirstResponder() -> Bool {
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
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
        indicatorBlinkingTimer?.invalidate()
    }
    
    func didTapCancelButton() {
        selected = false
    }
    
    func setupLayout() {
        addConstraints([
            labelLeftConstraint,
            cancelButtonLeftConstraint,
            
            label.al_centerY == al_centerY,
            label.al_height >= 19.5,
            indicator.al_height == 1.5,
            indicator.al_width == 10,
            indicator.al_left == label.al_right,
            indicator.al_bottom == label.al_bottom,
            
            cancelButton.al_height == al_height - 20,
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
        return text.substringToIndex(advance(text.startIndex, inputPosition))
    }
    
    var documentContextAfterInput: String! {
        return text.substringFromIndex(advance(text.startIndex, inputPosition))
    }
    
    // MARK: UIKeyInput
    
    func hasText() -> Bool {
        return !text.isEmpty
    }
    
    func insertText(character: String) {
        text = text.stringByAppendingString(character)
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