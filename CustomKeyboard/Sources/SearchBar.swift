//
//  SearchBar.swift
//  Surf
//
//  Created by Luc Succes on 7/17/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import UIKit

class SearchBar: UIView {
    var textInput: UITextField
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
        textInput = UITextField()
        textInput.backgroundColor = UIColor.whiteColor()
        textInput.setTranslatesAutoresizingMaskIntoConstraints(false)
        textInput.placeholder = "Search"
        textInput.leftViewMode = .Always
        textInput.textColor = UIColor.blackColor()
        textInput.font = UIFont(name: "OpenSans", size: 14)
        textInput.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName: UIColor.blackColor()])
        textInput.clearButtonMode = .WhileEditing
        textInput.clearsOnBeginEditing = true
        
        buttons = []
        
        let searchImageView = UIImageView(image: UIImage(named: "search"))
        searchImageView.frame = CGRectInset(searchImageView.frame, -10, 0)
        searchImageView.contentMode = .ScaleAspectFit
        textInput.leftView = searchImageView
        
        super.init(frame: frame)

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
        self.layoutIfNeeded()
        self.textInputLeftConstraint?.constant = CGRectGetMaxX(button.frame) + 10
        UIView.animateWithDuration(0.2) {
            self.layoutIfNeeded()
        }
        buttons.append(button)
    }
    
    func removeButton() {
        
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
