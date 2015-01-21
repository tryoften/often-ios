//
//  WalkthroughPage.swift
//  Drizzy
//
//  Created by Luc Success on 1/19/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class WalkthroughPage: UIView {
    
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Lato-Regular", size: 30)
        titleLabel.textColor = UIColor(fromHexString: "#39474b")
//        titleLabel.textColor = UIColor.blackColor()
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.textAlignment = .Center
        
        subtitleLabel = UILabel()
        subtitleLabel.font = UIFont(name: "Lato-light", size: 20)
        subtitleLabel.textColor = UIColor(fromHexString: "#91989a")
        subtitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        subtitleLabel.textAlignment = .Center
        subtitleLabel.numberOfLines = 2
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        setupLayout()
    }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_top == al_top + 60,
            titleLabel.al_width == al_width,
            titleLabel.al_height == 50,
            titleLabel.al_centerX == al_centerX,
            
            subtitleLabel.al_top == titleLabel.al_bottom + 20,
            subtitleLabel.al_width == al_width - 40,
            subtitleLabel.al_centerX == al_centerX
        ])
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}
