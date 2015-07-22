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
        navigationBar.tintColor = NavigationBarColor
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: NavigationBarColor]
        navigationBar.barTintColor = BlackColor
        navigationBar.translucent = false
        navigationBar.backIndicatorImage = UIImage()
        navigationBar.backIndicatorTransitionMaskImage = UIImage()
        navigationBar.titleTextAttributes = [NSFontAttributeName:ButtonFont!,NSForegroundColorAttributeName: NavigationBarColor]
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
