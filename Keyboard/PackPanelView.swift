//
//  PackPanelView.swift
//  Often
//
//  Created by Kervins Valcourt on 3/30/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PackPanelView: UIView {
    var cancelButton: UIButton
    var slider: UISlider

    override init(frame: CGRect) {
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(StyleKit.imageOfCancelbutton(scale: 0.45), forState: .Normal)
        cancelButton.contentEdgeInsets = UIEdgeInsets(top: 3.7, left: 3.7, bottom: 0, right: 0)

        slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.setThumbImage(StyleKit.imageOfThumbslider(), forState: .Normal)
        slider.setMaximumTrackImage(StyleKit.imageOfSlider(scale: 0.5).resizableImageWithCapInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)), forState: .Normal)
        slider.setMinimumTrackImage(StyleKit.imageOfSlider(scale: 0.5).resizableImageWithCapInsets(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)), forState: .Normal)


        super.init(frame: frame)
        backgroundColor = WhiteColor

        layer.shadowOffset = CGSizeMake(0, 0)
        layer.shadowOpacity = 0.8
        layer.shadowColor = DarkGrey.CGColor
        layer.shadowRadius = 2

        addSubview(cancelButton)
        addSubview(slider)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            cancelButton.al_top == al_top,
            cancelButton.al_left == al_left,
            cancelButton.al_bottom == al_bottom,
            cancelButton.al_width == 40,

            slider.al_left == al_left + 54,
            slider.al_top == al_top + 13.5,
            slider.al_bottom == al_bottom - 14,
            slider.al_right == al_right - 54
            ])
    }
}