//
//  PackBrowseCollectionViewCell.swift
//  Often
//
//  Created by Komran Ghahremani on 3/22/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class PackBrowseHeaderCollectionViewCell: UICollectionViewCell {
    var placeholderImage: UIImageView
    var artistImage: UIImageView
    var confirmView: UIImageView
    var shadowLayer: CAShapeLayer
    
    override init(frame: CGRect) {
        placeholderImage = UIImageView()
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.clipsToBounds = true
        placeholderImage.layer.cornerRadius = 4.0
        
        artistImage = UIImageView()
        artistImage.translatesAutoresizingMaskIntoConstraints = false
        artistImage.contentMode = .ScaleAspectFill
        artistImage.clipsToBounds = true
        artistImage.layer.cornerRadius = 4.0
        
        confirmView = UIImageView()
        confirmView.translatesAutoresizingMaskIntoConstraints = false
        confirmView.backgroundColor = BrowseHeaderCollectionViewCellConfirmViewColor
        confirmView.alpha = 0
        confirmView.contentMode = .Center
        
        shadowLayer = CAShapeLayer()
        
        super.init(frame: frame)
        
        contentView.addSubview(placeholderImage)
        contentView.addSubview(artistImage)
        contentView.addSubview(confirmView)
        
        layer.cornerRadius = 4.0
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSizeMake(0, 2)
        layer.shadowRadius = 4

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Methods that we could reuse
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
        UIView.animateWithDuration(0.3, delay: 1.0, options: [], animations: { () -> Void in
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
