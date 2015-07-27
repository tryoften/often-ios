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
    
    var label: UILabel
    
    var text: String {
        didSet {
            self.label.text = text
            self.label.frame = CGRectMake(self.labelInset, self.labelInset, self.bounds.width - self.labelInset * 2, self.bounds.height - self.labelInset * 2)
        }
    }
    var color: UIColor
    var downColor: UIColor = UIColor(fromHexString: "#121314")
    var downTextColor: UIColor = UIColor.whiteColor()
    var popupColor: UIColor = UIColor(fromHexString: "#121314")
    var underColor: UIColor { didSet { updateColors() }}
    var borderColor: UIColor { didSet { updateColors() }}
    var textColor: UIColor
    var labelInset: CGFloat = 0 {
        didSet {
            if oldValue != labelInset {
                self.label.frame = CGRectMake(self.labelInset, self.labelInset, self.bounds.width - self.labelInset * 2, self.bounds.height - self.labelInset * 2)
            }
        }
    }
    
    var background: KeyboardKeyBackground
    var popup: KeyboardKeyBackground?
    var connector: KeyboardConnector?

    var popupDirection: Direction?
    var displayView: ShapeView
    var borderView: ShapeView
    var underView: ShapeView
    
    override var enabled: Bool { didSet { updateColors() }}
    override var selected: Bool {
        didSet {
            updateColors()
        }
    }

    override var highlighted: Bool {
        didSet {
            updateColors()
            if let key = key {
                switch(key) {
                case .modifier(.CallService, let pageId):
                    background.backgroundColor = TealColor
                    break
                case .modifier(let modifier, let pageId):
                    break
                default:
                    break
//                    if highlighted {
//                        background.backgroundColor = UIColor(fromHexString: "#3A3A3A")
//                    } else {
//                        background.backgroundColor = UIColor(fromHexString: "#2A2A2A")
//                    }
                }
            }
        }
    }
    
    init() {
        lettercase = .Lowercase
        
        color = UIColor(fromHexString: "#2A2A2A")
        background = KeyboardKeyBackground(cornerRadius: 2, underOffset: 0)
        background.backgroundColor = color
        popupColor = color
        underColor = color
        borderColor = color
        
        displayView = ShapeView()
        borderView = ShapeView()
        underView = ShapeView()
        
        label = UILabel()
        text = ""
        textColor = UIColor.whiteColor()

        
        super.init(frame: CGRectZero)
        addSubview(borderView)
        addSubview(underView)
        addSubview(background)
        background.addSubview(label)
        
        borderView.lineWidth = CGFloat(0.5)
        borderView.fillColor = UIColor.clearColor()
        
        label.font = UIFont(name: "OpenSans", size: 20)
        label.textColor = textColor
        
        label.textAlignment = NSTextAlignment.Center
        label.baselineAdjustment = UIBaselineAdjustment.AlignCenters
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = CGFloat(0.1)
        label.userInteractionEnabled = false
        label.numberOfLines = 1
        
        backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setTitle(title: String?, forState state: UIControlState) {
        if let title = title {
            text = title
        }
    }
    
    func refreshViews() {
        self.refreshShapes()
        self.redrawShape()
        self.updateColors()
    }
    
    func refreshShapes() {
        // TODO: dunno why this is necessary
        self.background.setNeedsLayout()
        
        self.background.layoutIfNeeded()
        self.popup?.layoutIfNeeded()
        self.connector?.layoutIfNeeded()
        
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
        
        addCurves(self.popup, testPath, edgePath)
        addCurves(self.connector, testPath, edgePath)
        
        var shadowPath = UIBezierPath(CGPath: testPath.CGPath)
        
        addCurves(self.background, testPath, edgePath)
        
        var underPath = self.background.underPath
        var translatedUnitSquare = self.displayView.convertRect(unitSquare, fromView: self.background)
        let transformFromShapeToView = CGAffineTransformMakeTranslation(translatedUnitSquare.origin.x, translatedUnitSquare.origin.y)
        underPath?.applyTransform(transformFromShapeToView)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        
        self.underView.curve = underPath
        self.displayView.curve = testPath
        self.borderView.curve = edgePath
        
        if let borderLayer = self.borderView.layer as? CAShapeLayer {
            borderLayer.strokeColor = UIColor.greenColor().CGColor
        }
        
        CATransaction.commit()
    }
    
    func layoutPopupIfNeeded() {
        if self.popup != nil && self.popupDirection == nil {
            
            self.popupDirection = Direction.Up
            
            self.layoutPopup(self.popupDirection!)
            self.configurePopup(self.popupDirection!)
            
            self.delegate?.willShowPopup(self, direction: self.popupDirection!)
        } else {
            self.borderView.hidden = true
        }
    }
    
    func layoutPopup(dir: Direction) {
        assert(self.popup != nil, "popup not found")
        
        if let popup = self.popup {
            if let delegate = self.delegate {
                let frame = delegate.frameForPopup(self, direction: dir)
                popup.frame = frame
                popupLabel?.frame = popup.bounds
            }
            else {
                popup.frame = CGRectZero
                popup.center = self.center
            }
        }
    }
    
    func configurePopup(direction: Direction) {
        assert(self.popup != nil, "popup not found")
        
        self.background.attach(direction)
        self.popup!.attach(direction.opposite())
        
        let kv = self.background
        let p = self.popup!
        
        self.connector?.removeFromSuperview()
        self.connector = KeyboardConnector(cornerRadius: 4, underOffset: 0, start: kv, end: p, startConnectable: kv, endConnectable: p, startDirection: direction, endDirection: direction.opposite())
        self.connector!.layer.zPosition = -1
        self.addSubview(self.connector!)
        
        //        self.drawBorder = true
        
        if direction == Direction.Up {
            //            self.popup!.drawUnder = false
            //            self.connector!.drawUnder = false
        }
    }
    
    func showPopup() {
        if self.popup == nil {
            self.layer.zPosition = 1000
            
            var popup = KeyboardKeyBackground(cornerRadius: 9.0, underOffset: 0)
            self.popup = popup
            self.addSubview(popup)
            
            var popupLabel = UILabel()
            popupLabel.textAlignment = self.label.textAlignment
            popupLabel.baselineAdjustment = self.label.baselineAdjustment
            popupLabel.font = self.label.font.fontWithSize(22 * 2)
            popupLabel.adjustsFontSizeToFitWidth = self.label.adjustsFontSizeToFitWidth
            popupLabel.minimumScaleFactor = CGFloat(0.1)
            popupLabel.userInteractionEnabled = false
            popupLabel.numberOfLines = 1
            popupLabel.frame = popup.bounds
            popupLabel.text = self.label.text
            popup.addSubview(popupLabel)
            self.popupLabel = popupLabel
            
            self.label.hidden = true
        }
    }
    
    func hidePopup() {
        if self.popup != nil {
            self.delegate?.willHidePopup(self)
            
            self.popupLabel?.removeFromSuperview()
            self.popupLabel = nil
            
            self.connector?.removeFromSuperview()
            self.connector = nil
            
            self.popup?.removeFromSuperview()
            self.popup = nil
            
            self.label.hidden = false
            self.background.attach(nil)
            
            self.layer.zPosition = 0
            
            self.popupDirection = nil
        }
    }
    
    func updateColors() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let switchColors = self.highlighted || self.selected
        
        if switchColors {
            let downColor = color
            self.displayView.fillColor = downColor
            self.underView.fillColor = downColor
            
            self.borderView.strokeColor = downColor

            
            let downTextColor = self.downTextColor
            self.label.textColor = downTextColor
            self.popupLabel?.textColor = downTextColor
            self.shape?.color = downTextColor
        }
        else {
            self.displayView.fillColor = self.color
            
            self.underView.fillColor = self.underColor
            
            self.borderView.strokeColor = self.borderColor
            
            self.label.textColor = self.textColor
            self.popupLabel?.textColor = self.textColor
            self.shape?.color = self.textColor
        }
        
        if self.popup != nil {
            self.displayView.fillColor = color
        }
        
        CATransaction.commit()
    }
    
    var oldBounds: CGRect?
    override func layoutSubviews() {
        self.layoutPopupIfNeeded()
        
        var boundingBox = (self.popup != nil ? CGRectUnion(self.bounds, self.popup!.frame) : self.bounds)
        
        if self.bounds.width == 0 || self.bounds.height == 0 {
            return
        }
        if oldBounds != nil && CGSizeEqualToSize(boundingBox.size, oldBounds!.size) {
            return
        }
        oldBounds = boundingBox
        
        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        self.background.frame = self.bounds
        self.label.frame = CGRectMake(self.labelInset, self.labelInset, self.bounds.width - self.labelInset * 2, self.bounds.height - self.labelInset * 2)
        
        displayView.frame = boundingBox
        borderView.frame = boundingBox
        underView.frame = boundingBox
        
        CATransaction.commit()
        
        self.refreshViews()
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
                color = UIColor(fromHexString: "#2A2A2A")
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
                    color = TealColor
                    textColor = BlackColor
                default:
                    break
                }
            case .modifier(let modifier, let pageId):
                switch(modifier) {
                case .Backspace:
                    color = UIColor.clearColor()
                    setImage(UIImage(named: "Backspace"), forState: .Normal)
                    imageView?.contentMode = .ScaleAspectFit
                    imageEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
                    break
                case .CapsLock:
                    color = UIColor.clearColor()
                    setImage(UIImage(named: "CapsLock"), forState: .Normal)
                    setImage(UIImage(named: "CapsLockEnabled"), forState: .Selected)
                    imageView?.contentMode = .ScaleAspectFit
                    imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    break
                case .SwitchKeyboard:
                    label.font = NextKeyboardButtonFont
                    text = "\u{f114}"
                    color = UIColor(fromHexString: "#2A2A2A")
                    textColor = UIColor.whiteColor()
                    break
                case .GoToBrowse:
                    imageView?.contentMode = .ScaleAspectFit
                    setImage(UIImage(named: "IconWhite"), forState: .Normal)
                    imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                    break
                case .Space:
                    text = "Space".uppercaseString
                    label.font = UIFont(name: "OpenSans", size: 14)
                    break
                case .Enter:
                    text = "Enter".uppercaseString
                    textColor = UIColor.blackColor()
                    label.font = UIFont(name: "OpenSans", size: 14)
                    background.backgroundColor = UIColor.whiteColor()
                    break
                default:
                    break
                }
            case .changePage(let pageNumber, let pageId):
                switch(pageNumber) {
                case 0:
                    setTitle("ABC", forState: .Normal)
                case 1:
                    setTitle("123", forState: .Normal)
                case 2:
                    setTitle("#+=", forState: .Normal)
                default:
                    break
                }

                color = UIColor.clearColor()
                label.font = UIFont(name: "OpenSans", size: 9)
                textColor = UIColor.whiteColor().colorWithAlphaComponent(0.74)
            default:
                break
            }
            updateColors()
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

