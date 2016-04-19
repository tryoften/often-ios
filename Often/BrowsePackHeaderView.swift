//
//  BrowsePackHeaderView.swift
//  Often
//
//  Created by Komran Ghahremani on 3/26/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class BrowsePackHeaderView: UICollectionReusableView {
    var browsePicker: BrowsePackHeaderCollectionViewController

    override init(frame: CGRect) {
        browsePicker = BrowsePackHeaderCollectionViewController()
        browsePicker.view.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: frame)

        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.oftWhiteColor().CGColor, UIColor.oftWhiteThreeColor().CGColor]
        layer.insertSublayer(gradient, atIndex: 0)

        clipsToBounds = true

        addSubview(browsePicker.view)
        setupLayout()
    }

    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attributes = layoutAttributes as? CSStickyHeaderFlowLayoutAttributes {
            let progressiveness = attributes.progressiveness

            UIView.animateWithDuration(0.3) {
                if progressiveness <= 0.95 {
                    let val = max(progressiveness - 0.25, 0.2)
                    self.browsePicker.view.alpha = val
                } else {
                    self.browsePicker.view.alpha = 1.0
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            browsePicker.view.al_top == al_top ,
            browsePicker.view.al_left == al_left,
            browsePicker.view.al_width == al_width,
            browsePicker.view.al_bottom == al_bottom,
        ])
    }
}
