//
//  SearchBarButton.swift
//  Surf
//
//  Created by Luc Succes on 7/20/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class SearchBarButton: UIButton {
    var deleteButton: UIImageView

    override init(frame: CGRect) {
        deleteButton = UIImageView()
        
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        imageView?.contentMode = .ScaleAspectFit
        
        addSubview(deleteButton)
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        titleLabel?.font = SubtitleFont
        
        contentEdgeInsets = UIEdgeInsets(top: 3, left: 25, bottom: 3, right: 3)
        layer.cornerRadius = 3.0
        backgroundColor = VeryLightGray
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let topMargin = CGRectGetHeight(frame) / 2 - 4.0
        deleteButton.frame = CGRectMake(8.0, topMargin, 8.0, 8.0)
        deleteButton.image = StyleKit.imageOfButtonclose(frame: CGRectMake(0, 0, CGRectGetWidth(deleteButton.frame), CGRectGetHeight(deleteButton.frame)), color: UIColor.blackColor(), scale: 0.6)
    }
}

func ==(lhs: SearchBarButton, rhs: SearchBarButton) -> Bool {
    return lhs.tag == rhs.tag
}