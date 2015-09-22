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
    var settingServicesType: SocialAccountType = .Other
    weak var delegate: AddServiceProviderDelegate?
        
    override init(frame: CGRect) {
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
        
        super.init(frame: frame)
        
        backgroundColor = WhiteColor
        
        serviceSwitch.addTarget(self, action: "switchAction:", forControlEvents: .TouchUpInside)
        
        addSubview(serviceLogoImageView)
        addSubview(serviceSwitch)
        addSubview(serviceSubtitleLabel)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func switchAction(sender : UIButton) {
        delegate?.addServiceProviderCellDidTapSwitchButton(self, selected: serviceSwitch.on, buttonTag:sender.tag)
        checkButtonStatus(serviceSwitch.on)
        }
    
    func checkButtonStatus(buttonStatus:Bool){
        if buttonStatus {
            serviceSubtitleLabel.text = "Connected!"
            serviceSubtitleLabel.numberOfLines = 1
            switch settingServicesType {
            case .Twitter:
                serviceLogoImageView.image = UIImage(named: "twitter-on")
                break
            case .Spotify:
                serviceLogoImageView.image = UIImage(named: "spotify-on")
                break
            case .Soundcloud:
                serviceLogoImageView.image = UIImage(named: "soundcloud-on")
                break
            case .Venmo:
                serviceLogoImageView.image = UIImage(named: "venmo-on")
                break
            default:
                break
            }
        } else {
            switch settingServicesType {
            case .Twitter:
                serviceSubtitleLabel.text = "Connect your Twitter account to start sending payments & requests from your keyboard."
                serviceSubtitleLabel.numberOfLines = 2
                serviceLogoImageView.image = UIImage(named: "twitter-off")
            case .Spotify:
                serviceSubtitleLabel.text = "Connect your Spotify account to start sending payments & requests from your keyboard."
                serviceSubtitleLabel.numberOfLines = 2
                serviceLogoImageView.image = UIImage(named: "spotify-off")
                break
            case .Soundcloud:
                serviceSubtitleLabel.text = "Connect your Soundcloud account to start sending payments & requests from your keyboard."
                serviceSubtitleLabel.numberOfLines = 2
                serviceLogoImageView.image = UIImage(named: "soundcloud-off")
                break
            case .Venmo:
                serviceSubtitleLabel.text = "Connect your Venmo account to start sending payments & requests from your keyboard."
                serviceSubtitleLabel.numberOfLines = 2
                serviceLogoImageView.image = UIImage(named: "venmo-off")
                break
            default:
                break
            }
        }

    }
    
    func setupLayout() {
        addConstraints([
            serviceSubtitleLabel.al_bottom == al_bottom - 10,
            serviceSubtitleLabel.al_centerX == al_centerX,
            serviceSubtitleLabel.al_width == 200,
            
            serviceSwitch.al_centerX == al_centerX,
            serviceSwitch.al_top == serviceLogoImageView.al_bottom + 5,
            
            serviceLogoImageView.al_centerX == al_centerX,
            serviceLogoImageView.al_centerY == al_centerY - 10,
            serviceLogoImageView.al_width == 100,
            serviceLogoImageView.al_height == 40
        ])
    }
}

protocol AddServiceProviderDelegate: class {
    func addServiceProviderCellDidTapSwitchButton(serviceSettingsCollectionView: SocialAccountSettingsCollectionViewCell, selected: Bool, buttonTag:Int)
}
