//
//  SearchBar.swift
//  Surf
//
//  Created by Luc Succes on 7/17/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import UIKit

class SearchBar: UIView {
    var textInput: SearchTextField
    var textInputLeftConstraint: NSLayoutConstraint?
    var providerButton: ServiceProviderSearchBarButton? {
        didSet {
            if let button = providerButton {
                addButton(button)
            } else {
                if oldValue != nil {
                    
                }
            }
        }
    }
    
    private var buttons: [SearchBarButton]

    override init(frame: CGRect) {
        textInput = SearchTextField()
        textInput.backgroundColor = UIColor.whiteColor()
        textInput.setTranslatesAutoresizingMaskIntoConstraints(false)
        textInput.placeholder = "Search"
        textInput.textColor = UIColor.blackColor()
        textInput.font = UIFont(name: "OpenSans", size: 14)
        
        let searchImageView = UIImageView(image: UIImage(named: "search"))
        searchImageView.contentMode = .ScaleAspectFit
        textInput.leftView = searchImageView
        
        buttons = []
        
        super.init(frame: frame)

        backgroundColor = UIColor.whiteColor()
        addSubview(textInput)
        setupLayout()
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
            removeConstraints(lastButton.constraints())
            buttons.removeLast()
            repositionSearchTextField()
        }
    }
    
    func resetSearchBar() {
        for button in buttons {
            removeConstraints(button.constraints())
            button.removeFromSuperview()
        }
        buttons.removeAll(keepCapacity: true)
        repositionSearchTextField()
        textInput.selected = false
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

    func setupLayout() {
        textInputLeftConstraint = textInput.al_left == al_left + 5
        addConstraints([
            textInput.al_top == al_top + 5,
            textInputLeftConstraint!,
            textInput.al_right == al_right - 5,
            textInput.al_bottom == al_bottom - 5
        ])
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
