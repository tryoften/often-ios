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
    var cancelButtonLeftConstraint: NSLayoutConstraint!
    
    var shareButton: UIButton
    var cancelButton: UIButton
    var cancelButtonLeftPadding: CGFloat {
        return CGRectGetWidth(frame) - 70
    }
    
    private var filterButton: UIButton?

    override init(frame: CGRect) {
        textInput = SearchTextField()
        textInput.translatesAutoresizingMaskIntoConstraints = false
        textInput.textColor = UIColor.blackColor()
        
        topSeperator = UIView()
        topSeperator.translatesAutoresizingMaskIntoConstraints = false
        topSeperator.backgroundColor = DarkGrey
        
        bottomSeperator = UIView()
        bottomSeperator.translatesAutoresizingMaskIntoConstraints = false
        bottomSeperator.backgroundColor = DarkGrey

        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("CANCEL", forState: .Normal)
        cancelButton.setTitle("DONE", forState: .Selected)
        cancelButton.setTitleColor(BlackColor, forState: .Normal)
        cancelButton.titleLabel?.font = UIFont(name: "Montserrat", size: 11)
        cancelButton.titleLabel?.textAlignment = .Center
        
        shareButton = UIButton()
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setImage(StyleKit.imageOfSharebutton(), forState: .Normal)
        shareButton.alpha = 0.40
        
        super.init(frame: frame)
        
        textInput.addTarget(self, action: "textFieldEditingDidBegin", forControlEvents: .EditingDidBegin)
        textInput.addTarget(self, action: "textFieldEditingDidEnd", forControlEvents: .EditingDidEnd)
        cancelButton.addTarget(self, action: "cancelButtonDidTap", forControlEvents: .TouchUpInside)
        
        backgroundColor = VeryLightGray
        addSubview(textInput)
        addSubview(cancelButton)
        addSubview(topSeperator)
        addSubview(bottomSeperator)
        addSubview(shareButton)
        

        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if frame.size.width == 0 || frame.size.height == 0 {
            return
        }
        
        toggleCancelButton()
    }
    
    func textFieldEditingDidBegin() {
        cancelButtonLeftConstraint.constant = cancelButtonLeftPadding
        backgroundColor = WhiteColor
        shareButton.hidden = true
    }
    
    func textFieldEditingDidEnd() {
        cancelButtonLeftConstraint.constant = cancelButtonLeftPadding
        backgroundColor = DefaultTheme.keyboardBackgroundColor
    }
    
    func setFilterButton(filter: Filter) {
        
        var constraints: [NSLayoutConstraint] = []
        
        if let lastButton = filterButton {
            lastButton.removeFromSuperview()
            removeConstraints(lastButton.constraints)
            repositionSearchTextField()
        }
        
        let button = UIButton()
        
        if let image = filter.image {
            button.setImage(UIImage(named: image), forState: .Normal)
        } else {
            button.setTitle(filter.text, forState: .Normal)
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsetsZero
        
        constraints.append(button.al_left == al_left + 10)
        constraints.append(button.al_top == al_top + 6.5)
        
        insertSubview(button, belowSubview: textInput)
        addConstraints(constraints + [
            button.al_bottom == al_bottom - 5
        ])
        
        textInput.leftView = nil
        layoutIfNeeded()
        
        filterButton = button
        repositionSearchTextField()
    }
    
    func resetSearchBar() {
        if let button = filterButton {
            removeConstraints(button.constraints)
            button.removeFromSuperview()
            filterButton = nil
        }
        repositionSearchTextField()
        textInput.text = ""
        textInput.placeholder = textInput.placeholderText
        textInput.selected = false
        toggleCancelButton()
    }
    
    func repositionSearchTextField() {
        if let lastButton = filterButton {
            self.textInputLeftConstraint?.constant = CGRectGetMaxX(lastButton.frame) + 5
        } else {
            self.textInputLeftConstraint?.constant = 3
        }
    }
    
    func toggleCancelButton(animated: Bool = false) {
        if shouldShowShareButton() {
            cancelButtonLeftConstraint.constant = cancelButtonLeftPadding
        } else {
            cancelButtonLeftConstraint.constant = CGRectGetWidth(frame)
            shareButton.hidden = false
        }
        
        if animated {
            UIView.animateWithDuration(0.3) {
                self.layoutIfNeeded()
            }
        }
    }
    
    func shouldShowShareButton() -> Bool {
        return textInput.selected || filterButton != nil
    }
    
    func cancelButtonDidTap() {
        if cancelButton.selected == true {
            cancelButton.selected = false
        }
        
        textInput.didTapCancelButton()
    }

    func setupLayout() {
        textInputLeftConstraint = textInput.al_left == al_left + 3
        cancelButtonLeftConstraint = cancelButton.al_left == al_left + cancelButtonLeftPadding

        addConstraints([
            textInput.al_top == al_top + 5,
            textInputLeftConstraint!,
            textInput.al_right == cancelButton.al_left - 5,
            textInput.al_bottom == al_bottom - 5,

            topSeperator.al_top == al_top,
            topSeperator.al_left == al_left,
            topSeperator.al_width == al_width,
            topSeperator.al_height == 0.6,

            bottomSeperator.al_bottom == al_bottom,
            bottomSeperator.al_left == al_left,
            bottomSeperator.al_width == al_width,
            bottomSeperator.al_height == 0.6,
            
            cancelButtonLeftConstraint,
            cancelButton.al_width == 60,
            cancelButton.al_top == al_top,
            cancelButton.al_height == al_height,
            
            shareButton.al_top == textInput.al_top,
            shareButton.al_right == textInput.al_right - 3,
            shareButton.al_width == 40,
            shareButton.al_bottom == textInput.al_bottom,
        ])
        
        layoutIfNeeded()
        textInput.selected = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
