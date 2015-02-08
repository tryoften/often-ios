//
//  SignUpWalkthroughPage.swift
//  Drizzy
//
//  Created by Luc Success on 2/8/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class SignUpWalkthroughPage: WalkthroughPage {

    required init(frame: CGRect) {
        super.init(frame: frame)
        self.type = .SignUpPage
    }
    
    override func setupPage() {
        var covers = [UIImageView]()
        
        var cover1 = UIImageView(image: UIImage(named: "kanye"))
        var cover2 = UIImageView(image: UIImage(named: "kendrick"))
        var cover3 = UIImageView(image: UIImage(named: "tswift"))
        
        covers += [cover1, cover2, cover3]
        
        for cover in covers {
            cover.setTranslatesAutoresizingMaskIntoConstraints(false)
        }
        
        self.addSubview(cover2)
        self.addSubview(cover3)
        self.addSubview(cover1)
        
        var loginView = FacebookButton.button()
        loginView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(loginView)
        
        self.addConstraints([
            cover1.al_top == self.subtitleLabel.al_bottom + 80,
            cover1.al_centerX == self.al_centerX,
            cover1.al_width == CGRectGetWidth(cover1.frame),
            cover1.al_height == CGRectGetHeight(cover1.frame),
            
            cover2.al_width == cover1.al_width * 0.9,
            cover2.al_height == cover1.al_height * 0.9,
            cover2.al_centerY == cover1.al_centerY,
            cover2.al_centerX == cover1.al_centerX - 50,
            
            cover3.al_width == cover1.al_width * 0.9,
            cover3.al_height == cover1.al_height * 0.9,
            cover3.al_centerY == cover1.al_centerY,
            cover3.al_centerX == cover1.al_centerX + 50,
            
            loginView.al_top == cover1.al_bottom + 20,
            loginView.al_centerX == self.al_centerX,
            loginView.al_left == cover2.al_left,
            loginView.al_right == cover3.al_right,
            loginView.al_height == 50
        ])
    }
}
