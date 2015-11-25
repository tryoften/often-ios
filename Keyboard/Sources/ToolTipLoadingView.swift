//
//  ToolTipLoadingView.swift
//  Often
//
//  Created by Komran Ghahremani on 11/3/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class ToolTipLoadingView: UIView {
    var oftenLogo: UIImageView
    
    override init(frame: CGRect) {
        oftenLogo = UIImageView()
        oftenLogo.translatesAutoresizingMaskIntoConstraints = false
        oftenLogo.image = UIImage(named: "tooltiplogo")
        
        super.init(frame: frame)
        
        backgroundColor = VeryLightGray
        
        addSubview(oftenLogo)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func timedEndLoad() {
        delay(0.3, closure: {
            UIView.animateWithDuration(0.3, animations: {
                self.alpha = 0.0
            })
        })
        
        delay(2.5, closure: {
            self.removeFromSuperview()
        })
    }
    
    func setupLayout() {
        addConstraints([
            oftenLogo.al_centerY == al_centerY,
            oftenLogo.al_centerX == al_centerX,
            oftenLogo.al_width == 72,
            oftenLogo.al_height == 20
        ])
    }
}
