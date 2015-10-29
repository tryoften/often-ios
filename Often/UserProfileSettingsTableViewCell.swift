//
//  UserProfileSettingsTableViewCell.swift
//  Often
//
//  Created by Komran Ghahremani on 8/30/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class UserProfileSettingsTableViewCell: UITableViewCell, UITextFieldDelegate {
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
        case Logout
    }

    var titleLabel: UILabel
    var secondaryTextLabel: UILabel
    var secondaryTextField: UITextField
    var settingSwitch: UISwitch
    var disclosureIndicator: UIImageView
    var cellType: SettingsCellType
    var delegate: TableViewCellDelegate?
    
    init(type: SettingsCellType) {
        cellType = type
        titleLabel = UILabel()
        secondaryTextLabel = UILabel()
        secondaryTextField = UITextField()
        disclosureIndicator = UIImageView()
        settingSwitch = UISwitch()
        
        switch cellType {
        case .Default:
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.font = UIFont(name: "OpenSans", size: 14.0)
            
            disclosureIndicator = UIImageView()
            disclosureIndicator.translatesAutoresizingMaskIntoConstraints = false
            disclosureIndicator.contentMode = .ScaleAspectFit
            disclosureIndicator.image = UIImage(named: "disclosureindicator")
            
        case .Nondisclosure:
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.font = UIFont(name: "OpenSans", size: 14.0)
            
            secondaryTextField.translatesAutoresizingMaskIntoConstraints = false
            secondaryTextField.textColor = SettingsViewCellSecondaryTextColor
            secondaryTextField.font = UIFont(name: "OpenSans", size: 14.0)
            secondaryTextField.returnKeyType = .Done
            secondaryTextField.userInteractionEnabled = false // no name changes yet
            
        case .Detailed:
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.font = UIFont(name: "OpenSans", size: 14.0)
            
            secondaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
            secondaryTextLabel.textColor = SettingsViewCellSecondaryTextColor
            secondaryTextLabel.font = UIFont(name: "OpenSans", size: 14.0)
            secondaryTextLabel.backgroundColor = ClearColor
            
            disclosureIndicator.translatesAutoresizingMaskIntoConstraints = false
            disclosureIndicator.image = UIImage(named: "disclosureindicator")
            disclosureIndicator.contentMode = .ScaleAspectFit
            
        case .Switch:
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.font = UIFont(name: "OpenSans", size: 14.0)
        
            settingSwitch.translatesAutoresizingMaskIntoConstraints = false
            settingSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75)
        case .Logout:
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.font = UIFont(name: "OpenSans", size: 14.0)
            titleLabel.textColor = UIColor.redColor()
        default:
            print("Cell Type not defined")
        }
        
        super.init(style: .Default, reuseIdentifier: "SettingsCell")
        
        switch cellType {
        case .Default:
            addSubview(titleLabel)
            addSubview(disclosureIndicator)
            break
        case .Nondisclosure:
            secondaryTextField.delegate = self
            addSubview(titleLabel)
            addSubview(secondaryTextField)
            break
        case .Detailed:
            addSubview(titleLabel)
            addSubview(secondaryTextLabel)
            addSubview(disclosureIndicator)
            break
        case .Switch:
            settingSwitch.addTarget(self, action: "switchToggled", forControlEvents: .TouchUpInside)
            addSubview(titleLabel)
            addSubview(settingSwitch)
            break
        case .Logout:
            addSubview(titleLabel)
            break
        default:
            print("Cell Type not defined")
        }
        
        backgroundColor = VeryLightGray
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
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
    
    //MARK: UISwitch
    func switchToggled() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if settingSwitch.on == true {
            defaults.setBool(true, forKey: "notificationsOn")
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert,UIUserNotificationType.Sound, UIUserNotificationType.Badge], categories: nil))
        } else {
            defaults.setBool(false, forKey: "notificationsOn")
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let newName = textField.text {
            delegate?.didFinishEditingName(newName)
        }
        
        textField.resignFirstResponder()
        return true
    }

    func setupLayout() {
        switch cellType {
        case .Default:
            addConstraints([
                titleLabel.al_left == al_left + 15,
                titleLabel.al_centerY == al_centerY,
                
                disclosureIndicator.al_right == al_right - 10,
                disclosureIndicator.al_centerY == al_centerY,
                disclosureIndicator.al_width == 16,
                disclosureIndicator.al_height == 16
            ])
            break
        case .Nondisclosure:
            addConstraints([
                titleLabel.al_left == al_left + 15,
                titleLabel.al_centerY == al_centerY,
                
                secondaryTextField.al_right == al_right - 13,
                secondaryTextField.al_centerY == al_centerY
            ])
            break
        case .Detailed:
            addConstraints([
                titleLabel.al_left == al_left + 15,
                titleLabel.al_centerY == al_centerY,
                
                secondaryTextLabel.al_width == 125,
                secondaryTextLabel.al_right == disclosureIndicator.al_left - 10,
                secondaryTextLabel.al_centerY == al_centerY,
                
                disclosureIndicator.al_right == al_right - 10,
                disclosureIndicator.al_centerY == al_centerY,
                disclosureIndicator.al_width == 16,
                disclosureIndicator.al_height == 16
            ])
            break
        case .Switch:
            addConstraints([
                titleLabel.al_left == al_left + 15,
                titleLabel.al_centerY == al_centerY,
                
                settingSwitch.al_right  == al_right - 10,
                settingSwitch.al_centerY == al_centerY
            ])
            break
        case .Logout:
            addConstraints([
                titleLabel.al_centerX == al_centerX,
                titleLabel.al_centerY == al_centerY
            ])
            break
        default:
            print("Cell Type not defined")
        }
    }
}

protocol TableViewCellDelegate {
    func didFinishEditingName(newName: String)
}
