//
//  KeyboardPageView.swift
//  Surf
//
//  Created by Luc Succes on 7/22/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class KeyboardPageView: UIView {
    var page: KeyboardPage
    var rowViews: [UIView]
    var containerView: UIView
    var keyWidth: CGFloat
    var maxKeysInRow: Int
    var containerWidth: CGFloat
    var keys: [KeyboardKeyButton]
    
    init(page: KeyboardPage, containerView: UIView) {
        self.page = page
        self.rowViews = []
        self.keys = []
        self.containerView = containerView
        
        containerWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        keyWidth = containerWidth / CGFloat(page.rows.first!.count)
        maxKeysInRow = 10
        
        super.init(frame: CGRectZero)
        
        for row in page.rows[0..<page.rows.count - 1] {
            setupRow(row)
        }
        
        setupLastRow(page.rows.last!)
        addRowConstraints()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupRow(row: KeyboardRow) {
        var margin = (containerWidth - CGFloat(keyWidth) * CGFloat(row.count)) / 2
        var (rowView, buttons) = createRowOfButtons(row, margin: margin)
        rowViews.append(rowView)
        addSubview(rowView)
    }
    
    func setupLastRow(row: KeyboardRow) {
        var buttons = [KeyboardKeyButton]()
        var keyboardRowView = UIView(frame: CGRectZero)
        keyboardRowView.setTranslatesAutoresizingMaskIntoConstraints(false)
        var prevButton: UIButton?
        
        for key in row {
            var constraints = [NSLayoutConstraint]()
            let button = KeyboardKeyButton(key: key, width: keyWidth)

            button.setTranslatesAutoresizingMaskIntoConstraints(false)
            buttons.append(button)
            keyboardRowView.addSubview(button)
            
            constraints += [
                button.al_top == keyboardRowView.al_top,
                button.al_bottom == keyboardRowView.al_bottom - 5
            ]
            
            switch(key) {
            case .modifier(.SpecialKeypad), .modifier(.AlphabeticKeypad):
                constraints += [
                    button.al_width == button.al_height,
                    button.al_left == keyboardRowView.al_left
                ]
                break
            case .modifier(.SwitchKeyboard), .modifier(.GoToBrowse):
                constraints += [
                    button.al_width == button.al_height,
                    button.al_left == prevButton!.al_right
                ]
                break
            case .modifier(.Space):
                constraints += [
                    button.al_left == prevButton!.al_right
                ]
                break
            case .special(.Hashtag):
                constraints += [
                    button.al_width == keyWidth,
                    button.al_left == prevButton!.al_right
                ]
                break
            case .modifier(.Enter):
                constraints += [
                    prevButton!.al_right == button.al_left,
                    button.al_right == keyboardRowView.al_right,
                    button.al_width == keyWidth * 2,
                ]
                break
            default:
                break
            }
            
            keyboardRowView.addConstraints(constraints)
            prevButton = button
        }
        
        self.keys += buttons
        addSubview(keyboardRowView)
        rowViews.append(keyboardRowView)
    }
    
    func createRowOfButtons(keys: [KeyboardKey], margin: CGFloat) -> (UIView, [KeyboardKeyButton]) {
        var buttons = [KeyboardKeyButton]()
        var keyboardRowView = UIView(frame: CGRectZero)
        keyboardRowView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        for key in keys {
            let button = KeyboardKeyButton(key: key, width: keyWidth)
            buttons.append(button)
            keyboardRowView.addSubview(button)
        }
        
        self.keys += buttons
        
        addButtonConstraints(buttons, mainView: keyboardRowView, margin: margin)
        
        return (keyboardRowView, buttons)
    }
    
    func addButtonConstraints(buttons: [KeyboardKeyButton], mainView: UIView, margin: CGFloat) {
        
        for (index, button) in enumerate(buttons) {
            
            var topConstraint = button.al_top == mainView.al_top + 1
            var bottomConstraint = button.al_bottom == mainView.al_bottom - 1
            var leftConstraint: NSLayoutConstraint!
            var rightConstraint: NSLayoutConstraint!
            
            let buttonIsModifierKey: Bool
            switch(button.key) {
            case .modifier(let character):
                buttonIsModifierKey = true
            default:
                buttonIsModifierKey = false
                break
            }
            
            // Right Constraint
            if index == buttons.count - 1 {
                var rightMargin = margin
                if buttonIsModifierKey {
                    rightMargin = 0
                    let widthConstraint = button.al_width == keyWidth * 1.5
                    widthConstraint.priority = 1000
                    button.addConstraint(widthConstraint)
                }
                rightConstraint = button.al_right == mainView.al_right - rightMargin
            }
            else {
                let nextButton = buttons[index+1]
                rightConstraint = button.al_right == nextButton.al_left
            }
            
            // Left Constraint
            if index == 0 {
                var leftMargin = margin
                
                if buttonIsModifierKey {
                    leftMargin = 0
                    let widthConstraint = button.al_width == keyWidth * 1.5
                    widthConstraint.priority = 1000
                    button.addConstraint(widthConstraint)
                } else {
                    button.addConstraint(button.al_width == keyWidth)
                }
                leftConstraint = button.al_left == mainView.al_left + leftMargin
            }
            else {
                let prevButton = buttons[index - 1]
                var widthConstraint: NSLayoutConstraint!
                widthConstraint = button.al_width == keyWidth
                widthConstraint.priority = 900
                mainView.addConstraint(widthConstraint)
                
                leftConstraint = button.al_left == prevButton.al_right
            }
            
            mainView.addConstraints([
                topConstraint, bottomConstraint,
                rightConstraint, leftConstraint
            ])
        }
    }
    
    func addRowConstraints() {
        var inputViewConstraints: [NSLayoutConstraint] = []
        
        for (index, rowView) in enumerate(rowViews) {
            inputViewConstraints += [rowView.al_left == al_left, rowView.al_right == al_right]
            
            var topConstraint: NSLayoutConstraint
            
            if index == 0 {
                topConstraint = rowView.al_top == al_top + 5
            } else {
                let prevRow = rowViews[index - 1]
                topConstraint = rowView.al_top == prevRow.al_bottom
                
                let firstRow = rowViews[0]
                var heightConstraint = rowView.al_height == firstRow.al_height
                
                heightConstraint.priority = 899
                addConstraint(heightConstraint)
            }
            inputViewConstraints += [topConstraint]
            
            var bottomConstraint: NSLayoutConstraint
            
            if index == rowViews.count - 1 {
                bottomConstraint = rowView.al_bottom == al_bottom
            } else {
                let nextRow = rowViews[index + 1]
                bottomConstraint = rowView.al_bottom == nextRow.al_top
            }
            
            inputViewConstraints += [bottomConstraint]
        }
        
        addConstraints(inputViewConstraints)
    }
}
