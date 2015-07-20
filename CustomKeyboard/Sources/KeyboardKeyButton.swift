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
    
    override var highlighted: Bool {
        didSet {
            switch(key) {
            case .modifier(let modifier):
                break
            default:
                if highlighted {
                    backgroundColor = UIColor(fromHexString: "#3A3A3A")
                } else {
                    backgroundColor = UIColor(fromHexString: "#2A2A2A")
                }
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
        layer.borderWidth = 3
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
        case .digit(let number):
            setTitle(String(number.rawValue), forState: .Normal)
        case .special(let character):
            setTitle(String(character.rawValue), forState: .Normal)
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
                    al_width == width + 5
                    ])
                break
            case .SpecialKeypad:
                imageView?.contentMode = .ScaleAspectFit
                imageEdgeInsets = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
                setImage(UIImage(named: "NumericKeypad"), forState: .Normal)
                backgroundColor = UIColor.clearColor()
                addConstraints([
                    al_width == width + 5
                    ])
                break
            case .AlphabeticKeypad:
                backgroundColor = UIColor.clearColor()
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
                backgroundColor = UIColor.whiteColor()
                break
            default:
                break
            }
        default:
            break
        }
        
    }
}