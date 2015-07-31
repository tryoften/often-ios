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
    var shiftSelected: Bool { didSet { updateModKeys() }}
    var spaceBarSelected: Bool { didSet { updateModKeys() }}
    var callKeySelected: Bool { didSet { updateModKeys() }}
    var enterKeySelected: Bool { didSet { updateModKeys() }}
    
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
    
    init(vibrancy optionalVibrancy: VibrancyType? = .LightSpecial) {
        vibrancy = optionalVibrancy
        
        displayView = ShapeView()
        underView = ShapeView()
        borderView = ShapeView()
        
        shadowLayer = CAShapeLayer()
        shadowView = UIView()
        
        label = UILabel()
        text = ""
        
        color = UIColor(fromHexString: "#2A2A2A")
        underColor = UIColor(fromHexString: "#2A2A2A")
        borderColor = UIColor(fromHexString: "#2A2A2A")
        popupColor = UIColor(fromHexString: "#121314")
        drawUnder = true
        drawOver = true
        drawBorder = false
        shiftSelected = false
        spaceBarSelected = false
        callKeySelected = false
        enterKeySelected = false
        underOffset = 1
        
        background = KeyboardKeyBackground(cornerRadius: 2, underOffset: underOffset)
        
        textColor = UIColor.whiteColor()
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
        
        let setupViews: Void = {
            self.displayView.opaque = false
            self.underView?.opaque = false
            self.borderView?.opaque = false
            
            self.shadowLayer.shadowOpacity = Float(0.2)
            self.shadowLayer.shadowRadius = 4
            self.shadowLayer.shadowOffset = CGSizeMake(0, 3)
            
            self.borderView?.lineWidth = CGFloat(0.5)
            self.borderView?.fillColor = UIColor.clearColor()
            
            self.label.textAlignment = NSTextAlignment.Center
            self.label.baselineAdjustment = UIBaselineAdjustment.AlignCenters
            self.label.font = UIFont(name: "OpenSans", size: 20)
            self.label.adjustsFontSizeToFitWidth = true
            self.label.minimumScaleFactor = CGFloat(0.1)
            self.label.userInteractionEnabled = false
            self.label.numberOfLines = 1
            }()
    }
    
        func setupKey() {
            if let key = key {
                label.font = UIFont(name: "OpenSans", size: 20)
                color = UIColor(fromHexString: "#2A2A2A")
                textColor = UIColor.whiteColor()
                underColor = UIColor(fromHexString: "#2A2A2A")
                iconView.image = nil
                text = ""

                switch(key) {
                case .letter(let character):
                    color = UIColor(fromHexString: "#2A2A2A")
                    var str = String(character.rawValue)
                    text = str.lowercaseString
                case .digit(let number):
                    text = String(number.rawValue)
                case .special(let character, let pageId):
                    text = String(character.rawValue)
                case .modifier(let modifier, let pageId):
                    switch(modifier) {
                    case .Backspace:
                        color = UIColor(fromHexString: "#202020")
                        underColor = UIColor(fromHexString: "#202020")
                        iconView.image = UIImage(named: "Backspace")!
                        break
                    case .CapsLock:
                        color = UIColor(fromHexString: "#202020")
                        underColor = UIColor(fromHexString: "#202020")
                        iconView.image = UIImage(named: "CapsLock")!
                        background.layer.cornerRadius = 2.0
                        background.layer.borderWidth = 1.0
                        background.layer.borderColor = color.CGColor
                        break
                    case .SwitchKeyboard:
                        label.font = NextKeyboardButtonFont
                        text = "\u{f114}"
                        color = UIColor(fromHexString: "#2A2A2A")
                        textColor = UIColor.whiteColor()
                        break
                    case .GoToBrowse:
                        iconView.image = UIImage(named: "IconWhite")!
                        break
                    case .Space:
                        text = "Space".uppercaseString
                        label.font = UIFont(name: "OpenSans", size: 14)
                        break
                    case .Enter:
                        text = "Enter".uppercaseString
                        textColor = UIColor.blackColor()
                        color = UIColor.whiteColor()
                        label.font = UIFont(name: "OpenSans", size: 11)
                        break
                    case .CallService:
                        text = "#"
                        color = WhiteColor
                        textColor = BlackColor
                    default:
                        break
                    }
                case .changePage(let pageNumber, let pageId):
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
                    underColor = UIColor(fromHexString: "#202020")
                    color = UIColor(fromHexString: "#202020")
                    label.font = UIFont(name: "OpenSans", size: 11)
                    textColor = UIColor.whiteColor().colorWithAlphaComponent(0.74)
                default:
                    break
                }
                updateColors()
            }
    }

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func setNeedsLayout() {
        return super.setNeedsLayout()
    }
    
    var oldBounds: CGRect?
    override func layoutSubviews() {
        layoutPopupIfNeeded()
        
        var boundingBox = (popup != nil ? CGRectUnion(bounds, popup!.frame) : bounds)
        
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
        
        var testPath = UIBezierPath()
        var edgePath = UIBezierPath()
        
        let unitSquare = CGRectMake(0, 0, 1, 1)
        
        // TODO: withUnder
        let addCurves = { (fromShape: KeyboardKeyBackground?, toPath: UIBezierPath, toEdgePaths: UIBezierPath) -> Void in
            if let shape = fromShape {
                var path = shape.fillPath
                var translatedUnitSquare = self.displayView.convertRect(unitSquare, fromView: shape)
                let transformFromShapeToView = CGAffineTransformMakeTranslation(translatedUnitSquare.origin.x, translatedUnitSquare.origin.y)
                path?.applyTransform(transformFromShapeToView)
                if path != nil { toPath.appendPath(path!) }
                if let edgePaths = shape.edgePaths {
                    for (e, anEdgePath) in enumerate(edgePaths) {
                        var editablePath = anEdgePath
                        editablePath.applyTransform(transformFromShapeToView)
                        toEdgePaths.appendPath(editablePath)
                    }
                }
            }
        }
        
        addCurves(popup, testPath, edgePath)
        addCurves(connector, testPath, edgePath)
        
        var shadowPath = UIBezierPath(CGPath: testPath.CGPath)
        
        addCurves(background, testPath, edgePath)
        
        var underPath = background.underPath
        var translatedUnitSquare = displayView.convertRect(unitSquare, fromView: background)
        let transformFromShapeToView = CGAffineTransformMakeTranslation(translatedUnitSquare.origin.x, translatedUnitSquare.origin.y)
        underPath?.applyTransform(transformFromShapeToView)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let popup = popup {
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
            case .modifier(let modifier, let pageId):
                switch(modifier) {
                case .CapsLock:
                    if shiftSelected {
                        iconView.image = UIImage(named: "CapsLockEnabled")
                        borderView?.strokeColor = TealColor
                        background.layer.borderColor = TealColor.CGColor
                    } else {
                        iconView.image = UIImage(named: "CapsLock")
                        background.layer.borderColor = color.CGColor
                    }
                case .Space:
                    if spaceBarSelected {
                        displayView.fillColor = BlackColor
                    } else {
                        displayView.fillColor = color
                    }
                case .CallService:
                    if callKeySelected {
                        displayView.fillColor = TealColor
                    } else {
                        displayView.fillColor = color
                    }
                case .Enter:
                    if enterKeySelected {
                        displayView.fillColor = LightGrey
                    } else {
                        displayView.fillColor = color
                    }
                    break
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
        shape?.color = textColor
        
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
        connector = KeyboardConnector(cornerRadius: 4, underOffset: underOffset, start: kv, end: p, startConnectable: kv, endConnectable: p, startDirection: direction, endDirection: direction.opposite())
        connector!.layer.zPosition = -1
        addSubview(connector!)
        
        //        self.drawBorder = true
        
        if direction == Direction.Up {
            //            self.popup!.drawUnder = false
            //            self.connector!.drawUnder = false
        }
    }
    
    func showPopup() {
        if popup == nil {
            layer.zPosition = 1000
            
            var popup = KeyboardKeyBackground(cornerRadius: 4.0, underOffset: underOffset)
            self.popup = popup
            addSubview(popup)
            
            var popupLabel = UILabel()
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
