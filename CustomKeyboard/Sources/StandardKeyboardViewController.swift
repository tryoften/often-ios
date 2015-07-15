//
//  StandardKeyboardViewController.swift
//  Drizzy
//
//  Created by Luc Success on 1/6/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class StandardKeyboardViewController: UIViewController {
    
    var textProcessor: TextProcessingManager!
    var rowViews: [UIView]!
    var keyWidth: CGFloat!
    var keysContainerView: UIView!
    var keyButtons: [KeyboardKeyButton]!
    var searchBar: UITextField!
    var lettercase: Lettercase!
    
    let characterMap: [ [KeyboardKey] ] = [
        [.letter(.Q), .letter(.W), .letter(.E), .letter(.R), .letter(.T), .letter(.Y), .letter(.U), .letter(.I), .letter(.O), .letter(.P)],
        [.letter(.A), .letter(.S), .letter(.D), .letter(.F), .letter(.G), .letter(.H), .letter(.J), .letter(.K), .letter(.L)],
        [.modifier(.CapsLock), .letter(.Z), .letter(.X), .letter(.C), .letter(.V), .letter(.B), .letter(.N), .letter(.M), .modifier(.Backspace)],
        [.modifier(.NumericKeypad), .modifier(.SwitchKeyboard), .modifier(.GoToBrowse), .modifier(.Space), .modifier(.Enter)]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        lettercase = .Lowercase
        
        keyButtons = []
        keysContainerView = UIView()
        keysContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.backgroundColor = UIColor(fromHexString: "#202020")
        
        searchBar = UITextField()
        searchBar.backgroundColor = UIColor(fromHexString: "#121314")
        searchBar.setTranslatesAutoresizingMaskIntoConstraints(false)
        searchBar.placeholder = "Search"
        searchBar.textColor = UIColor.whiteColor()
        searchBar.font = UIFont(name: "OpenSans", size: 16)
        searchBar.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        searchBar.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)

        let screenBoundsWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        keyWidth = screenBoundsWidth / CGFloat(characterMap[0].count)
        
        var row1 = createRowOfButtons(characterMap[0], margin: 0)
        var row2 = createRowOfButtons(characterMap[1], margin: screenBoundsWidth - keyWidth * CGFloat(characterMap[1].count))
        var row3 = createRowOfButtons(characterMap[2], margin: screenBoundsWidth - keyWidth * CGFloat(characterMap[2].count))
        var row4 = setupLastInputRow(characterMap[3])
        
        keysContainerView.addSubview(row1)
        keysContainerView.addSubview(row2)
        keysContainerView.addSubview(row3)
        keysContainerView.addSubview(row4)
        
        view.addSubview(keysContainerView)
        view.addSubview(searchBar)
        
        row1.setTranslatesAutoresizingMaskIntoConstraints(false)
        row2.setTranslatesAutoresizingMaskIntoConstraints(false)
        row3.setTranslatesAutoresizingMaskIntoConstraints(false)
        row4.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        rowViews = [row1, row2, row3, row4]
        addConstraintsToInputView(keysContainerView, rowViews: rowViews)
        
        view.addConstraints([
            searchBar.al_top == view.al_top,
            searchBar.al_left == view.al_left,
            searchBar.al_right == view.al_right,
            searchBar.al_bottom == keysContainerView.al_top,

            keysContainerView.al_height == 210,
            keysContainerView.al_bottom == view.al_bottom,
            keysContainerView.al_left == view.al_left,
            keysContainerView.al_right == view.al_right
        ])
    }
    
    func createRowOfButtons(keys: [KeyboardKey], margin: CGFloat) -> UIView {
        var buttons = [KeyboardKeyButton]()
        var keyboardRowView = UIView(frame: CGRectZero)
        keyboardRowView.setTranslatesAutoresizingMaskIntoConstraints(false)

        for key in keys {
            let button = createButtonWithKey(key)
            button.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
            buttons.append(button)
            keyboardRowView.addSubview(button)
        }
        
        keyButtons.extend(buttons)
        addIndividualButtonConstraints(buttons, mainView: keyboardRowView, margin: margin/CGFloat(2))
        
        return keyboardRowView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    func createButtonWithKey(key: KeyboardKey) -> KeyboardKeyButton {
        return KeyboardKeyButton(key: key, width: keyWidth)
    }
    
    func didTapButton(sender: AnyObject?) {
        
        let button = sender as! KeyboardKeyButton
        var proxy = textProcessor.proxy
        
        button.selected = !button.selected
        
        var animationClass: CSAnimation.Type = CSAnimation.classForAnimationType("pop") as! CSAnimation.Type
        animationClass.performAnimationOnView(button, duration: 0.2, delay: 0.0)
        
        switch(button.key) {
        case .letter(let character):
            var str = String(character.rawValue)
            if lettercase! == .Lowercase {
                str = str.lowercaseString
            }
            proxy.insertText(str)
        case .modifier(.CapsLock):
            lettercase = (lettercase == .Lowercase) ? .Uppercase : .Lowercase
            
            for keyButton in keyButtons {
                keyButton.lettercase = lettercase
            }
        case .modifier(.Backspace):
            proxy.deleteBackward()
        case .modifier(.Space):
            proxy.insertText(" ")
        case .modifier(.Enter):
            proxy.insertText("\n")
        case .modifier(.GoToBrowse):
            dismissViewControllerAnimated(true, completion: nil)
        default:
            break
        }
    }
    
    func addIndividualButtonConstraints(buttons: [KeyboardKeyButton], mainView: UIView, margin: CGFloat){
        
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
                    let widthConstraint = button.al_width == keyWidth * 1.5 - 1
                    widthConstraint.priority = 1000
                    button.addConstraint(widthConstraint)
                }
                rightConstraint = button.al_right == mainView.al_right - rightMargin
            }
            else {
                let nextButton = buttons[index+1]
                rightConstraint = button.al_right == nextButton.al_left + 1
            }
            
            // Left Constraint
            if index == 0 {
                var leftMargin = margin

                if buttonIsModifierKey {
                    leftMargin = 0
                    let widthConstraint = button.al_width == keyWidth * 1.5 - 1
                    widthConstraint.priority = 1000
                    button.addConstraint(widthConstraint)
                } else {
                    button.addConstraint(button.al_width == keyWidth)
                }
                leftConstraint = button.al_left == mainView.al_left + leftMargin
            }
            else {
                let prevButton = buttons[index-1]
                var widthConstraint: NSLayoutConstraint!
                widthConstraint = button.al_width == keyWidth
                widthConstraint.priority = 900
                mainView.addConstraint(widthConstraint)
                
                leftConstraint = button.al_left == prevButton.al_right + 1
            }
            
            mainView.addConstraints([
                topConstraint, bottomConstraint,
                rightConstraint, leftConstraint
            ])
        }
    }
    
    func setupLastInputRow(keys: [KeyboardKey]) -> UIView {
        var buttons = [KeyboardKeyButton]()
        var keyboardRowView = UIView(frame: CGRectZero)
        keyboardRowView.setTranslatesAutoresizingMaskIntoConstraints(false)
        var prevButton: UIButton?
        
        for key in keys {
            var constraints = [NSLayoutConstraint]()
            let button = createButtonWithKey(key)
            button.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
            button.setTranslatesAutoresizingMaskIntoConstraints(false)
            buttons.append(button)
            keyboardRowView.addSubview(button)
            
            constraints += [
                button.al_top == keyboardRowView.al_top,
                button.al_bottom == keyboardRowView.al_bottom - 5
            ]
        
            switch(key) {
            case .modifier(.NumericKeypad):
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
        keyButtons.extend(buttons)
        
        return keyboardRowView
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
                var heightConstraint = rowView.al_height == firstRow.al_height
                
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

class KeyboardKeyButton: UIButton {
    let key: KeyboardKey
    let width: CGFloat
    
    var lettercase: Lettercase {
        didSet {
            setupKey()
        }
    }
    
    override var selected: Bool {
        didSet {
            switch(key) {
            case .modifier(.CapsLock):
                if selected {
                    lettercase = .Uppercase
                    layer.borderColor = UIColor(fromHexString: "#F9B341").CGColor
                } else {
                    lettercase = .Lowercase
                    layer.borderColor = UIColor(fromHexString: "#202020").CGColor
                }
            default:
                break
            }
        }
    }
    
    init(key: KeyboardKey, width: CGFloat) {
        self.key = key
        self.width = width
        lettercase = .Lowercase

        super.init(frame: CGRectZero)
        
        titleLabel?.font = UIFont(name: "OpenSans", size: 20)
        setTranslatesAutoresizingMaskIntoConstraints(false)
        backgroundColor = UIColor(fromHexString: "#2A2A2A")
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        layer.borderWidth = 2
        layer.cornerRadius = 5
        layer.borderColor = UIColor(fromHexString: "#202020").CGColor
        setupKey()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupKey() {
        switch(key) {
        case .letter(let character):
            var str = String(character.rawValue)
            if lettercase == .Lowercase {
                str = str.lowercaseString
            }
            setTitle(str, forState: .Normal)
        case .modifier(let modifier):
            switch(modifier) {
            case .Backspace:
                backgroundColor = UIColor.clearColor()
                setImage(UIImage(named: "Backspace"), forState: .Normal)
                imageView?.contentMode = .ScaleAspectFit
                imageEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
                break
            case .CapsLock:
                backgroundColor = UIColor.clearColor()
                setImage(UIImage(named: "CapsLock"), forState: .Normal)
                imageView?.contentMode = .ScaleAspectFit
                imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                
                break
            case .SwitchKeyboard:
                titleLabel!.font = NextKeyboardButtonFont
                setTitle("\u{f114}", forState: .Normal)
                backgroundColor = UIColor(fromHexString: "#2A2A2A")
                setTitleColor(UIColor.whiteColor(), forState: .Normal)
                addConstraints([
                    al_width == width + 15
                ])
                break
            case .NumericKeypad:
                imageView?.contentMode = .ScaleAspectFit
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
                setImage(UIImage(named: "NumericKeypad"), forState: .Normal)
                backgroundColor = UIColor.clearColor()
                addConstraints([
                    al_width == width + 15
                ])
                break
            case .GoToBrowse:
                imageView?.contentMode = .ScaleAspectFit
                setImage(UIImage(named: "IconWhite"), forState: .Normal)
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                addConstraint(al_width == width + 15)
                break
            case .Space:
                setTitle("Space".uppercaseString, forState: .Normal)
                titleLabel?.font = UIFont(name: "OpenSans", size: 14)
                break
            case .Enter:
                setTitle("Search".uppercaseString, forState: .Normal)
                setTitleColor(UIColor.blackColor(), forState: .Normal)
                titleLabel?.font = UIFont(name: "OpenSans", size: 14)
                backgroundColor = UIColor.whiteColor()
                break
            default:
                break
            }
        }
    }
}
