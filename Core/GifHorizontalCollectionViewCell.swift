//
//  GifHorizontalCollectionViewCell.swift
//  Often
//
//  Created by Katelyn Findlay on 4/19/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class GifHorizontalCollectionViewCell: UICollectionViewCell {
    
    var gifsHorizontalVC: GifsHorizontalViewController?
    var bottomSeperator: UIView
    
    var textProcessor: TextProcessingManager? {
        didSet {
            gifsHorizontalVC?.textProcessor = textProcessor
        }
    }
    
    var group: MediaItemGroup? {
        didSet {
            gifsHorizontalVC?.group = group
        }
    }
    
    override init(frame: CGRect) {
        if gifsHorizontalVC == nil {
            gifsHorizontalVC = GifsHorizontalViewController()
        }
        
        bottomSeperator = UIView()
        bottomSeperator.backgroundColor = DarkGrey
        
        super.init(frame: frame)
        
        contentView.addSubview(gifsHorizontalVC!.view)
        contentView.addSubview(bottomSeperator)
        
        backgroundColor = UIColor.clearColor()
        
        gifsHorizontalVC!.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        gifsHorizontalVC!.view.frame = bounds
        
        bottomSeperator.frame = CGRectMake(0, CGRectGetHeight(frame) - 0.6, CGRectGetWidth(frame), 0.6)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
