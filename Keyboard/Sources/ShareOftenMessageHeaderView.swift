//
//  ShareOftenMessageHeaderView.swift
//  Often
//
//  Created by Komran Ghahremani on 1/15/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class ShareOftenMessageHeaderView: MessageWithButtonHeaderView {
    var arrowShape: UIImageView
    
    override init(frame: CGRect) {
        arrowShape = UIImageView()
        arrowShape.translatesAutoresizingMaskIntoConstraints = false
        arrowShape.contentMode = .ScaleAspectFit
        arrowShape.image = StyleKit.imageOfSharebutton()
        
        super.init(frame: frame)
        
        titleLabel.text = "Share Often"
        
        subtitleLabel.text = "Hey there good looking. Enjoying\n Often? Share the link with a friend"
        
        primaryButton.setTitle("Insert Link".uppercaseString, forState: .Normal)
        primaryButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 17.0, 0.0, 0.0)
        primaryButton.addSubview(arrowShape)
        
        addAdditionalLayoutConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAdditionalLayoutConstraints() {
        addConstraints([
            arrowShape.al_right == primaryButton.titleLabel!.al_left,
            arrowShape.al_centerY == primaryButton.al_centerY,
            arrowShape.al_width == 30,
            arrowShape.al_height == 30
        ])
    }
}
