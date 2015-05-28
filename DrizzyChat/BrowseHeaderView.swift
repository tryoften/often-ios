//
//  BrowseHeaderView.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 5/27/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class BrowseHeaderView: UICollectionReusableView {
    var coverPhoto: UIImageView
    var nameLabel: UILabel
    var addArtistButton: UIButton
    
    override init(frame: CGRect) {
        coverPhoto = UIImageView()
        coverPhoto.contentMode = .ScaleAspectFill
        coverPhoto.translatesAutoresizingMaskIntoConstraints()
        coverPhoto.clipsToBounds = true
        
        nameLabel = UILabel()
        nameLabel.textAlignment = .Center
        nameLabel.font = UIFont(name: "Lato-Regular", size: 24.0)
        nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // (kom) not sure if should have own view like the Facebook Button
        addArtistButton = UIButton()
        addArtistButton.backgroundColor = UIColor(fromHexString: "")
        addArtistButton.titleLabel?.textAlignment = .Center
        addArtistButton.titleLabel?.text = "Add Artist"
        
        super.init(frame: frame)
        
        setLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout(){
        
    }
}
