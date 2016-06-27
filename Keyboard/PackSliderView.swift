//
//  PackSliderView.swift
//  Often
//
//  Created by Kervins Valcourt on 3/30/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PackSliderView: UIView {
    var slider: UISlider

    override init(frame: CGRect) {
        slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.setThumbImage(StyleKit.imageOfThumbslider(), for: UIControlState())
        slider.setMaximumTrackImage(StyleKit.imageOfSlider(scale: 0.5).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)), for: UIControlState())
        slider.setMinimumTrackImage(StyleKit.imageOfSlider(scale: 0.5).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)), for: UIControlState())


        super.init(frame: frame)
        backgroundColor = ClearColor

        addSubview(slider)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            slider.al_left == al_left + 22,
            slider.al_top == al_top + 13.5,
            slider.al_bottom == al_bottom - 14,
            slider.al_right == al_right - 22
            ])
    }
}
