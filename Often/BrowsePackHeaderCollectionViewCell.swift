//
//  BrowsePackHeaderCollectionViewCell.swift
//  Often
//
//  Created by Komran Ghahremani on 3/22/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class BrowsePackHeaderCollectionViewCell: UICollectionViewCell {
    var placeholderImage: UIImageView
    var artistImage: UIImageView
    var confirmView: UIImageView
    var shadowLayer: CAShapeLayer
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var gradientView: UIImageView

    private var artistImageLeftAndRightMargin: CGFloat {
        if Diagnostics.platformString().desciption == "iPhone 6 Plus" || Diagnostics.platformString().desciption == "iPhone 6S Plus" {
            return 35
        }

        return 0
    }

    
    override init(frame: CGRect) {
        placeholderImage = UIImageView()
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.backgroundColor = MediumGrey
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
        
        gradientView = UIImageView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.contentMode = .ScaleAspectFill
        gradientView.clipsToBounds = true
        gradientView.image = UIImage(named: "gradient")
        gradientView.layer.cornerRadius = 4.0
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .Center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.setTextWith(UIFont(name: "OpenSans-Semibold", size: 9.0)!,
                                  letterSpacing: 0.5,
                                  color: WhiteColor,
                                  text: "featured keyboard".uppercaseString)
        
        shadowLayer = CAShapeLayer()
        
        
        super.init(frame: frame)
        
        contentView.addSubview(placeholderImage)
        contentView.addSubview(artistImage)
        contentView.addSubview(gradientView)
        contentView.addSubview(confirmView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
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
            placeholderImage.al_width == al_width - artistImageLeftAndRightMargin,
            placeholderImage.al_height == al_height - artistImageLeftAndRightMargin ,
            
            artistImage.al_centerX == al_centerX,
            artistImage.al_centerY == al_centerY,
            artistImage.al_width == al_width - artistImageLeftAndRightMargin,
            artistImage.al_height == al_height - artistImageLeftAndRightMargin,
            
            gradientView.al_centerY == artistImage.al_centerY,
            gradientView.al_centerX == artistImage.al_centerX,
            gradientView.al_width == artistImage.al_width,
            gradientView.al_height == artistImage.al_height,
            
            confirmView.al_centerX == al_centerX,
            confirmView.al_centerY == al_centerY,
            confirmView.al_width == al_width,
            confirmView.al_height == al_height,
            
            titleLabel.al_centerY == al_centerY,
            titleLabel.al_centerX == al_centerX,
            
            subtitleLabel.al_top == titleLabel.al_bottom,
            subtitleLabel.al_centerX == al_centerX
        ])
    }
    
}
