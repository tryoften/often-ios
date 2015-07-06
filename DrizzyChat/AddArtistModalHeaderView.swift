//
//  AddArtistModalHeaderView.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/21/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class AddArtistModalHeaderView: UICollectionReusableView, AddArtistModalHeaderDelegate {
    var screenWidth: CGFloat
    var artistImage: UIImageView
    var coverPhoto: UIImageView
    var coverPhotoTintView: UIView
    var artistNameLabel: UILabel
    var addArtistButton: UIButton
    var topLabel: UILabel
    weak var delegate: AddArtistModalHeaderViewDelegate?
    
    override init(frame: CGRect) {
        screenWidth = UIScreen.mainScreen().bounds.width
        
        coverPhoto = UIImageView()
        coverPhoto.setTranslatesAutoresizingMaskIntoConstraints(false)
        coverPhoto.contentMode = .ScaleAspectFill
        
        coverPhotoTintView = UIView()
        coverPhotoTintView.setTranslatesAutoresizingMaskIntoConstraints(false)
        coverPhotoTintView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        artistImage = UIImageView()
        artistImage.setTranslatesAutoresizingMaskIntoConstraints(false)
        artistImage.contentMode = .ScaleAspectFill
        artistImage.clipsToBounds = true
        
        artistNameLabel = UILabel()
        artistNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        artistNameLabel.font = UIFont(name: "Oswald-Light", size: 22.0)
        artistNameLabel.textColor = UIColor(fromHexString: "#d3d3d3")
        artistNameLabel.textAlignment = .Center
        artistNameLabel.text = ""
        
        addArtistButton = AddArtistButton()
        addArtistButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        topLabel = UILabel()
        topLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        topLabel.textAlignment = .Center
        topLabel.font = UIFont(name: "OpenSans", size: 18.0)
        topLabel.text = "ADD ARTIST"
        topLabel.textColor = UIColor.whiteColor()
        topLabel.alpha = 0
        
        super.init(frame: frame)
        
        addArtistButton.addTarget(self, action: "addArtistTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        backgroundColor = UIColor(fromHexString: "#f7f7f7")
        
        addSubview(coverPhoto)
        addSubview(coverPhotoTintView)
        addSubview(artistImage)
        addSubview(artistNameLabel)
        addSubview(addArtistButton)
        addSubview(topLabel)
        
        clipsToBounds = true
        
        setupLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        if let attributes = layoutAttributes as? CSStickyHeaderFlowLayoutAttributes {
            UIView.animateWithDuration(0.4, animations: {
                if attributes.progressiveness <= 0.15 {
                    self.topLabel.alpha = 1
                    
                } else if attributes.progressiveness <= 0.40 {
                    self.artistNameLabel.alpha = 0
                    self.addArtistButton.alpha = 0
                    self.artistImage.alpha = 0
                } else {
                    self.topLabel.alpha = 0
                    self.artistNameLabel.alpha = 1
                    self.addArtistButton.alpha = 1
                    self.artistImage.alpha = 1
                }
            })
        }
    }
    
    func addArtistTapped(sender: UIButton) {
        addArtistButton.selected = !addArtistButton.selected
        delegate?.addArtistModalHeaderViewDidTapAddArtistButton(self, selected: addArtistButton.selected)
    }
    
    func currentArtistDidLoad(artist: Artist) {
        artistNameLabel.text = artist.name
        artistImage.setImageWithURL(NSURL(string: artist.imageURLLarge))
        coverPhoto.image = UIImage(named: "frank")!.blurredImageWithRadius(100, iterations: 4, tintColor: UIColor.blackColor())
    }
    
    func setupLayout() {
        addConstraints([
            topLabel.al_top == al_top + 10,
            topLabel.al_centerX == al_centerX,
            
            artistImage.al_width == artistImage.al_height,
            artistImage.al_width <= al_width - 100,
            artistImage.al_centerX == al_centerX,
            artistImage.al_top == al_top + 30,
            artistImage.al_bottom == al_bottom - 100,
            
            coverPhoto.al_top == al_top,
            coverPhoto.al_left == al_left,
            coverPhoto.al_width == al_width,
            coverPhoto.al_height == al_height,
            
            coverPhotoTintView.al_width == coverPhoto.al_width,
            coverPhotoTintView.al_height == coverPhoto.al_height,
            coverPhotoTintView.al_left == coverPhoto.al_left,
            coverPhotoTintView.al_top == coverPhoto.al_top,
            
            artistNameLabel.al_top == artistImage.al_bottom + 10,
            artistNameLabel.al_centerX == al_centerX,
            
            addArtistButton.al_top == artistNameLabel.al_bottom + 10,
            addArtistButton.al_centerX == al_centerX
        ])
    }
}

protocol AddArtistModalHeaderViewDelegate: class {
    func addArtistModalHeaderViewDidTapAddArtistButton(addArtistModalHeaderView: AddArtistModalHeaderView, selected: Bool)
}

protocol AddArtistModalHeaderDelegate {
    func currentArtistDidLoad(artist: Artist)
}
