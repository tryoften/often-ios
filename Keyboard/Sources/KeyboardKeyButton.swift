////
////  KeyboardKeyButton.swift
////  October
////
////  Created by Luc Succes on 7/16/15.
////  Copyright (c) 2015 October Labs Inc. All rights reserved.
////

import UIKit

enum VibrancyType {
    case LightSpecial
    case DarkSpecial
    case DarkRegular
}

class KeyboardKeyButton: UIControl {
    
    weak var delegate: KeyboardKeyProtocol?
    var vibrancy: VibrancyType?
    var theme: KeyboardTheme
    
    var text: String {
        didSet {
            label.text = text
            label.frame = CGRectMake(labelInset, labelInset, bounds.width - labelInset * 2, bounds.height - labelInset * 2)
            redrawText()
        }
    }
    var key: KeyboardKey? {
        didSet {
            setupKey()
        }
    }
    
    var color: UIColor { didSet { updateColors() }}
    var underColor: UIColor { didSet { updateColors() }}
    var borderColor: UIColor { didSet { updateColors() }}
    var popupColor: UIColor { didSet { updateColors() }}
    var drawUnder: Bool { didSet { updateColors() }}
    var drawOver: Bool { didSet { updateColors() }}
    var drawBorder: Bool { didSet { updateColors() }}
    var underOffset: CGFloat { didSet { updateColors() }}
    var textColor: UIColor { didSet { updateColors() }}
    var labelInset: CGFloat = 0 {
        didSet {
            if oldValue != labelInset {
                label.frame = CGRectMake(labelInset, labelInset, bounds.width - labelInset * 2, bounds.height - labelInset * 2)
            }
        }
    }
    
    var shouldRasterize: Bool = false {
        didSet {
            for view in [displayView, borderView, underView] {
                view?.layer.shouldRasterize = shouldRasterize
                view?.layer.rasterizationScale = UIScreen.mainScreen().scale
            }
        }
    }
    
    var popupDirection: Direction?
    override var frame: CGRect { didSet { redrawText() }}
    override var enabled: Bool { didSet { updateColors() }}
    override var highlighted: Bool { didSet { updateColors() }}
    override var selected: Bool { didSet { updateModKeys() }}
  
    var label: UILabel
    var popupLabel: UILabel?
    var shape: Shape? {
        didSet {
            if oldValue != nil && shape == nil {
                oldValue?.removeFromSuperview()
            }
            redrawShape()
            updateColors()
        }
    }
    var iconView: UIImageView
    
    var background: KeyboardKeyBackground
    var popup: KeyboardKeyBackground?
    var connector: KeyboardConnector?
    
    var displayView: ShapeView
    var borderView: ShapeView?
    var underView: ShapeView?
    
    var shadowView: UIView
    var shadowLayer: CALayer
    
    init(theme: KeyboardTheme = DefaultTheme) {
        self.theme = theme
        
        displayView = ShapeView()
        underView = ShapeView()
        borderView = ShapeView()
        
        shadowLayer = CAShapeLayer()
        shadowView = UIView()
        
        label = UILabel()
        text = ""
        
        color = theme.keyboardKeyBackgroundColor
        underColor = theme.keyboardKeyUnderColor
        borderColor = theme.keyboardKeyBorderColor
        popupColor = theme.keyboardKeyPopupColor

        drawUnder = true
        drawOver = true
        drawBorder = false
        underOffset = 1
        
        background = KeyboardKeyBackground(cornerRadius: 5.0, underOffset: underOffset)
        
        textColor = theme.keyboardKeyTextColor
        popupDirection = nil
        
        iconView = UIImageView()
        iconView.contentMode = .ScaleAspectFit
        
        super.init(frame: CGRectZero)
        
        addSubview(shadowView)
        shadowView.layer.addSublayer(shadowLayer)
        
        addSubview(displayView)
        if let underView = underView {
            addSubview(underView)
        }
        if let borderView = borderView {
            addSubview(borderView)
        }
        
        addSubview(background)
        background.addSubview(label)
        background.addSubview(iconView)
        
        _ = {
            self.displayView.opaque = false
            self.underView?.opaque = false
            self.borderView?.opaque = false
            
            self.shadowLayer.shadowOpacity = 0.32
            self.shadowLayer.shadowRadius = 5
            self.shadowLayer.shadowOffset = CGSizeMake(0, 4)
            self.shadowLayer.backgroundColor = UIColor.blackColor().CGColor
            
            self.borderView?.lineWidth = 0.5
            self.borderView?.fillColor = UIColor.clearColor()
            
            self.label.textAlignment = NSTextAlignment.Center
            self.label.baselineAdjustment = UIBaselineAdjustment.AlignCenters
            self.label.font = UIFont(name: "OpenSans", size: 20)
            self.label.adjustsFontSizeToFitWidth = true
            self.label.minimumScaleFactor = 0.1
            self.label.userInteractionEnabled = false
            self.label.numberOfLines = 1
        }()
    }
    
