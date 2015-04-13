//
//  CategoryCollectionViewCell.swift
//  Drizzy
//
//  Created by Luc Success on 4/13/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    var nameLabel: UILabel!
    var lyricCountLabel: UILabel!
    var borderColor: UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    func setupLayout() {
        
    }
}
