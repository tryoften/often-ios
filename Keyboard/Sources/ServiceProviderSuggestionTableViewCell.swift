//
//  ServiceProviderSuggestionTableViewCell.swift
//  Often
//
//  Created by Luc Succes on 10/18/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class ServiceProviderSuggestionTableViewCell: SearchSuggestionTableViewCell {
    var serviceProviderLogo: UIImageView
    var serviceProviderLogoImage: UIImage? {
        didSet(value) {
            serviceProviderLogo.image = value
            serviceProviderLogo.setNeedsDisplay()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        serviceProviderLogo = UIImageView()
        serviceProviderLogo.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        resultsCountLabel.hidden = true
        contentView.addSubview(serviceProviderLogo)

        addConstraints([
            serviceProviderLogo.al_right == contentView.al_right - 15,
            serviceProviderLogo.al_centerY == contentView.al_centerY
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        super.setupLayout()
    }
}