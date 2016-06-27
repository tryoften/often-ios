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

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false

        let backNavImage = StyleKit.imageOfBackarrow(frame: CGRect(x: 0, y: 0, width: 22, height: 22), color: WhiteColor, scale: 0.5, selected: false, rotate: 0)

        UITextField.appearance().font = UIFont(name: "OpenSans-Semibold", size: 12)

        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barTintColor = UIColor.white()
        navBarAppearance.backIndicatorImage = backNavImage
        navBarAppearance.backIndicatorTransitionMaskImage = backNavImage
        navBarAppearance.tintColor = UIColor.white()
        navBarAppearance.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBarAppearance.barStyle = .black
        navBarAppearance.shadowImage = UIImage()
        navBarAppearance.backgroundColor = UIColor.clear()
        navBarAppearance.isTranslucent = true

        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -60), for: .default)
        
        if let font = UIFont(name: "Montserrat-Regular", size: 12) {
            UINavigationBar.appearance().titleTextAttributes = [
                NSFontAttributeName: font
            ]
        }
        
        view.layer.zPosition = 1000
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}
