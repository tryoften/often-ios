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
    var button: UIButton
    var cancelButton: UIButton?
    var userState: UserState {
        didSet(value) {
            print(value)
            updateEmptyStateContent(value)
            userState = value
        }
    }
    
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
        
        button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        userState = .NoTwitter
        
        super.init(frame: frame)
        
        userInteractionEnabled = false
        backgroundColor = WhiteColor
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(button)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Allows the empty state to figure out the content in itself - only need to set the EmptySetView's UserState
    func updateEmptyStateContent(state: UserState) {
        if state == .NoTwitter {
            imageView.image = UIImage(named: "twitteremptystate")
            titleLabel.text = "Connect with Twitter"
            descriptionLabel.text = "Often works even better with Twitter. \n Any links you favorite there are saved here."
        } else if state == .NoKeyboard {
            imageView.image = UIImage(named: "installoftenemptystate")
            titleLabel.text = "Install Often"
            descriptionLabel.text = "Remember to install Often in your \nkeyboards settings and allow full-access."
        } else if state == .NoFavorites {
            imageView.image = UIImage(named: "favoritesemptystate")
            titleLabel.text = "No favorites yet!"
            descriptionLabel.text = "Double tap any cards to save them to your\n favorites & easily share them again later."
        } else if state == .NoRecents {
            imageView.image = UIImage(named: "recentsemptystate")
            titleLabel.text = "No recents yet!"
            descriptionLabel.text = "Start using Often to easily access your\n most recently searched or used content."
        } else {
            // get rid of empty states
        }
    }

    func setupLayout() {
        addConstraints([
            imageView.al_centerX == al_centerX,
            imageView.al_top == al_top + 20,
            
            titleLabel.al_centerX == al_centerX,
            titleLabel.al_top == imageView.al_bottom,
            
            descriptionLabel.al_centerX == al_centerX,
            descriptionLabel.al_top == titleLabel.al_bottom + 5,
            
            button.al_centerX == al_centerX,
            button.al_top == descriptionLabel.al_bottom + 5
        ])
    }
}

protocol EmptySetDelegate {
    func updateEmptySetVisible(visible: Bool)
}