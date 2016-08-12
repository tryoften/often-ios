//
//  ColorPickerView.swift
//  Often
//
//  Created by Kervins Valcourt on 8/11/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class ColorPickerView: UIView {
    var currentSelectionX: CGFloat = 0
    var selectedColor: UIColor!
    var delegate: ColorPickerDelegate?

    override func drawRect(rect: CGRect) {
        UIColor.blackColor().set()
        var tempYPlace = self.currentSelectionX;
        if (tempYPlace < CGFloat (0.0)) {
            tempYPlace = CGFloat (0.0);
        } else if (tempYPlace >= self.frame.size.width) {
            tempYPlace = self.frame.size.width - 1.0;
        }

        let temp = CGRectMake(0.0, tempYPlace, 1.0, self.frame.size.height);
        UIRectFill(temp);

        //draw central bar over it
        let width = Int(self.frame.size.width)
        for i in 0 ..< width {
            UIColor(hue:CGFloat (i)/self.frame.size.width, saturation: 1.0, brightness: 1.0, alpha: 1.0).set()
            let temp = CGRectMake(CGFloat (i), 0, 1.0, self.frame.size.height);
            UIRectFill(temp);
        }
    }

    func selectedColor(color: UIColor) {
        if color != selectedColor {
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            var alpha: CGFloat = 0

            if color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha){
                currentSelectionX = CGFloat (hue * self.frame.size.height);
                self.setNeedsDisplay();
            }

            selectedColor = color
            self.delegate?.colorPickerViewDidSetColor(self, color: selectedColor)
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch =  touches.first
        updateColor(touch!)
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch =  touches.first
        updateColor(touch!)
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch =  touches.first
        updateColor(touch!)
    }

    func updateColor(touch: UITouch){
        currentSelectionX = (touch.locationInView(self).x)
        selectedColor = UIColor(hue: (currentSelectionX / self.frame.size.width), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        self.delegate?.colorPickerViewDidSetColor(self, color: selectedColor)
        self.setNeedsDisplay()
    }
}

 protocol ColorPickerDelegate {
    func colorPickerViewDidSetColor(picker: ColorPickerView, color: UIColor)
}
