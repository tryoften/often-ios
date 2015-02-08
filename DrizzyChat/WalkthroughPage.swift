//
//  WalkthroughPage.swift
//  Drizzy
//
//  Created by Luc Success on 1/19/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

func isIPhone5() -> Bool {
    var screen = UIScreen.mainScreen()
    
    if screen.scale == 2.0 && CGRectGetHeight(screen.bounds) <= 568 {
        return true
    }
    return false
}

class WalkthroughPage: UIView {
    
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var imageViews: [UIImageView]?
    var type: WalkthroughPageType!
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Lato-Regular", size: (isIPhone5()) ? 22 : 30)
        titleLabel.textColor = UIColor(fromHexString: "#39474b")
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.textAlignment = .Center
        
        subtitleLabel = UILabel()
        subtitleLabel.font = UIFont(name: "Lato-light", size: (isIPhone5()) ? 15 : 20)
        subtitleLabel.textColor = UIColor(fromHexString: "#91989a")
        subtitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        subtitleLabel.textAlignment = .Center
        subtitleLabel.numberOfLines = 2
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        setupPage()
        setupLayout()
    }
    
    func setupLayout() {
        addConstraints([
            titleLabel.al_top == al_top + (isIPhone5() ? 40 : 60),
            titleLabel.al_width == al_width,
            titleLabel.al_height == 50,
            titleLabel.al_centerX == al_centerX,
            
            subtitleLabel.al_top == titleLabel.al_bottom + (isIPhone5() ? 0 : 20),
            subtitleLabel.al_width == al_width - 40,
            subtitleLabel.al_centerX == al_centerX
        ])
    }
    
    func setupPage() {}
    
    func pageDidShow() {}
    
    func pageWillShow() {}
    
    func pageWillHide() {}
    
    func pageDidHide() {}

    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}
