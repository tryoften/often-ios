//
//  TouchRecognizerView.swift
//  Surf
//
//  Created by Kervins Valcourt on 7/22/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class TouchRecognizerView: UIView {
    
    var touchToView: [UITouch: UIView]
    var togglePanelButton: UIButton
    var collapsed: Bool {
        didSet {
            togglePanelButton.hidden = !collapsed
        }
    }
    
    override init(frame: CGRect) {
        touchToView = [:]
        togglePanelButton = UIButton()
        togglePanelButton.imageView?.contentMode = .ScaleAspectFit
        togglePanelButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        togglePanelButton.backgroundColor = UIColor.whiteColor()
        togglePanelButton.hidden = true
        togglePanelButton.userInteractionEnabled = true
        togglePanelButton.layer.zPosition = 999
        togglePanelButton.layer.cornerRadius = 2.0
        togglePanelButton.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.19).CGColor
        togglePanelButton.layer.shadowOpacity = 1.0
        togglePanelButton.layer.shadowOffset = CGSizeMake(0, 0)
        togglePanelButton.layer.shadowRadius = 2.0

        collapsed = false
        
        super.init(frame: frame)
        
        addSubview(togglePanelButton)
        contentMode = .Redraw
        multipleTouchEnabled = true
        userInteractionEnabled = true
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if frame.size.width == 0 || frame.size.height == 0 {
            return
        }
        
        var togglePanelButtonFrame = frame
        togglePanelButtonFrame.origin.y = 0
        togglePanelButtonFrame.size.height = 30
        togglePanelButton.frame = togglePanelButtonFrame
        
        togglePanelButton.setImage(StyleKit.imageOfArrowheadup(frame: togglePanelButtonFrame, color: DefaultTheme.keyboardKeyTextColor, borderWidth: 2.0), forState: .Normal)
        togglePanelButton.setImage(StyleKit.imageOfArrowheadup(frame: togglePanelButtonFrame, color: TealColor, borderWidth: 2.0), forState: .Selected)
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView? {
        if self.hidden || self.alpha == 0 || !self.userInteractionEnabled {
            return nil
        }
        else {
            return (CGRectContainsPoint(self.bounds, point) ? self : nil)
        }
    }
    
    func handleControl(view: UIView?, controlEvent: UIControlEvents) {
        if let control = view as? UIControl {
            let targets = control.allTargets()
            for target in targets {
                if var actions = control.actionsForTarget(target, forControlEvent: controlEvent) {
                    for action in actions {
                        if let selectorString = action as? String {
                            let selector = Selector(selectorString)
                            control.sendAction(selector, to: target, forEvent: nil)
                        }
                    }
                }
            }
        }
    }
    
    // TODO: there's a bit of "stickiness" to Apple's implementation
    func findNearestView(position: CGPoint) -> UIView? {
        if !bounds.contains(position) {
            return nil
        }
        
        var closest: (UIView, CGFloat)? = nil
        
        for anyView in self.subviews {
            if let view = anyView as? UIView {
                if view.hidden {
                    continue
                }
                
                view.alpha = 1
                
                let distance = distanceBetween(view.frame, point: position)
                
                if closest != nil {
                    if distance < closest!.1 {
                        closest = (view, distance)
                    }
                }
                else {
                    closest = (view, distance)
                }
            }
        }
    
        if closest != nil {
            return closest!.0
        }
        else {
            return nil
        }
    }
    
    // http://stackoverflow.com/questions/3552108/finding-closest-object-to-cgpoint b/c I'm lazy
    func distanceBetween(rect: CGRect, point: CGPoint) -> CGFloat {
        if CGRectContainsPoint(rect, point) {
            return 0
        }
        
        var closest = rect.origin
        
        if (rect.origin.x + rect.size.width < point.x) {
            closest.x += rect.size.width
        }
        else if (point.x > rect.origin.x) {
            closest.x = point.x
        }
        if (rect.origin.y + rect.size.height < point.y) {
            closest.y += rect.size.height
        }
        else if (point.y > rect.origin.y) {
            closest.y = point.y
        }
        
        let a = pow(Double(closest.y - point.y), 2)
        let b = pow(Double(closest.x - point.x), 2)
        return CGFloat(sqrt(a + b));
    }
    
    // reset tracked views without cancelling current touch
    func resetTrackedViews() {
        for view in self.touchToView.values {
            self.handleControl(view, controlEvent: .TouchCancel)
        }
        self.touchToView.removeAll(keepCapacity: true)
    }
    
    func ownView(newTouch: UITouch, viewToOwn: UIView?) -> Bool {
        var foundView = false
        
        if viewToOwn != nil {
            for (touch, view) in self.touchToView {
                if viewToOwn == view {
                    if touch == newTouch {
                        break
                    }
                    else {
                        self.touchToView[touch] = nil
                        foundView = true
                    }
                    break
                }
            }
        }
        
        self.touchToView[newTouch] = viewToOwn
        return foundView
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for obj in touches {
            if let touch = obj as? UITouch {
                let position = touch.locationInView(self)
                var view = findNearestView(position)
                
                var viewChangedOwnership = self.ownView(touch, viewToOwn: view)
                
                if !viewChangedOwnership {
                    self.handleControl(view, controlEvent: .TouchDown)
                    
                    if touch.tapCount > 1 {
                        // two events, I think this is the correct behavior but I have not tested with an actual UIControl
                        self.handleControl(view, controlEvent: .TouchDownRepeat)
                    }
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for obj in touches {
            if let touch = obj as? UITouch {
                let position = touch.locationInView(self)
                
                var oldView = self.touchToView[touch]
                var newView = findNearestView(position)
                
                if oldView != newView {
                    self.handleControl(oldView, controlEvent: .TouchDragExit)
                    
                    var viewChangedOwnership = self.ownView(touch, viewToOwn: newView)
                    
                    if !viewChangedOwnership {
                        self.handleControl(newView, controlEvent: .TouchDragEnter)
                    }
                    else {
                        self.handleControl(newView, controlEvent: .TouchDragInside)
                    }
                }
                else {
                    self.handleControl(oldView, controlEvent: .TouchDragInside)
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for obj in touches {
            if let touch = obj as? UITouch {
                var view = self.touchToView[touch]
                
                let touchPosition = touch.locationInView(self)
                
                if self.bounds.contains(touchPosition) {
                    self.handleControl(view, controlEvent: .TouchUpInside)
                }
                else {
                    self.handleControl(view, controlEvent: .TouchCancel)
                }
                
                self.touchToView[touch] = nil
            }
        }
    }
    
    override func touchesCancelled(touches: Set<NSObject>, withEvent event: UIEvent!) {
        for obj in touches {
            if let touch = obj as? UITouch {
                var view = self.touchToView[touch]
                
                self.handleControl(view, controlEvent: .TouchCancel)
                
                self.touchToView[touch] = nil
            }
        }
        
        
    }
}
