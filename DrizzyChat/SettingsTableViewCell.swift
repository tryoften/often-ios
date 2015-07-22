//
//  SettingsTableViewCell.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 7/1/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    var labelView: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        labelView = UILabel()
        labelView.setTranslatesAutoresizingMaskIntoConstraints(false)
        labelView.textAlignment = .Center
        labelView.font = SettingsTableViewCellLabelViewTextFont
        labelView.textColor = SettingsTableViewCellLabelViewTextColor
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = SettingsTableViewCellBackgroundColor
        selectionStyle = UITableViewCellSelectionStyle.None
        
        addSubview(labelView)
        
        setupLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setupLayout() {
        addConstraints([
            labelView.al_centerX == al_centerX,
            labelView.al_centerY == al_centerY,
        ])
    }
}
