//
//  ContainerNavigationController.swift
//  Often
//
//  Created by Kervins Valcourt on 12/23/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class ContainerNavigationController: UINavigationController, UINavigationControllerDelegate {
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

    override func setNavigationBarHidden(hidden: Bool, animated: Bool) {
//        super.setNavigationBarHidden(hidden, animated: animated)

        UIView.animateWithDuration(animated ? 0.2 : 0.0) {
            self.statusBarBackground.alpha = hidden ? 0.0 : 1.0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.translucent = false
        
        statusBarBackground = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 20))
        statusBarBackground.backgroundColor = WhiteColor
        view.addSubview(statusBarBackground)

        var backNavImage = StyleKit.imageOfBackarrow(frame: CGRectMake(-20, 10, 44, 44), color: UIColor.whiteColor(), scale: 0.5, selected: false)
//        backNavImage.imageWithAlignmentRectInsets(UIEdgeInsets(top: 10, left: 30, bottom: 0, right: 0))

        UITextField.appearance().font = UIFont(name: "OpenSans-Semibold", size: 12)
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UINavigationBar.appearance().backIndicatorImage = backNavImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backNavImage
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barStyle = .Black
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSFontAttributeName: UIFont.systemFontOfSize(0.1),
            NSForegroundColorAttributeName: UIColor.clearColor()
        ], forState: .Normal)
    }

    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}