        func setupKey() {
            if let key = key {
                label.font = UIFont(name: "OpenSans", size: 18.75)
                color = theme.keyboardKeyBackgroundColor
                textColor = theme.keyboardKeyTextColor
                underColor = theme.keyboardKeyUnderColor
                background.layer.borderColor = UIColor.clearColor().CGColor
                shape = nil
                iconView.image = nil
                text = ""
                background.layer.borderColor = ClearColor.CGColor

                switch(key) {
                case .letter(let character):
                    color = theme.keyboardKeyBackgroundColor
                    let str = String(character.rawValue)
                    text = str
                case .digit(let number):
                    text = String(number.rawValue)
                case .special(let character, _):
                    text = String(character.rawValue)
                case .modifier(let modifier, _):
                    switch(modifier) {
                    case .Backspace:
                        color = UIColor.clearColor()
                        underColor = UIColor.clearColor()
                        shape = BackspaceShape(color: theme.backspaceKeyTextColor)
                        break
                    case .CapsLock:
                        color = UIColor.clearColor()
                        underColor = UIColor.clearColor()
                        shape = ArrowShape(color: theme.keyboardKeyTextColor)
                        background.layer.cornerRadius = 5.0
                        background.layer.borderWidth = 1.8
                        background.layer.borderColor = UIColor.clearColor().CGColor
                        break
                    case .SwitchKeyboard:
                        label.font = NextKeyboardButtonFont
                        text = "\u{f114}"
                        color = theme.keyboardKeyBackgroundColor
                        textColor = theme.keyboardKeyTextColor
                        break
                    case .GoToBrowse:
                        iconView.image = UIImage(named: "IconWhite")!
                        iconView.contentMode = .ScaleAspectFill
                        break
                    case .Space:
                        text = "Space".uppercaseString
                        label.font = UIFont(name: "OpenSans-Semibold", size: 12)
                        break
                    case .Enter:
                        text = "Entr".uppercaseString
                        textColor = UIColor.blackColor()
                        color = theme.enterKeyBackgroundColor
                        label.font = UIFont(name: "OpenSans-Semibold", size: 12)
                        break
                    case .CallService:
                        text = "#"
                        label.font = UIFont(name: "OpenSans-Semibold", size: 16)
                        color = WhiteColor
                        textColor = BlackColor
                        background.userInteractionEnabled = true
                        background.layer.cornerRadius = 5.0
                        background.layer.borderWidth = 1.8
                        background.layer.borderColor = LightBlackColor.CGColor
                    default:
                        break
                    }
                case .changePage(let pageNumber, _):
                    switch(pageNumber) {
                    case 0:
                        text = "ABC"
                    case 1:
                        text = "123"
                    case 2:
                        text = "#+="
                    default:
                        break
                    }
                    underColor = UIColor.clearColor()
                    color = UIColor.clearColor()
                    label.font = UIFont(name: "OpenSans-Semibold", size: 12)
                    textColor = theme.keyboardKeyTextColor.colorWithAlphaComponent(0.74)
                }
                updateColors()
            }
    }

