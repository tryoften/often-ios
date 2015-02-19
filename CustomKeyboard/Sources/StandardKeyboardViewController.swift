//
//  StandardKeyboardViewController.swift
//  Drizzy
//
//  Created by Luc Success on 1/6/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class StandardKeyboardViewController: UIViewController {
    
    var parentKeyboardViewController: KeyboardViewController!
    var rowViews: [UIView]!
    var keyWidth: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        let buttonTitles1 = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
        let buttonTitles2 = ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
        let buttonTitles3 = ["CP", "Z", "X", "C", "V", "B", "N", "M", "BP"]
        let buttonTitles4 = ["CHG", "SPACE", "RETURN"]

        let screenBoundsWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        keyWidth = screenBoundsWidth / CGFloat(buttonTitles1.count)
        
        var row1 = createRowOfButtons(buttonTitles1, margin: 0)
        var row2 = createRowOfButtons(buttonTitles2, margin: screenBoundsWidth - keyWidth * CGFloat(buttonTitles2.count))
        var row3 = createRowOfButtons(buttonTitles3, margin: screenBoundsWidth - keyWidth * CGFloat(buttonTitles3.count))
        var row4 = createRowOfButtons(buttonTitles4, margin: screenBoundsWidth - keyWidth * CGFloat(buttonTitles4.count))
        
        self.view.addSubview(row1)
        self.view.addSubview(row2)
        self.view.addSubview(row3)
        self.view.addSubview(row4)
        
        row1.setTranslatesAutoresizingMaskIntoConstraints(false)
        row2.setTranslatesAutoresizingMaskIntoConstraints(false)
        row3.setTranslatesAutoresizingMaskIntoConstraints(false)
        row4.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        rowViews = [row1, row2, row3, row4]
    }
    
    func createRowOfButtons(buttonTitles: [NSString], margin: CGFloat) -> UIView {
        
        var buttons = [UIButton]()
        var keyboardRowView = UIView(frame: CGRectZero)
        keyboardRowView.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSeperatorBelow(keyboardRowView)

        for buttonTitle in buttonTitles{
            
            let button = createButtonWithTitle(buttonTitle)
            buttons.append(button)
            keyboardRowView.addSubview(button)
        }
        
        addIndividualButtonConstraints(buttons, mainView: keyboardRowView, margin: margin/CGFloat(2))
        
        return keyboardRowView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    
    func createButtonWithTitle(title: String) -> UIButton {
        
        let button = UIButton.buttonWithType(.System) as UIButton
        button.frame = CGRectMake(0, 0, 20, 20)
        button.setTitle(title, forState: .Normal)
        button.sizeToFit()
        button.titleLabel?.font = UIFont(name: "Lato-Light", size: 15)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        button.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
        
        return button
    }
    
    func didTapButton(sender: AnyObject?) {
        
        let button = sender as UIButton
        var proxy = parentKeyboardViewController.textDocumentProxy as UITextDocumentProxy
        
        if let title = button.titleForState(.Normal) {
            switch title {
            case "BP" :
                proxy.deleteBackward()
            case "RETURN" :
                proxy.insertText("\n")
            case "SPACE" :
                proxy.insertText(" ")
            case "CHG" :
                self.parentKeyboardViewController.advanceToNextInputMode()
            default :
                proxy.insertText(title.lowercaseString)
            }
        }
    }
    
    func addIndividualButtonConstraints(buttons: [UIButton], mainView: UIView, margin: CGFloat){
        
        for (index, button) in enumerate(buttons) {
            
            var topConstraint = button.al_top == mainView.al_top
            var bottomConstraint = button.al_bottom == mainView.al_bottom - 1
            var leftConstraint : NSLayoutConstraint!
            var rightConstraint : NSLayoutConstraint!
            
            if index == buttons.count - 1 {
                rightConstraint = button.al_right == mainView.al_right - margin
            }
            else {
                let nextButton = buttons[index+1]
                rightConstraint = button.al_right == nextButton.al_left - 1
            }
            
            if index == 0 {
                leftConstraint = button.al_left == mainView.al_left + margin
                addSeperatorNextTo(button, true)
            }
            else {
                let prevButton = buttons[index-1]
                leftConstraint = button.al_left == prevButton.al_right + 1
                
                var widthConstraint = button.al_width == buttons[0].al_width
                widthConstraint.priority = 800
                
                mainView.addConstraint(widthConstraint)
            }
            
            addSeperatorNextTo(button, false)
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    func setupLastInputRow() {
        
    }
    
    func addConstraintsToInputView(inputView: UIView, rowViews: [UIView]){
        
        for (index, rowView) in enumerate(rowViews) {
            var rightSideConstraint = rowView.al_right == inputView.al_right - 1
            var leftConstraint = rowView.al_left == inputView.al_left + 1
            
            inputView.addConstraints([leftConstraint, rightSideConstraint])
            
            var topConstraint: NSLayoutConstraint
            
            if index == 0 {
                topConstraint = rowView.al_top == inputView.al_top
            } else {
                
                let prevRow = rowViews[index-1]
                topConstraint = rowView.al_top == prevRow.al_bottom
    
                let firstRow = rowViews[0]
                var heightConstraint = firstRow.al_height == rowView.al_height
                
                heightConstraint.priority = 800
                inputView.addConstraint(heightConstraint)
            }
            inputView.addConstraint(topConstraint)
            
            var bottomConstraint: NSLayoutConstraint
            
            if index == rowViews.count - 1 {
                bottomConstraint = rowView.al_bottom == inputView.al_bottom
            } else {
                
                let nextRow = rowViews[index+1]
                bottomConstraint = rowView.al_bottom == nextRow.al_top
            }
            
            inputView.addConstraint(bottomConstraint)
        }
        
    }


}
