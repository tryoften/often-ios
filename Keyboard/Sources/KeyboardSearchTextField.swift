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
class KeyboardSearchTextField: UIControl {
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
    private var clearButtonLeftConstraint: NSLayoutConstraint!
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
    
    var clearButtonEnabled: Bool {
        didSet {
            clearButton.hidden = !clearButtonEnabled
        }
    }
    
    var text: String? {
        didSet {
            label.alpha = 1.0
            label.text = text
            if text == "" {
                placeholder = SearchBarPlaceholderText
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
                
                clearButtonLeftConstraint.constant = -CGRectGetHeight(clearButton.frame) - 15
                labelContainerLeftConstraint.constant = 0

                self.searchIcon.image = StyleKit.imageOfSearchbaricon(color: UIColor(fromHexString: "#BEBEBE"), scale: 1.0)
                self.backgroundView.layer.borderColor = UIColor.clearColor().CGColor
                self.clearButton.alpha = 1.0
                editing = true
            } else {
                endBlinkingIndicator()
                if editing {
                    sendActionsForControlEvents(UIControlEvents.EditingDidEnd)
                }
                
                if text == "" && placeholder != nil {
                    placeholder = SearchBarPlaceholderText
                }
                
                if self.text == "" {
                    self.textColor = LightBlackColor
                    self.clearButtonLeftConstraint.constant = 0
                    self.backgroundView.layer.borderColor = UIColor(fromHexString: "#E3E3E3").CGColor
                    self.searchIcon.image = StyleKit.imageOfSearchbaricon(color: LightBlackColor, scale: 1.0)
                } else {
                    self.backgroundView.layer.borderColor = UIColor.clearColor().CGColor
                }
                
                self.backgroundView.backgroundColor = VeryLightGray
                self.indicator.alpha = 0.0
                self.clearButton.alpha = 0.0
                editing = false
            }
        }
    }

    var labelContainerCenterMargin: CGFloat {
        label.sizeToFit()

        let containerWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let labelWidth = (CGRectGetWidth(label.frame) + CGRectGetWidth(searchIcon.frame) + 40)

        return (containerWidth / 2) - labelWidth / 2
    }

    override required init(frame: CGRect) {
        clearButtonEnabled = true
        editing = false
        inputPosition = 0
        text = ""
        id = ""
        
        backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = VeryLightGray
        backgroundView.userInteractionEnabled = false
        backgroundView.layer.borderWidth = 1.0
        backgroundView.layer.cornerRadius = 3.0
        backgroundView.layer.borderColor = UIColor(fromHexString: "#E3E3E3").CGColor
        backgroundView.accessibilityLabel = "background view"
        
        labelContainer = UIView()
        labelContainer.translatesAutoresizingMaskIntoConstraints = false
        labelContainer.clipsToBounds = true
        labelContainer.userInteractionEnabled = false
        labelContainer.accessibilityLabel = "label container"

        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Semibold", size: 12)
        label.accessibilityLabel = "label"
        
        indicator = UIView()
        indicator.backgroundColor = UIColor(fromHexString: "#14E09E")
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.alpha = 0.0
        indicator.accessibilityLabel = "indicator"
        
        clearButton = UIButton()
        clearButton.setImage(UIImage(named: "close-textfield"), forState: .Normal)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.alpha = 0.0
        clearButton.accessibilityLabel = "clear Button"
        
        searchIcon = UIImageView(image: StyleKit.imageOfSearchbaricon(color: LightBlackColor, scale: 1.0))
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchIcon.contentMode = .ScaleAspectFit
        searchIcon.accessibilityLabel = "search Icon"
    
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        id = description

        clearButton.addTarget(self, action: "clear", forControlEvents: .TouchUpInside)
        
        addSubview(backgroundView)
        addSubview(labelContainer)
        addSubview(indicator)
        addSubview(clearButton)
        
        labelContainer.addSubview(searchIcon)
        labelContainer.addSubview(label)
        
        clearButtonLeftConstraint = clearButton.al_left == al_right - 15
        labelContainerLeftConstraint = labelContainer.al_left == al_left
        indicatorPositionConstraint =  indicator.al_left == label.al_right - 40
        setupLayout()

        textColor = UIColor.blackColor()
    }

    convenience init() {
        self.init(frame: CGRectZero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        super.addTarget(target, action: action, forControlEvents: controlEvents)
    }

    override func resignFirstResponder() -> Bool {
        selected = false
        return super.resignFirstResponder()
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        if !selected {
            selected = true
        }
        return super.beginTrackingWithTouch(touch, withEvent: event)
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

    func reset() {
        clear()
        selected = false
        endBlinkingIndicator()

        sendActionsForControlEvents(.EditingDidEnd)
        sendActionsForControlEvents(.EditingDidEndOnExit)
    }

    func clear() {
        text = ""
        placeholder = SearchBarPlaceholderText
    }

    func repositionText() {
        if !selected {
            if text == "" {
                labelContainerLeftConstraint.constant = labelContainerCenterMargin
            } else {
                labelContainerLeftConstraint.constant = 0
            }
        } else {
            labelContainerLeftConstraint.constant = 0
        }
    }
    
    func setupLayout() {
        addConstraints([
            clearButtonLeftConstraint,
            clearButton.al_height == 15,
            clearButton.al_width == clearButton.al_height,
            clearButton.al_centerY == al_centerY,

            backgroundView.al_left == al_left + 5,
            backgroundView.al_right == al_right - 5,
            backgroundView.al_top == al_top,
            backgroundView.al_bottom == al_bottom,

            labelContainer.al_left == backgroundView.al_left,
            labelContainer.al_height == al_height,
            labelContainer.al_top == al_top,
            labelContainer.al_right == backgroundView.al_right,

            searchIcon.al_left == labelContainer.al_left + 5,
            searchIcon.al_centerY == labelContainer.al_centerY,
            searchIcon.al_height == 15,
            searchIcon.al_width == 20,
            
            label.al_left == searchIcon.al_right + 3,
            label.al_centerY == labelContainer.al_centerY,
            label.al_height == 16.5,
            
            indicator.al_height == 2.0,
            indicator.al_width == 10,
            indicatorPositionConstraint,
            indicator.al_bottom == label.al_bottom
        ])
    }
}

extension KeyboardSearchTextField: UITextDocumentProxy {
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
        guard let text = text  else {
            return true
        }
        
        return !text.isEmpty
    }
    
    func insertText(character: String) {
        if let text = text where character != "\n"  {
            self.text = text.stringByAppendingString(character)

            sendActionsForControlEvents(UIControlEvents.EditingChanged)
        }
    }
    
    func deleteBackward() {
        guard let text = text else {
            return
        }
        
        if !text.isEmpty {
            self.text = text.substringToIndex(text.endIndex.advancedBy(-1))
        }
        sendActionsForControlEvents(UIControlEvents.EditingChanged)
    }
}