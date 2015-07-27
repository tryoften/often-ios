//
//  KeyboardKeyButton.swift
//  October
//
//  Created by Luc Succes on 7/16/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import UIKit

class KeyboardKeyButton: UIButton {
    weak var delegate: KeyboardKeyProtocol?
    
    var lettercase: Lettercase {
        didSet {
            setupKey()
        }
    }
    
    var key: KeyboardKey? {
        didSet {
            setupKey()
        }
    }

    var popupLabel: UILabel?
    var shape: Shape? {
        didSet {
            if oldValue != nil && shape == nil {
                oldValue?.removeFromSuperview()
            }
            self.redrawShape()
            updateColors()
        }
    }
    
    var background: KeyboardKeyBackground
    var popup: KeyboardKeyBackground?
    var connector: KeyboardConnector?

    var popupDirection: Direction?
    
    override var selected: Bool {
        didSet {
            if let key = key {
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
    }
    
    override var highlighted: Bool {
        didSet {
            if let key = key {
                switch(key) {
                case .special(.Hashtag):
                    background.backgroundColor = TealColor
                    break
                case .modifier(let modifier):
                    break
                default:
                    if highlighted {
                        background.backgroundColor = UIColor(fromHexString: "#3A3A3A")
                    } else {
                        background.backgroundColor = UIColor(fromHexString: "#2A2A2A")
                    }
                }
            }
        }
    }
    
    init() {
        lettercase = .Lowercase
        
        background = KeyboardKeyBackground(cornerRadius: 2, underOffset: 0)
        background.backgroundColor = UIColor(fromHexString: "#2A2A2A")
        
        super.init(frame: CGRectZero)
        insertSubview(background, belowSubview: imageView!)
        
        titleLabel?.font = UIFont(name: "OpenSans", size: 20)
        backgroundColor = UIColor.clearColor()
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        setupLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hidePopup() {
//        fatalError("init(coder:) has not been implemented")
    }
    
    func updateColors() {
        
    }
    
    func setupLayout() {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.background.frame = self.bounds
    }
    
    func redrawShape() {
        if let shape = self.shape {
            shape.removeFromSuperview()
            self.addSubview(shape)
            
            let pointOffset: CGFloat = 4
            let size = CGSizeMake(self.bounds.width - pointOffset - pointOffset, self.bounds.height - pointOffset - pointOffset)
            shape.frame = CGRectMake(
                CGFloat((self.bounds.width - size.width) / 2.0),
                CGFloat((self.bounds.height - size.height) / 2.0),
                size.width,
                size.height)
            
            shape.setNeedsLayout()
        }
    }
    
    func setupKey() {
        if let key = key {
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
                    background.backgroundColor = TealColor
                    setTitleColor(BlackColor, forState: .Normal)
                default:
                    break
                }
            case .modifier(let modifier):
                switch(modifier) {
                case .Backspace:
                    background.backgroundColor = UIColor.clearColor()
                    setImage(UIImage(named: "Backspace"), forState: .Normal)
                    imageView?.contentMode = .ScaleAspectFit
                    imageEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
                    break
                case .CapsLock:
                    background.backgroundColor = UIColor.clearColor()
                    setImage(UIImage(named: "CapsLock"), forState: .Normal)
                    setImage(UIImage(named: "CapsLockEnabled"), forState: .Selected)
                    imageView?.contentMode = .ScaleAspectFit
                    imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    break
                case .SwitchKeyboard:
                    titleLabel!.font = NextKeyboardButtonFont
                    setTitle("\u{f114}", forState: .Normal)
                    background.backgroundColor = UIColor(fromHexString: "#2A2A2A")
                    setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    break
                case .SpecialKeypad:
                    imageView?.contentMode = .ScaleAspectFit
                    imageEdgeInsets = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
                    setImage(UIImage(named: "NumericKeypad"), forState: .Normal)
                    background.backgroundColor = UIColor.clearColor()
                    break
                case .AlphabeticKeypad:
                    background.backgroundColor = UIColor.clearColor()
                    titleLabel?.font = UIFont(name: "OpenSans", size: 12)
                    setTitle("ABC", forState: .Normal)
                case .NextSpecialKeypad:
                    setTitle("#+=", forState: .Normal)
                case .GoToBrowse:
                    imageView?.contentMode = .ScaleAspectFit
                    setImage(UIImage(named: "IconWhite"), forState: .Normal)
                    imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                    break
                case .Space:
                    setTitle("Space".uppercaseString, forState: .Normal)
                    titleLabel?.font = UIFont(name: "OpenSans", size: 14)
                    break
                case .Enter:
                    setTitle("Enter".uppercaseString, forState: .Normal)
                    setTitleColor(UIColor.blackColor(), forState: .Normal)
                    titleLabel?.font = UIFont(name: "OpenSans", size: 14)
                    background.backgroundColor = UIColor.whiteColor()
                    break
                default:
                    break
                }
            default:
                break
            }
        }
    }
}

class Shape: UIView {
    var color: UIColor? {
        didSet {
            if let color = self.color {
                self.overflowCanvas.setNeedsDisplay()
            }
        }
    }
    
    // in case shapes draw out of bounds, we still want them to show
    var overflowCanvas: OverflowCanvas!
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        
        self.opaque = false
        self.clipsToBounds = false
        
        self.overflowCanvas = OverflowCanvas(shape: self)
        self.addSubview(self.overflowCanvas)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var oldBounds: CGRect?
    override func layoutSubviews() {
        if self.bounds.width == 0 || self.bounds.height == 0 {
            return
        }
        if oldBounds != nil && CGRectEqualToRect(self.bounds, oldBounds!) {
            return
        }
        oldBounds = self.bounds
        
        super.layoutSubviews()
        
        let overflowCanvasSizeRatio = CGFloat(1.25)
        let overflowCanvasSize = CGSizeMake(self.bounds.width * overflowCanvasSizeRatio, self.bounds.height * overflowCanvasSizeRatio)
        
        self.overflowCanvas.frame = CGRectMake(
            CGFloat((self.bounds.width - overflowCanvasSize.width) / 2.0),
            CGFloat((self.bounds.height - overflowCanvasSize.height) / 2.0),
            overflowCanvasSize.width,
            overflowCanvasSize.height)
        self.overflowCanvas.setNeedsDisplay()
    }
    
    func drawCall(color: UIColor) { /* override me! */ }
    
    class OverflowCanvas: UIView {
        unowned var shape: Shape
        
        init(shape: Shape) {
            self.shape = shape
            
            super.init(frame: CGRectZero)
            
            self.opaque = false
        }
        
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func drawRect(rect: CGRect) {
            let ctx = UIGraphicsGetCurrentContext()
            let csp = CGColorSpaceCreateDeviceRGB()
            
            CGContextSaveGState(ctx)
            
            let xOffset = (self.bounds.width - self.shape.bounds.width) / CGFloat(2)
            let yOffset = (self.bounds.height - self.shape.bounds.height) / CGFloat(2)
            CGContextTranslateCTM(ctx, xOffset, yOffset)
            
            self.shape.drawCall(shape.color != nil ? shape.color! : UIColor.blackColor())
            
            CGContextRestoreGState(ctx)
        }
    }
}