    required init?(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func setNeedsLayout() {
        return super.setNeedsLayout()
    }
    
    var oldBounds: CGRect?
    override func layoutSubviews() {
        layoutPopupIfNeeded()
        
        let boundingBox = (popup != nil ? CGRectUnion(bounds, popup!.frame) : bounds)
        
        if bounds.width == 0 || bounds.height == 0 {
            return
        }
        if oldBounds != nil && CGSizeEqualToSize(boundingBox.size, oldBounds!.size) {
            return
        }
        oldBounds = boundingBox
        
        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        background.frame = bounds
        label.frame = CGRectMake(labelInset, labelInset, bounds.width - labelInset * 2, bounds.height - labelInset * 2)
        
        displayView.frame = boundingBox
        shadowView.frame = boundingBox
        borderView?.frame = boundingBox
        underView?.frame = boundingBox
        iconView.frame = CGRectInset(boundingBox, 10, 10)

        CATransaction.commit()
        
        refreshViews()
    }
    
    func refreshViews() {
        refreshShapes()
        redrawText()
        redrawShape()
        updateColors()
    }
    
    func refreshShapes() {
        // TODO: dunno why this is necessary
        background.setNeedsLayout()
        background.layoutIfNeeded()
        popup?.layoutIfNeeded()
        connector?.layoutIfNeeded()
        
        let testPath = UIBezierPath()
        let edgePath = UIBezierPath()
        
        let unitSquare = CGRectMake(0, 0, 1, 1)
        
        // TODO: withUnder
        let addCurves = { (fromShape: KeyboardKeyBackground?, toPath: UIBezierPath, toEdgePaths: UIBezierPath) -> Void in
            if let shape = fromShape {
                let path = shape.fillPath
                let translatedUnitSquare = self.displayView.convertRect(unitSquare, fromView: shape)
                let transformFromShapeToView = CGAffineTransformMakeTranslation(translatedUnitSquare.origin.x, translatedUnitSquare.origin.y)
                path?.applyTransform(transformFromShapeToView)
                if path != nil { toPath.appendPath(path!) }
                if let edgePaths = shape.edgePaths {
                    for (_, anEdgePath) in edgePaths.enumerate() {
                        let editablePath = anEdgePath
                        editablePath.applyTransform(transformFromShapeToView)
                        toEdgePaths.appendPath(editablePath)
                    }
                }
            }
        }
        
        addCurves(popup, testPath, edgePath)
        addCurves(connector, testPath, edgePath)
        
        let shadowPath = UIBezierPath(CGPath: testPath.CGPath)
        
        addCurves(background, testPath, edgePath)
        
        let underPath = background.underPath
        let translatedUnitSquare = displayView.convertRect(unitSquare, fromView: background)
        let transformFromShapeToView = CGAffineTransformMakeTranslation(translatedUnitSquare.origin.x, translatedUnitSquare.origin.y)
        underPath?.applyTransform(transformFromShapeToView)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let _ = popup {
            shadowLayer.shadowPath = shadowPath.CGPath
        }
        
        underView?.curve = underPath
        displayView.curve = testPath
        borderView?.curve = edgePath
        
        if let borderLayer = borderView?.layer as? CAShapeLayer {
            borderLayer.strokeColor = UIColor.greenColor().CGColor
        }
        
        CATransaction.commit()
    }
    
    func layoutPopupIfNeeded() {
        if popup != nil && popupDirection == nil {
            shadowView.hidden = false
            borderView?.hidden = false
            
            popupDirection = Direction.Up
            
            layoutPopup(popupDirection!)
            configurePopup(popupDirection!)
            
            delegate?.willShowPopup(self, direction: popupDirection!)
        }
        else {
            shadowView.hidden = true
            borderView?.hidden = true
        }
    }
    
    func redrawText() {
    }
    
    func redrawShape() {
        if let shape = shape {
            text = ""
            shape.removeFromSuperview()
            addSubview(shape)
            
            let pointOffset: CGFloat = 4
            let size = CGSizeMake(bounds.width - pointOffset - pointOffset, bounds.height - pointOffset - pointOffset)
            shape.frame = CGRectMake(
                CGFloat((bounds.width - size.width) / 2.0),
                CGFloat((bounds.height - size.height) / 2.0),
                size.width,
                size.height)

            shape.setNeedsLayout()
        }
    }
    
    func updateModKeys() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if let key = key {
            switch(key) {
            case .modifier(let modifier, _):
                switch(modifier) {
                case .Backspace:
                    if selected {
                        shape?.color = TealColor
                    } else {
                        shape?.color = theme.backspaceKeyTextColor
                    }
                case .CapsLock:
                    if selected {
                        color = LightBlackColor
                        shape?.color = UIColor.whiteColor()
                    } else {
                        color = UIColor.clearColor()
                        background.layer.borderColor = LightBlackColor.CGColor
                        shape?.color = LightBlackColor
                    }
                case .Space:
                    if selected {
                        displayView.fillColor = theme.spaceKeyHighlightedBackgroundColor
                    } else {
                        displayView.fillColor = color
                    }
                case .CallService:
                    if selected {
                        displayView.fillColor = TealColor
                    } else {
                        displayView.fillColor = color
                    }
                case .Enter:
                    if selected {
                   displayView.fillColor = LightGrey
                    } else {
                        displayView.fillColor = color
                    }
                default:
                    break
                }
            default:
                break
            }
            
        }
        CATransaction.commit()
    }
    
