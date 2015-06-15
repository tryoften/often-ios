//
//  BrowseHeaderCollectionViewCell.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/3/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

/**
    BrowseHeaderCollectionViewCell:
    
    A cell for the collection view in the header of the Browse View
    that contains an image view as large as its frame
    The image view will contain the current artist's large_image

*/

class BrowseHeaderCollectionViewCell: UICollectionViewCell {
    @IBOutlet var artistImage: UIImageView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        artistImage = UIImageView(frame: self.bounds)
        artistImage.contentMode = .ScaleAspectFit
        artistImage.clipsToBounds = true
        
        contentView.addSubview(artistImage)
        
        setLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        addConstraints([
            artistImage.al_centerX == al_centerX,
            artistImage.al_centerY == al_centerY
        ])
    }
}
