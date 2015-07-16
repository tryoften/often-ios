//
//  BaseNavigationController.swift
//  Drizzy
//
//  Created by Luc Succes on 6/20/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupNavbar() {
        navigationBar.tintColor = WhiteColor
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: WhiteColor]
        navigationBar.barTintColor = BlackColor
        navigationBar.translucent = false
        navigationBar.backIndicatorImage = UIImage()
        navigationBar.backIndicatorTransitionMaskImage = UIImage()
        navigationBar.titleTextAttributes = [NSFontAttributeName:ButtonFont!,NSForegroundColorAttributeName: WhiteColor]
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