    func updateColors() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        displayView.fillColor = color
        underView?.fillColor = underColor
        borderView?.strokeColor = borderColor
        label.textColor = textColor
        popupLabel?.textColor = textColor
        
        if popup != nil {
            displayView.fillColor = popupColor
        }
        
        CATransaction.commit()
    }
    
    func layoutPopup(dir: Direction) {
        assert(popup != nil, "popup not found")
        
        if let popup = popup {
            if let delegate = delegate {
                let frame = delegate.frameForPopup(self, direction: dir)
                popup.frame = frame
                popupLabel?.frame = popup.bounds
            }
            else {
                popup.frame = CGRectZero
                popup.center = center
            }
        }
    }
    
    func configurePopup(direction: Direction) {
        assert(popup != nil, "popup not found")
        
        background.attach(direction)
        popup!.attach(direction.opposite())
        
        let kv = background
        let p = popup!
        
        connector?.removeFromSuperview()
        connector = KeyboardConnector(cornerRadius: 5.0, underOffset: underOffset, start: kv, end: p, startConnectable: kv, endConnectable: p, startDirection: direction, endDirection: direction.opposite())
        connector!.layer.zPosition = -1
        addSubview(connector!)
    }
    
    func showPopup() {
        if popup == nil {
            layer.zPosition = 1000
            
            let popup = KeyboardKeyBackground(cornerRadius: 5.0, underOffset: underOffset)
            self.popup = popup
            addSubview(popup)
            
            let popupLabel = UILabel()
            popupLabel.textAlignment = label.textAlignment
            popupLabel.baselineAdjustment = label.baselineAdjustment
            popupLabel.font = UIFont(name: "OpenSans", size: 44)
            popupLabel.adjustsFontSizeToFitWidth = label.adjustsFontSizeToFitWidth
            popupLabel.minimumScaleFactor = CGFloat(0.1)
            popupLabel.userInteractionEnabled = false
            popupLabel.numberOfLines = 1
            popupLabel.frame = popup.bounds
            popupLabel.text = label.text
            popup.addSubview(popupLabel)
            self.popupLabel = popupLabel
            
            label.hidden = true
        }
    }
    
    func hidePopup() {
        if popup != nil {
            delegate?.willHidePopup(self)
            
            popupLabel?.removeFromSuperview()
            popupLabel = nil
            
            connector?.removeFromSuperview()
            connector = nil
            
            popup?.removeFromSuperview()
            popup = nil
            
            label.hidden = false
            background.attach(nil)
            
            layer.zPosition = 0
            
            popupDirection = nil
        }
    }
}
