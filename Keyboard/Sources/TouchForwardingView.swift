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
    
    override init(frame: CGRect) {
        touchToView = [:]
        
        super.init(frame: frame)
        
        contentMode = .Redraw
        multipleTouchEnabled = true
        userInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if frame.size.width == 0 || frame.size.height == 0 {
            return
        }
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView? {
        if self.hidden || self.alpha == 0 || !self.userInteractionEnabled {
            return nil
        } else {
            return (CGRectContainsPoint(self.bounds, point) ? self : nil)
        }
    }
    
    func handleControl(view: UIView?, controlEvent: UIControlEvents) {
        if let control = view as? UIControl {
            let targets = control.allTargets()
            for target in targets {
                if let actions = control.actionsForTarget(target, forControlEvent: controlEvent) {
                    for action in actions {
                        let selector = Selector(action)
                        control.sendAction(selector, to: target, forEvent: nil)
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
        
        for view in self.subviews {

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
        
        if rect.origin.x + rect.size.width < point.x {
            closest.x += rect.size.width
        } else if point.x > rect.origin.x {
            closest.x = point.x
        }

        if rect.origin.y + rect.size.height < point.y {
            closest.y += rect.size.height
        } else if point.y > rect.origin.y {
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
                    } else {
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let position = touch.locationInView(self)
            let view = findNearestView(position)
            
            let viewChangedOwnership = self.ownView(touch, viewToOwn: view)
            
            if !viewChangedOwnership {
                self.handleControl(view, controlEvent: .TouchDown)
                
                if touch.tapCount > 1 {
                    // two events, I think this is the correct behavior but I have not tested with an actual UIControl
                    self.handleControl(view, controlEvent: .TouchDownRepeat)
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let position = touch.locationInView(self)
            
            let oldView = self.touchToView[touch]
            let newView = findNearestView(position)
            
            if oldView != newView {
                self.handleControl(oldView, controlEvent: .TouchDragExit)
                
                let viewChangedOwnership = self.ownView(touch, viewToOwn: newView)
                
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
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let view = self.touchToView[touch]
            
            let touchPosition = touch.locationInView(self)
            
            print("touchPosition", touchPosition)
            
            if self.bounds.contains(touchPosition) {
                self.handleControl(view, controlEvent: .TouchUpInside)
            }
            else {
                self.handleControl(view, controlEvent: .TouchCancel)
            }
            
            self.touchToView[touch] = nil
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let touches = touches {
            for touch in touches {
                let view = self.touchToView[touch]
                
                self.handleControl(view, controlEvent: .TouchCancel)
                
                self.touchToView[touch] = nil
            }
        }
    }
    
}
