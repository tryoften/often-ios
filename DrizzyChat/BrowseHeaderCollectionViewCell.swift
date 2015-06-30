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
    var placeholderImage: UIImageView
    var artistImage: UIImageView
    
    override init(frame: CGRect) {
        placeholderImage = UIImageView(image: UIImage(named: "placeholder"))
        placeholderImage.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        artistImage = UIImageView()
        artistImage.setTranslatesAutoresizingMaskIntoConstraints(false)
        artistImage.contentMode = .ScaleAspectFill
        artistImage.clipsToBounds = true
        
        super.init(frame: frame)
        
        contentView.addSubview(placeholderImage)
        contentView.addSubview(artistImage)
        clipsToBounds = true
        
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        artistImage.image = nil
    }
    
    func setupLayout() {
        addConstraints([
            placeholderImage.al_centerX == al_centerX,
            placeholderImage.al_centerY == al_centerY,
            placeholderImage.al_width == al_width,
            placeholderImage.al_height == al_height,
            
            artistImage.al_centerX == al_centerX,
            artistImage.al_centerY == al_centerY,
            artistImage.al_width == al_width,
            artistImage.al_height == al_height
        ])
    }
    
    func setImageWithURLString(imageURLString: String) {
        artistImage.setImageWithAnimation(NSURL(string: imageURLString)!, completion: nil)
    }
}
