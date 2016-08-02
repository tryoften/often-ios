//
//  PresentingRootViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 7/28/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PresentingRootViewController: UIViewController, UITabBarControllerDelegate, UIViewControllerTransitioningDelegate {
    var transitionAnimator: FadeInTransitionAnimator?

    func presentRootViewController(rootVC: RootViewController) {
        rootVC.delegate = self
        presentViewController(rootVC, animated: true, completion: nil)
    }

    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if viewController == tabBarController.viewControllers?[1] {
            let vc = AddContentViewController()
            transitionAnimator = FadeInTransitionAnimator(presenting: true, duration: 0.1)
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .Custom

            tabBarController.presentViewController(vc, animated: true, completion: nil)

            return false
        }
        
        return true
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let animator = transitionAnimator {
            return animator
        } else {
            return FadeInTransitionAnimator(presenting: true)
        }
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = FadeInTransitionAnimator(presenting: false)

        return animator
    }
}