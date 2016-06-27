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
        case .default:
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.font = UIFont(name: "OpenSans", size: 14.0)
            
            disclosureIndicator = UIImageView()
            disclosureIndicator.translatesAutoresizingMaskIntoConstraints = false
            disclosureIndicator.contentMode = .scaleAspectFit
            disclosureIndicator.image = UIImage(named: "disclosureindicator")
            
        case .nondisclosure:
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.font = UIFont(name: "OpenSans", size: 14.0)
            
            secondaryTextField.translatesAutoresizingMaskIntoConstraints = false
            secondaryTextField.textColor = SettingsViewCellSecondaryTextColor
            secondaryTextField.font = UIFont(name: "OpenSans", size: 14.0)
            secondaryTextField.returnKeyType = .done
            secondaryTextField.isUserInteractionEnabled = false // no name changes yet
            
        case .detailed:
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.font = UIFont(name: "OpenSans", size: 14.0)
            
            secondaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
            secondaryTextLabel.textColor = SettingsViewCellSecondaryTextColor
            secondaryTextLabel.font = UIFont(name: "OpenSans", size: 14.0)
            secondaryTextLabel.backgroundColor = ClearColor
            
            disclosureIndicator.translatesAutoresizingMaskIntoConstraints = false
            disclosureIndicator.image = UIImage(named: "disclosureindicator")
            disclosureIndicator.contentMode = .scaleAspectFit
            
        case .switch:
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.font = UIFont(name: "OpenSans", size: 14.0)
        
            settingSwitch.translatesAutoresizingMaskIntoConstraints = false
            settingSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        case .logout:
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.font = UIFont(name: "OpenSans", size: 14.0)
            titleLabel.textColor = UIColor.red()
        }
        
        super.init(style: .default, reuseIdentifier: "SettingsCell")
        
        switch cellType {
        case .default:
            addSubview(titleLabel)
            addSubview(disclosureIndicator)
            break
        case .nondisclosure:
            secondaryTextField.delegate = self
            addSubview(titleLabel)
            addSubview(secondaryTextField)
            break
        case .detailed:
            addSubview(titleLabel)
            addSubview(secondaryTextLabel)
            addSubview(disclosureIndicator)
            break
        case .switch:
            addSubview(titleLabel)
            addSubview(settingSwitch)
            break
        case .logout:
            addSubview(titleLabel)
            break
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let newName = textField.text {
            delegate?.didFinishEditingName(newName)
        }
        
        textField.resignFirstResponder()
        return true
    }

    func setupLayout() {
        switch cellType {
        case .default:
            addConstraints([
                titleLabel.al_left == al_left + 15,
                titleLabel.al_centerY == al_centerY,
                
                disclosureIndicator.al_right == al_right - 10,
                disclosureIndicator.al_centerY == al_centerY,
                disclosureIndicator.al_width == 16,
                disclosureIndicator.al_height == 16
            ])
            break
        case .nondisclosure:
            addConstraints([
                titleLabel.al_left == al_left + 15,
                titleLabel.al_centerY == al_centerY,
                
                secondaryTextField.al_right == al_right - 13,
                secondaryTextField.al_centerY == al_centerY
            ])
            break
        case .detailed:
//            addConstraints([
//                titleLabel.al_left == al_left + 15,
//                titleLabel.al_centerY == al_centerY,
//                
//                secondaryTextLabel.al_width == 125,
//                secondaryTextLabel.al_right == disclosureIndicator.al_left - 10,
//                secondaryTextLabel.al_centerY == al_centerY,
//                
//                disclosureIndicator.al_right == al_right - 10,
//                disclosureIndicator.al_centerY == al_centerY,
//                disclosureIndicator.al_width == 16,
//                disclosureIndicator.al_height == 16
//            ])
            break
        case .switch:
            addConstraints([
                titleLabel.al_left == al_left + 15,
                titleLabel.al_centerY == al_centerY,
                
                settingSwitch.al_right  == al_right - 10,
                settingSwitch.al_centerY == al_centerY
            ])
            break
        case .logout:
            addConstraints([
                titleLabel.al_centerX == al_centerX,
                titleLabel.al_centerY == al_centerY
            ])
            break
        }
    }
}

enum SettingsCellType {
    case `default`
    case nondisclosure
    case detailed
    case `switch`
    case logout
}


protocol TableViewCellDelegate {
    func didFinishEditingName(_ newName: String)
}
