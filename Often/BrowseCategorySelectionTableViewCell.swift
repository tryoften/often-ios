//
//  BrowseCategorySelectionTableViewCell.swift
//  Often
//
//  Created by Komran Ghahremani on 6/16/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class BrowseCategorySelectionTableViewCell: UITableViewCell {
    var categoryLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        categoryLabel = UILabel()
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.textAlignment = .Left
        categoryLabel.backgroundColor = ClearColor
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = ClearColor
        
        addSubview(categoryLabel)
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
    
    func setupLayout() {
        addConstraints([
            categoryLabel.al_centerX == al_centerX,
            categoryLabel.al_centerY == al_centerY
        ])
    }
}
