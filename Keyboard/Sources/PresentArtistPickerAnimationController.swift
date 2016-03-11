//
//  PresentArtistPickerAnimationController.swift
//  Often
//
//  Created by Luc Succes on 3/7/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PresentArtistPickerAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? KeyboardFavoritesViewController,
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? BrowseArtistCollectionViewController,
            let containerView = transitionContext.containerView() else {
            return
        }

        let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)
        let bounds = UIScreen.mainScreen().bounds
        toViewController.view.frame = CGRectOffset(finalFrameForVC, 0, bounds.size.height)
        containerView.addSubview(toViewController.view)

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .CurveLinear, animations: {
            fromViewController.view.alpha = 0.5
            toViewController.view.frame = finalFrameForVC
            }, completion: {
                finished in
                transitionContext.completeTransition(true)
                fromViewController.view.alpha = 1.0
        })
    }
}