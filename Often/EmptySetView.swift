//
//  EmptySetView.swift
//  Often
//
//  Created by Komran Ghahremani on 9/30/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

public enum UserState {
    case NoTwitter
    case NoFavorites
    case NoRecents
    case NoKeyboard
    case NonEmpty
}

class EmptySetView: UIView {
    var imageView: UIImageView
    var titleLabel: UILabel
    var descriptionLabel: UILabel
    var twitterButton: UIButton
    var settingbutton: UIButton
    var cancelButton: UIButton
    var userState: UserState 
    
    override init(frame: CGRect) {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFit
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Montserrat", size: 15.0)
        titleLabel.textColor = UIColor(fromHexString: "#202020")
        
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont(name: "OpenSans", size: 12.0)
        descriptionLabel.textColor = UIColor(fromHexString: "#202020")
        descriptionLabel.textAlignment = .Center
        descriptionLabel.numberOfLines = 2 
        
        twitterButton = UIButton()
        twitterButton.translatesAutoresizingMaskIntoConstraints = false
        twitterButton.backgroundColor = UIColor(fromHexString: "#62A9E0")
        twitterButton.setTitle("connect twitter".uppercaseString, forState: .Normal)
        twitterButton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        twitterButton.layer.cornerRadius = 4.0
        twitterButton.clipsToBounds = true
        twitterButton.hidden = true
        
        settingbutton = UIButton()
        settingbutton.translatesAutoresizingMaskIntoConstraints = false
        settingbutton.backgroundColor = UIColor(fromHexString: "#21CE99")
        settingbutton.setTitle("go to settings".uppercaseString, forState: .Normal)
        settingbutton.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        settingbutton.layer.cornerRadius = 4.0
        settingbutton.clipsToBounds = true
        settingbutton.hidden = true
        
        
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(StyleKit.imageOfButtonclose(scale: 0.5), forState: .Normal)
        cancelButton.alpha = 0.54
        cancelButton.hidden = true
        
        userState = .NoTwitter
        
        super.init(frame: frame)
        
        userInteractionEnabled = false
        backgroundColor = UIColor(fromHexString: "#f7f7f7")
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(twitterButton)
        addSubview(settingbutton)
        addSubview(cancelButton)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Allows the empty state to figure out the content in itself - only need to set the EmptySetView's UserState
    func updateEmptyStateContent(state: UserState) {
        userState = state
        switch (state) {
        case .NoTwitter:
            imageView.image = UIImage(named: "twitteremptystate")
            titleLabel.text = "Connect with Twitter"
            descriptionLabel.text = "Often works even better with Twitter. \n Any links you favorite there are saved here."
            twitterButton.hidden = false
            cancelButton.hidden = false
            settingbutton.hidden = true
        case .NoKeyboard:
            imageView.image = UIImage(named: "installoftenemptystate")
            titleLabel.text = "Install Often"
            descriptionLabel.text = "Remember to install Often in your \nkeyboards settings and allow full-access."
            settingbutton.hidden = false
            cancelButton.hidden = true
        case .NoFavorites:
            imageView.image = UIImage(named: "favoritesemptystate")
            titleLabel.text = "No favorites yet!"
            descriptionLabel.text = "Double tap any cards to save them to your\n favorites & easily share them again later."
            settingbutton.hidden = true
            twitterButton.hidden = true
            cancelButton.hidden = true
        case .NoRecents:
            imageView.image = UIImage(named: "recentsemptystate")
            titleLabel.text = "No recents yet!"
            descriptionLabel.text = "Start using Often to easily access your\n most recently searched or used content."
            settingbutton.hidden = true
            twitterButton.hidden = true
            cancelButton.hidden = true
        default:
            break
        }
    }

    func setupLayout() {
        addConstraints([
            imageView.al_centerX == al_centerX,
            imageView.al_top == al_top + 50,
            imageView.al_height == 70,
            imageView.al_width == 70,
            
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_top == imageView.al_bottom + 20,
            
            descriptionLabel.al_centerX == al_centerX,
            descriptionLabel.al_top == titleLabel.al_bottom + 5,
            
            cancelButton.al_height == 40,
            cancelButton.al_width == 40,
            cancelButton.al_top == al_top + 15,
            cancelButton.al_right == al_right - 15,
            
            twitterButton.al_centerX == al_centerX,
            twitterButton.al_top == descriptionLabel.al_bottom + 30,
            twitterButton.al_left == al_left + 30,
            twitterButton.al_right == al_right - 30,
            twitterButton.al_height == 50,
            
            settingbutton.al_centerX == al_centerX,
            settingbutton.al_top == descriptionLabel.al_bottom + 30,
            settingbutton.al_left == al_left + 30,
            settingbutton.al_right == al_right - 30,
            settingbutton.al_height == 50
        ])
    }
}

protocol EmptySetDelegate {
    func updateEmptySetVisible(visible: Bool)
}