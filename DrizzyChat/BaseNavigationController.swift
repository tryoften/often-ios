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
        navigationBar.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 54)
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationBar.barTintColor = BlackColor
        navigationBar.translucent = false
        navigationBar.backIndicatorImage = UIImage()
        navigationBar.backIndicatorTransitionMaskImage = UIImage()
        navigationBar.titleTextAttributes = [NSFontAttributeName:ButtonFont!,NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
}
