//
//  UserProfileSettingsTableViewCell.swift
//  Often
//
//  Created by Komran Ghahremani on 8/30/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class UserProfileSettingsTableViewCell: UITableViewCell {
    /**
    Default: Main text label and disclosure indicator
    Nondisclosure: Main text label and secondary text label
    Detailed: Main text label, secondary text label, and disclosure indicator
    Switch: Main text label and UISwitch
    
    */
    enum SettingsCellType {
        case Default
        case Nondisclosure
        case Detailed
        case Switch
    }
    
    var cellType: SettingsCellType
    var titleLabel: UILabel
    var secondaryTextLabel: UILabel
    var settingSwitch: UISwitch
    var disclosureIndicator: UIImageView
    
    init(type: SettingsCellType) {
        cellType = type
        titleLabel = UILabel()
        secondaryTextLabel = UILabel()
        disclosureIndicator = UIImageView()
        settingSwitch = UISwitch()
        
        switch cellType {
        case .Default:
            titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
            titleLabel.font = UIFont(name: "OpenSans", size: 12.0)
            
            disclosureIndicator = UIImageView()
            disclosureIndicator.setTranslatesAutoresizingMaskIntoConstraints(false)
            disclosureIndicator.contentMode = .ScaleAspectFit
            
        case .Nondisclosure:
            titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
            titleLabel.font = UIFont(name: "OpenSans", size: 12.0)
            
            secondaryTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
            secondaryTextLabel.textColor = LightGrey
            secondaryTextLabel.font = UIFont(name: "OpenSans", size: 12.0)
            
        case .Detailed:
            titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
            titleLabel.font = UIFont(name: "OpenSans", size: 12.0)
            
            secondaryTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
            secondaryTextLabel.textColor = LightGrey
            secondaryTextLabel.font = UIFont(name: "OpenSans", size: 12.0)
            
            disclosureIndicator.setTranslatesAutoresizingMaskIntoConstraints(false)
            disclosureIndicator.contentMode = .ScaleAspectFit
            
        case .Switch:
            titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
            titleLabel.font = UIFont(name: "OpenSans", size: 12.0)
            
            settingSwitch.setTranslatesAutoresizingMaskIntoConstraints(false)
        default:
            println("Cell Type not defined")
        }
        
        super.init(style: .Default, reuseIdentifier: "SettingsCell")
        
        switch cellType {
        case .Default:
            addSubview(titleLabel)
            addSubview(disclosureIndicator)
            
        case .Nondisclosure:
            addSubview(titleLabel)
            addSubview(secondaryTextLabel)
            
        case .Detailed:
            addSubview(titleLabel)
            addSubview(secondaryTextLabel)
            addSubview(disclosureIndicator)
            
        case .Switch:
            addSubview(titleLabel)
            addSubview(settingSwitch)
        default:
            println("Cell Type not defined")
        }
        
        setupLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupLayout() {
        switch cellType {
        case .Default:
            addConstraints([
                titleLabel.al_left == al_left + 5,
                titleLabel.al_centerX == al_centerX,
                
                disclosureIndicator.al_right == al_right - 5,
                disclosureIndicator.al_centerX == al_centerX
            ])
            
        case .Nondisclosure:
            addConstraints([
                titleLabel.al_left == al_left + 5,
                titleLabel.al_centerX == al_centerX,
                
                secondaryTextLabel.al_right == al_right + 2,
                secondaryTextLabel.al_centerX == al_centerX
            ])
            
        case .Detailed:
            addConstraints([
                titleLabel.al_left == al_left + 5,
                titleLabel.al_centerX == al_centerX,
                
                disclosureIndicator.al_right == al_right - 5,
                disclosureIndicator.al_centerX == al_centerX,
                
                secondaryTextLabel.al_right == disclosureIndicator.al_left - 2,
                secondaryTextLabel.al_centerX == al_centerX
            ])
            
        case .Switch:
            addConstraints([
                titleLabel.al_left == al_left + 5,
                titleLabel.al_centerX == al_centerX,
                
                settingSwitch.al_right  == al_right + 2,
                settingSwitch.al_centerX == al_centerX
            ])
        default:
            println("Cell Type not defined")
        }
    }
}
