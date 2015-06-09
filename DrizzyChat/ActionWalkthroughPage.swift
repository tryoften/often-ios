//
//  ActionWalkthroughPage.swift
//  Drizzy
//
//  Created by Luc Success on 2/8/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class ActionWalkthroughPage: WalkthroughPage {
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        self.type = .ActionPage
    }
    
    override func setupPage() {
    }
    
    override func pageDidHide() {
        delegate?.walkthroughPage(self, shouldHideControls: false)
    }
    
    override func pageDidShow() {
        delegate?.walkthroughPage(self, shouldHideControls: true)
    }

}
