//
//  ServiceSettingsCollectionViewCell.swift
//  Surf
//
//  Created by Komran Ghahremani on 8/5/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class ServiceSettingsCollectionViewCell: UICollectionViewCell {
    var serviceLogoImageView: UIImageView
    var serviceSwitch: UISwitch
    var serviceSubtitleLabel: UILabel
    var settingServicesType: SettingsServicesType = .Venmo
    
    enum SettingsServicesType {
        case Venmo
        case Spotify
        case Soundcloud
    }
    
    override init(frame: CGRect) {
        serviceLogoImageView = UIImageView()
        serviceLogoImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        serviceLogoImageView.contentMode = .ScaleAspectFit
        
        serviceSwitch = UISwitch()
        serviceSwitch.setTranslatesAutoresizingMaskIntoConstraints(false)
        serviceSwitch.on = false
        serviceSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75)
        
        serviceSubtitleLabel = UILabel()
        serviceSubtitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        serviceSubtitleLabel.font = UIFont(name: "OpenSans", size: 9.0)
        serviceSubtitleLabel.textColor = UIColor(fromHexString: "#000000")
        serviceSubtitleLabel.textAlignment = .Center
        serviceSubtitleLabel.numberOfLines = 2
        
        super.init(frame: frame)
        
        backgroundColor = WhiteColor
        
        serviceSwitch.addTarget(self, action: "switchAction", forControlEvents: .TouchUpInside)
        
        addSubview(serviceLogoImageView)
        addSubview(serviceSwitch)
        addSubview(serviceSubtitleLabel)
        
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func switchAction() {
        if serviceSwitch.on {
            switch settingServicesType {
            case .Venmo:
                serviceSubtitleLabel.text = "Connected!"
                serviceSubtitleLabel.numberOfLines = 1
                serviceLogoImageView.image = UIImage(named: "venmo-on")
                break
            default:
                break
            }
        } else {
            switch settingServicesType {
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
            serviceSwitch.al_top == serviceLogoImageView.al_bottom - 5,
            
            serviceLogoImageView.al_centerX == al_centerX,
            serviceLogoImageView.al_centerY == al_centerY - 10,
            serviceLogoImageView.al_width == 100,
            serviceLogoImageView.al_height == 50
        ])
    }
}
