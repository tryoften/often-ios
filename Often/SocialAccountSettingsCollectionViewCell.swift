//
//  ServiceSettingsCollectionViewCell.swift
//  Surf
//
//  Created by Komran Ghahremani on 8/5/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class SocialAccountSettingsCollectionViewCell: UICollectionViewCell {
    var serviceLogoImageView: UIImageView
    var serviceSwitch: UISwitch
    var serviceSubtitleLabel: UILabel
    var settingSocialAccount: SocialAccount
    weak var delegate: AddServiceProviderDelegate?
        
    override init(frame: CGRect) {
        settingSocialAccount = SocialAccount()
        settingSocialAccount.type = .Other
        
        serviceLogoImageView = UIImageView()
        serviceLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        serviceLogoImageView.contentMode = .ScaleAspectFit
        
        serviceSwitch = UISwitch()
        serviceSwitch.translatesAutoresizingMaskIntoConstraints = false
        serviceSwitch.on = false
        serviceSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75)
        
        serviceSubtitleLabel = UILabel()
        serviceSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        serviceSubtitleLabel.font = UIFont(name: "OpenSans", size: 9.0)
        serviceSubtitleLabel.textColor = UIColor(fromHexString: "#000000")
        serviceSubtitleLabel.textAlignment = .Center
        serviceSubtitleLabel.numberOfLines = 2
        serviceSubtitleLabel.alpha = 0.54
        
        super.init(frame: frame)
        
        backgroundColor = WhiteColor
        
        serviceSwitch.addTarget(self, action: "switchAction:", forControlEvents: .TouchUpInside)
        
        addSubview(serviceLogoImageView)
        addSubview(serviceSwitch)
        addSubview(serviceSubtitleLabel)
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSizeMake(0, 2)
        layer.shadowOpacity = 0.14
        layer.shadowRadius = 2.0
        clipsToBounds = false
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func switchAction(sender: UIButton) {
        delegate?.addServiceProviderCellDidTapSwitchButton(self, selected: serviceSwitch.on, buttonTag:sender.tag)
        checkButtonStatus(serviceSwitch.on)
        }
    
    func checkButtonStatus(buttonStatus: Bool) {
        if buttonStatus {
            serviceSubtitleLabel.text = "Connected!"
            serviceSubtitleLabel.numberOfLines = 1
            switch settingSocialAccount.type {
            case .Twitter:
                serviceLogoImageView.image = UIImage(named: "twitter-on")
                break
            case .Spotify:
                serviceLogoImageView.image = UIImage(named: "spotify-on")
                break
            case .Soundcloud:
                serviceLogoImageView.image = UIImage(named: "soundcloud-on")
                break
            default:
                break
            }
        } else {
            switch settingSocialAccount.type {
            case .Twitter:
                serviceSubtitleLabel.text = "Connect your Twitter account to sync your profile picture, description & favorites."
                serviceSubtitleLabel.numberOfLines = 2
                serviceLogoImageView.image = UIImage(named: "twitter-off")
            case .Spotify:
                serviceSubtitleLabel.text = "Connect your Spotify account to share playlists & saved songs."
                serviceSubtitleLabel.numberOfLines = 2
                serviceLogoImageView.image = UIImage(named: "spotify-off")
                break
            case .Soundcloud:
                serviceSubtitleLabel.text = "Connect your Soundcloud account to share songs you've liked."
                serviceSubtitleLabel.numberOfLines = 2
                serviceLogoImageView.image = UIImage(named: "soundcloud-off")
                break
            default:
                break
            }
        }

    }
    
    func setupLayout() {
        addConstraints([
            serviceSubtitleLabel.al_bottom == al_bottom - 18,
            serviceSubtitleLabel.al_centerX == al_centerX,
            serviceSubtitleLabel.al_width == 180,
            
            serviceSwitch.al_centerX == al_centerX,
            serviceSwitch.al_top == serviceLogoImageView.al_bottom + 3,
            
            serviceLogoImageView.al_centerX == al_centerX,
            serviceLogoImageView.al_centerY == al_centerY - 25,
            serviceLogoImageView.al_width == 100,
            serviceLogoImageView.al_height == 40
        ])
    }
}

protocol AddServiceProviderDelegate: class {
    func addServiceProviderCellDidTapSwitchButton(serviceSettingsCollectionView: SocialAccountSettingsCollectionViewCell, selected: Bool, buttonTag: Int)
}
