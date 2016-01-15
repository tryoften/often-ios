//
//  ContainerNavigationBar.swift
//  Often
//
//  Created by Luc Succes on 1/11/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

enum ContainerNavigationBarHeight: CGFloat {
    case Normal = 44.0
    case Large = 60.0
}

class ContainerNavigationBar: UINavigationBar {
    var height: ContainerNavigationBarHeight = .Normal {
        didSet {
            layoutIfNeeded()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupAppearance()
    }

    func setupAppearance() {
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if frame.size.width == 0 || frame.size.height == 0 {
            return
        }
    }

    override func sizeThatFits(size: CGSize) -> CGSize {
        return CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds), height.rawValue)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