class ShapeView: UIView {
    
    var shapeLayer: CAShapeLayer?
    
    override class func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }
    
    var curve: UIBezierPath? {
        didSet {
            if let layer = self.shapeLayer {
                layer.path = curve?.CGPath
            }
            else {
                self.setNeedsDisplay()
            }
        }
    }
    
    var fillColor: UIColor? {
        didSet {
            if let layer = self.shapeLayer {
                layer.fillColor = fillColor?.CGColor
            }
            else {
                self.setNeedsDisplay()
            }
        }
    }
    
    var strokeColor: UIColor? {
        didSet {
            if let layer = self.shapeLayer {
                layer.strokeColor = strokeColor?.CGColor
            }
            else {
                self.setNeedsDisplay()
            }
        }
    }
    
    var lineWidth: CGFloat? {
        didSet {
            if let layer = self.shapeLayer {
                if let lineWidth = self.lineWidth {
                    layer.lineWidth = lineWidth
                }
            }
            else {
                self.setNeedsDisplay()
            }
        }
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.shapeLayer = self.layer as? CAShapeLayer
        
        // optimization: off by default to ensure quick mode transitions; re-enable during rotations
        //self.layer.shouldRasterize = true
        //self.layer.rasterizationScale = UIScreen.mainScreen().scale
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawCall(rect:CGRect) {
        if self.shapeLayer == nil {
            if let curve = self.curve {
                if let lineWidth = self.lineWidth {
                    curve.lineWidth = lineWidth
                }
                
                if let fillColor = self.fillColor {
                    fillColor.setFill()
                    curve.fill()
                }
                
                if let strokeColor = self.strokeColor {
                    strokeColor.setStroke()
                    curve.stroke()
                }
            }
        }
    }
}