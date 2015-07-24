//
//  KeyboardKeyButton.swift
//  October
//
//  Created by Luc Succes on 7/16/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import UIKit

class KeyboardKeyButton: UIButton {
    let key: KeyboardKey
    let width: CGFloat
    let backgroundView: UIView
    
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
                } else {
                    lettercase = .Lowercase
                }
            default:
                break
            }
        }
    }
    
    override var highlighted: Bool {
        didSet {
            switch(key) {
            case .special(.Hashtag):
                break
            case .modifier(let modifier):
                break
            default:
                if highlighted {
                    backgroundView.backgroundColor = UIColor(fromHexString: "#3A3A3A")
                } else {
                    backgroundView.backgroundColor = UIColor(fromHexString: "#2A2A2A")
                }
            }
        }
    }
    
    init(key: KeyboardKey, width: CGFloat) {
        self.key = key
        self.width = width
        lettercase = .Lowercase
        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(fromHexString: "#2A2A2A")
        backgroundView.userInteractionEnabled = false
        backgroundView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        super.init(frame: CGRectZero)
        insertSubview(backgroundView, belowSubview: imageView!)
        
        titleLabel?.font = UIFont(name: "OpenSans", size: 20)
        setTranslatesAutoresizingMaskIntoConstraints(false)
        backgroundColor = UIColor.clearColor()
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backgroundView.layer.cornerRadius = 2
        setupKey()
        setupLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            al_height >= 29.5,

            backgroundView.al_top == al_top + 3,
            backgroundView.al_bottom == al_bottom - 3,
            backgroundView.al_left == al_left + 3,
            backgroundView.al_right == al_right - 3
        ])
    }

    func setupKey() {
        switch(key) {
        case .letter(let character):
            var str = String(character.rawValue)
            if lettercase == .Lowercase {
                str = str.lowercaseString
            }
            setTitle(str, forState: .Normal)
        case .digit(let number):
            setTitle(String(number.rawValue), forState: .Normal)
        case .special(let character):
            setTitle(String(character.rawValue), forState: .Normal)
            switch(character) {
            case .Hashtag:
                backgroundView.backgroundColor = TealColor
                setTitleColor(BlackColor, forState: .Normal)
            default:
                break
            }
        case .modifier(let modifier):
            switch(modifier) {
            case .Backspace:
                backgroundView.backgroundColor = UIColor.clearColor()
                setImage(UIImage(named: "Backspace"), forState: .Normal)
                imageView?.contentMode = .ScaleAspectFit
                imageEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
                break
            case .CapsLock:
                backgroundView.backgroundColor = UIColor.clearColor()
                setImage(UIImage(named: "CapsLock"), forState: .Normal)
                setImage(UIImage(named: "CapsLockEnabled"), forState: .Selected)
                imageView?.contentMode = .ScaleAspectFit
                imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                
                break
            case .SwitchKeyboard:
                titleLabel!.font = NextKeyboardButtonFont
                setTitle("\u{f114}", forState: .Normal)
                backgroundView.backgroundColor = UIColor(fromHexString: "#2A2A2A")
                setTitleColor(UIColor.whiteColor(), forState: .Normal)
                addConstraints([
                    al_width == width + 5
                ])
                break
            case .SpecialKeypad:
                imageView?.contentMode = .ScaleAspectFit
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
                setImage(UIImage(named: "NumericKeypad"), forState: .Normal)
                backgroundView.backgroundColor = UIColor.clearColor()
                addConstraints([
                    al_width == width + 5
                ])
                break
            case .AlphabeticKeypad:
                backgroundView.backgroundColor = UIColor.clearColor()
                titleLabel?.font = UIFont(name: "OpenSans", size: 12)
                setTitle("ABC", forState: .Normal)
            case .NextSpecialKeypad:
                setTitle("#+=", forState: .Normal)
            case .GoToBrowse:
                imageView?.contentMode = .ScaleAspectFit
                setImage(UIImage(named: "IconWhite"), forState: .Normal)
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                addConstraint(al_width == width + 5)
                break
            case .Space:
                setTitle("Space".uppercaseString, forState: .Normal)
                titleLabel?.font = UIFont(name: "OpenSans", size: 14)
                break
            case .Enter:
                setTitle("Enter".uppercaseString, forState: .Normal)
                setTitleColor(UIColor.blackColor(), forState: .Normal)
                titleLabel?.font = UIFont(name: "OpenSans", size: 14)
                backgroundView.backgroundColor = UIColor.whiteColor()
                break
            default:
                break
            }
        default:
            break
        }
        
    }
}