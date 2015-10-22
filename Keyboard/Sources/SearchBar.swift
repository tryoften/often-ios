//
//  SearchBar.swift
//  Surf
//
//  Created by Luc Succes on 7/17/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import UIKit

/// This view is a container for a SearchTextField view and button(s) to the left or right of the
/// text field (i.e. filter button)
class SearchBar: UIView {
    var topSeperator: UIView
    var bottomSeperator: UIView

    var textInput: SearchTextField
    var textInputLeftConstraint: NSLayoutConstraint?
    var shareButtonLeftConstraint: NSLayoutConstraint!
    var providerButton: ServiceProviderSearchBarButton? {
        didSet {
            if let button = providerButton {
                addButton(button)
            }
            toggleShareButton(true)
        }
    }

    var shareButton: UIButton
    var shareButtonLeftPadding: CGFloat {
        return CGRectGetWidth(frame) - 40
    }
    
    private var buttons: [SearchBarButton]

    override init(frame: CGRect) {
        textInput = SearchTextField()
        textInput.backgroundColor = UIColor.whiteColor()
        textInput.translatesAutoresizingMaskIntoConstraints = false
        textInput.textColor = UIColor.blackColor()
        
        topSeperator = UIView()
        topSeperator.translatesAutoresizingMaskIntoConstraints = false
        topSeperator.backgroundColor = DarkGrey
        
        bottomSeperator = UIView()
        bottomSeperator.translatesAutoresizingMaskIntoConstraints = false
        bottomSeperator.backgroundColor = DarkGrey

        shareButton = UIButton()
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        buttons = []
        
        super.init(frame: frame)
        
        textInput.addTarget(self, action: "textFieldEditingDidBegin", forControlEvents: .EditingDidBegin)
        textInput.addTarget(self, action: "textFieldEditingDidEnd", forControlEvents: .EditingDidEnd)

        backgroundColor = UIColor.whiteColor()
        addSubview(textInput)
        addSubview(shareButton)
        addSubview(topSeperator)
        addSubview(bottomSeperator)

        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if frame.size.width == 0 || frame.size.height == 0 {
            return
        }
        
        toggleShareButton()
        shareButton.setImage(StyleKit.imageOfShare(frame: CGRectMake(0, 0, CGRectGetHeight(bounds), CGRectGetHeight(bounds)), color: UIColor.blackColor()), forState: .Normal)
    }
    
    func textFieldEditingDidBegin() {
        shareButtonLeftConstraint.constant = CGRectGetWidth(frame)
        UIView.animateWithDuration(0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func textFieldEditingDidEnd() {
        shareButtonLeftConstraint.constant = CGRectGetWidth(frame) / 2
        UIView.animateWithDuration(0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func addButton(button: SearchBarButton) {
        var constraints: [NSLayoutConstraint] = []
        
        if let lastButton = buttons.last {
            constraints.append(button.al_left == lastButton.al_right + 10)
            constraints.append(button.al_top == lastButton.al_top)
        } else {
            constraints.append(button.al_left == al_left + 10)
            constraints.append(button.al_top == al_top + 5)
        }
        
        insertSubview(button, belowSubview: textInput)
        addConstraints(constraints + [
            button.al_bottom == al_bottom - 5
        ])
        textInput.leftView = nil
        layoutIfNeeded()
        buttons.append(button)
        
        repositionSearchTextField()
    }
    
    func removeLastButton() {
        if let lastButton = buttons.last {
            lastButton.removeFromSuperview()
            removeConstraints(lastButton.constraints)
            buttons.removeLast()
            repositionSearchTextField()
        }
    }
    
    func resetSearchBar() {
        for button in buttons {
            removeConstraints(button.constraints)
            button.removeFromSuperview()
        }
        buttons.removeAll(keepCapacity: true)
        repositionSearchTextField()
        providerButton = nil
        textInput.selected = false
        textInput.text = ""
        textInput.placeholder = textInput.placeholderText
        toggleShareButton(true)
    }
    
    func repositionSearchTextField() {
        if let lastButton = buttons.last {
            self.textInputLeftConstraint?.constant = CGRectGetMaxX(lastButton.frame) + 10
        } else {
            self.textInputLeftConstraint?.constant = 10
        }
        UIView.animateWithDuration(0.2) {
            self.layoutIfNeeded()
        }
    }
    
    func toggleShareButton(animated: Bool = false) {
        if shouldShowShareButton() {
            shareButtonLeftConstraint.constant = CGRectGetWidth(frame)
        } else {
            shareButtonLeftConstraint.constant = shareButtonLeftPadding
        }
        
        if animated {
            UIView.animateWithDuration(0.3) {
                self.layoutIfNeeded()
            }
        }
    }
    
    func shouldShowShareButton() -> Bool {
        return textInput.selected || providerButton != nil
    }

    func setupLayout() {
        textInputLeftConstraint = textInput.al_left == al_left + 5
        shareButtonLeftConstraint = shareButton.al_left == al_left + shareButtonLeftPadding

        addConstraints([
            textInput.al_top == al_top + 5,
            textInputLeftConstraint!,
            textInput.al_right == shareButton.al_left - 5,
            textInput.al_bottom == al_bottom - 5,

            topSeperator.al_top == al_top,
            topSeperator.al_left == al_left,
            topSeperator.al_width == al_width,
            topSeperator.al_height == 0.6,

            bottomSeperator.al_bottom == al_bottom,
            bottomSeperator.al_left == al_left,
            bottomSeperator.al_width == al_width,
            bottomSeperator.al_height == 0.6,
            
            shareButtonLeftConstraint,
            shareButton.al_width == 40,
            shareButton.al_top == al_top,
            shareButton.al_height == al_height
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
