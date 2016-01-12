//
//  ContainerNavigationController.swift
//  Often
//
//  Created by Kervins Valcourt on 12/23/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class ContainerNavigationController: UINavigationController {
    var statusBarBackground: UIView!

    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: ContainerNavigationBar.self, toolbarClass: nil)
        self.pushViewController(rootViewController, animated: false)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.translucent = false
        
        statusBarBackground = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 20))
        statusBarBackground.backgroundColor = WhiteColor
        view.addSubview(statusBarBackground)

        let backNavImage = UIImage(named: "backnavigation")?.imageWithAlignmentRectInsets(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        UITextField.appearance().font = UIFont(name: "OpenSans-Semibold", size: 12)
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UINavigationBar.appearance().backIndicatorImage = backNavImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backNavImage
        UINavigationBar.appearance().tintColor = BlackColor
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSFontAttributeName: UIFont.systemFontOfSize(0.1),
            NSForegroundColorAttributeName: UIColor.clearColor()
            ], forState: .Normal)
    }
}
