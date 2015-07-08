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
    var confirmView: UIImageView
    
    override init(frame: CGRect) {
        placeholderImage = UIImageView(image: UIImage(named: "placeholder"))
        placeholderImage.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        artistImage = UIImageView()
        artistImage.setTranslatesAutoresizingMaskIntoConstraints(false)
        artistImage.contentMode = .ScaleAspectFill
        artistImage.clipsToBounds = true
        
        confirmView = UIImageView()
        confirmView.setTranslatesAutoresizingMaskIntoConstraints(false)
        confirmView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        confirmView.alpha = 0
        confirmView.contentMode = .Center
        
        super.init(frame: frame)
        
        contentView.addSubview(placeholderImage)
        contentView.addSubview(artistImage)
        contentView.addSubview(confirmView)

        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSizeMake(0, 5)
        layer.shadowOpacity = 0.54
        layer.shadowRadius = 8.0
        clipsToBounds = false
        
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        artistImage.image = nil
    }
    
    func showLoadingScreenView() {
        confirmView.image = UIImage.animatedImageNamed("october-loader-greyscale-", duration: 1.1)
        confirmView.alpha = 1.0
    }
    
    func showAddedConfirmView() {
        confirmView.image = UIImage(named: "checkmark")
        confirmView.alpha = 1.0
        dismissConfirmView()
    }
    
    func showRemovedConfirmView() {
        confirmView.image = UIImage(named: "cross")
        confirmView.alpha = 1.0
        dismissConfirmView()
    }
    
    func dismissConfirmView() {
        UIView.animateWithDuration(0.3, delay: 1.0, options: nil, animations: { () -> Void in
            self.confirmView.alpha = 0.0
            }) { (success) -> Void in

        }
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
            artistImage.al_height == al_height,

            confirmView.al_centerX == al_centerX,
            confirmView.al_centerY == al_centerY,
            confirmView.al_width == al_width,
            confirmView.al_height == al_height
        ])
    }
    
    func setImageWithURLString(imageURLString: String) {
        artistImage.setImageWithAnimation(NSURL(string: imageURLString)!, completion: nil)
    }
}
