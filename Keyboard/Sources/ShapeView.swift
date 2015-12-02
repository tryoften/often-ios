//
//  ShapeView.swift
//  Surf
//
//  Created by Kervins Valcourt on 7/30/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit


class ShapeView: UIView {
    var shapeLayer: CAShapeLayer?
    /*
    PERFORMANCE NOTES
    
    * CAShapeLayer: convenient and low memory usage, but chunky rotations
    * drawRect: fast, but high memory usage (looks like there's a backing store for each of the 3 views)
    * if I set CAShapeLayer to shouldRasterize, perf is *almost* the same as drawRect, while mem usage is the same as before
    * oddly, 3 CAShapeLayers show the same memory usage as 1 CAShapeLayer — where is the backing store?
    * might want to move to drawRect with combined draw calls for performance reasons — not clear yet
    */

    override class func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }
    
    var curve: UIBezierPath? {
        didSet {
            if let layer = shapeLayer {
                layer.path = curve?.CGPath
            } else {
                setNeedsDisplay()
            }
        }
    }
    
    var fillColor: UIColor? {
        didSet {
            if let layer = shapeLayer {
                layer.fillColor = fillColor?.CGColor
            } else {
                setNeedsDisplay()
            }
        }
    }
    
    var strokeColor: UIColor? {
        didSet {
            if let layer = shapeLayer {
                layer.strokeColor = strokeColor?.CGColor
            } else {
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
            } else {
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
    
    required init?(coder aDecoder: NSCoder) {
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
