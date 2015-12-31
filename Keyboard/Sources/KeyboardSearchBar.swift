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
class KeyboardSearchBar: UIView, SearchBar {
    weak var delegate: UISearchBarDelegate?
    
    var dummySearchBar: UISearchBar
    var topSeperator: UIView
    var bottomSeperator: UIView
    var text: String?
    var textInput: KeyboardSearchTextField
    var cancelButton: UIButton

    var selected: Bool  {
        get {
            return textInput.selected
        }

        set(value) {
            textInput.selected = value
        }
    }

    var cancelButtonLeftPadding: CGFloat {
        return CGRectGetWidth(frame) - 70
    }
    
    private var filterButton: UIButton?

    override required init(frame: CGRect) {
        dummySearchBar = UISearchBar()

        textInput = KeyboardSearchTextField(frame: CGRectZero)
        
        topSeperator = UIView()
        topSeperator.backgroundColor = DarkGrey
        
        bottomSeperator = UIView()
        bottomSeperator.backgroundColor = DarkGrey

        cancelButton = UIButton()
        cancelButton.setTitle("CANCEL", forState: .Normal)
        cancelButton.setTitle("DONE", forState: .Selected)
        cancelButton.setTitleColor(BlackColor, forState: .Normal)
        cancelButton.titleLabel?.font = UIFont(name: "Montserrat", size: 11)
        cancelButton.titleLabel?.textAlignment = .Center

        super.init(frame: frame)
        
        textInput.addTarget(self, action: "textFieldEditingDidBegin:", forControlEvents: .EditingDidBegin)
        textInput.addTarget(self, action: "textFieldDidEndEditingOnExit:", forControlEvents: .EditingDidEndOnExit)
        textInput.addTarget(self, action: "textFieldDidEndEditing:", forControlEvents: .EditingDidEnd)
        cancelButton.addTarget(self, action: "cancelButtonDidTap:", forControlEvents: .TouchUpInside)
        
        backgroundColor = WhiteColor
        addSubview(cancelButton)
        addSubview(topSeperator)
        addSubview(bottomSeperator)
        addSubview(textInput)

    }

    convenience init() {
        self.init(frame: CGRectZero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if frame.size.width == 0 || frame.size.height == 0 {
            return
        }

        topSeperator.frame = CGRectMake(0, 0, CGRectGetWidth(frame), 0.6)
        bottomSeperator.frame = CGRectMake(0, CGRectGetHeight(frame) - 0.6, CGRectGetWidth(frame), 0.6)
        
        toggleCancelButton(true)
        repositionSearchTextField()
    }

    func textFieldEditingDidBegin(sender: KeyboardSearchTextField) {
        UIView.animateWithDuration(0.3) {
            self.repositionCancelButton()
            self.repositionSearchTextField()
        }

        delegate?.searchBarTextDidBeginEditing!(dummySearchBar)
    }

    func textFieldDidEndEditing(sender: KeyboardSearchTextField) {
        delegate?.searchBarTextDidEndEditing!(dummySearchBar)

    }

    func textFieldDidEndEditingOnExit(sender: KeyboardSearchTextField) {
        reset()
    }

    func cancelButtonDidTap(sender: UIButton) {
        if cancelButton.selected == true {
            cancelButton.selected = false
        }

        textInput.reset()
        delegate?.searchBarCancelButtonClicked!(dummySearchBar)
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
        
        addSubview(button)
        addConstraints(constraints + [
            button.al_bottom == al_bottom - 5
        ])

        layoutIfNeeded()
        
        filterButton = button
        repositionSearchTextField()
        repositionCancelButton()
    }
    
    func reset() {
        if let button = filterButton {
            button.removeFromSuperview()
            filterButton = nil
        }
        repositionSearchTextField()
        textInput.clear()
        textInput.selected = false
        toggleCancelButton(true)
    }

    func clear() {
        textInput.clear()
    }
    
    private func repositionSearchTextField() {
        let textInputWidth = CGRectGetWidth(frame) - (shouldShowCancelButton() ? 80 : 10)
        textInput.frame = CGRectMake(5, 5, textInputWidth, CGRectGetHeight(frame) - 10)
    }

    private func repositionCancelButton() {
        let cancelButtonLeftPadding = shouldShowCancelButton() ? self.cancelButtonLeftPadding : CGRectGetWidth(frame)
        cancelButton.frame = CGRectMake(cancelButtonLeftPadding, 0, 60, CGRectGetHeight(frame))
    }

    func toggleCancelButton(animated: Bool = false) {
        UIView.animateWithDuration(animated ? 0.3 : 0.0) {
            self.repositionCancelButton()
        }
    }
    
    func shouldShowCancelButton() -> Bool {
        return textInput.selected || !textInput.text!.isEmpty || filterButton != nil
    }

    override func resignFirstResponder() -> Bool {
        textInput.resignFirstResponder()
        return super.resignFirstResponder()
    }

    override func becomeFirstResponder() -> Bool {
        textInput.becomeFirstResponder()
        return super.becomeFirstResponder()
    }

}

