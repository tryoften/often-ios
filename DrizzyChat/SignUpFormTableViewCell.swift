//
//  SignUpFormTableViewCell.swift
//  Drizzy
//
//  Created by Luc Success on 2/14/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class SignUpFormTableViewCell: UITableViewCell {
    
    var iconView: UILabel!
    var textField: UITextField!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        iconView = UILabel()
        iconView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(iconView)
        
        textField = UITextField()
        textField.setTranslatesAutoresizingMaskIntoConstraints(false)
        textField.font = UIFont(name: "Lato-Regular", size: 16)
        contentView.addSubview(textField)
        
        backgroundColor = UIColor.whiteColor()
        
        setupLayout()
    }
    
    convenience override init() {
        self.init(style: UITableViewCellStyle.Default, reuseIdentifier: "signUpFormTableViewCell")
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(style: UITableViewCellStyle.Default, reuseIdentifier: "signUpFormTableViewCell")
    }
    
    func setupLayout() {
        addConstraints([
            iconView.al_left == contentView.al_left,
            iconView.al_right == textField.al_left,
            iconView.al_top == contentView.al_top,
            iconView.al_bottom == contentView.al_bottom,
            
            textField.al_left == al_left + 50,
            textField.al_right == contentView.al_right,
            textField.al_top == contentView.al_top,
            textField.al_bottom == contentView.al_bottom
        ])
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
