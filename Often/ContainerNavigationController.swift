//
//  ContainerNavigationController.swift
//  Often
//
//  Created by Kervins Valcourt on 12/23/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class ContainerNavigationController: UINavigationController, UINavigationControllerDelegate {

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

        let backNavImage = StyleKit.imageOfBackarrow(frame: CGRectMake(0, 0, 22, 22), color: WhiteColor, scale: 0.5, selected: false, rotate: 0)

        UITextField.appearance().font = UIFont(name: "OpenSans-Semibold", size: 12)

        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barTintColor = UIColor.whiteColor()
        navBarAppearance.backIndicatorImage = backNavImage
        navBarAppearance.backIndicatorTransitionMaskImage = backNavImage
        navBarAppearance.tintColor = UIColor.whiteColor()
        navBarAppearance.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navBarAppearance.barStyle = .Black
        navBarAppearance.shadowImage = UIImage()
        navBarAppearance.backgroundColor = UIColor.clearColor()
        navBarAppearance.translucent = true

        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -60), forBarMetrics: .Default)
        
        if let font = UIFont(name: "Montserrat-Regular", size: 12) {
            UINavigationBar.appearance().titleTextAttributes = [
                NSFontAttributeName: font
            ]
        }
        
        view.layer.zPosition = 1000
    }

    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}
