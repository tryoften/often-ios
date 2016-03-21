//
//  FadeInTransitionAnimator.swift
//  Often
//
//  Created by Kervins Valcourt on 3/10/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class FadeInTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let presenting: Bool

    init(presenting: Bool) {
        self.presenting = presenting
    }
    
    @objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.15
    }

    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey), let transitionContextContainerView = transitionContext.containerView()  else {
                return
        }

        let lastViewControllerFrame = CGRectMake(fromViewController.view.bounds.origin.x, fromViewController.view.bounds.origin.y,  fromViewController.view.bounds.width, fromViewController.view.bounds.height)

        if presenting {
            toViewController.view.frame = lastViewControllerFrame
            toViewController.view.alpha = 0

            transitionContextContainerView.addSubview(toViewController.view)
        }

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, options: .CurveEaseIn, animations: {
            if self.presenting {
                fromViewController.view.userInteractionEnabled = false
                fromViewController.view.tintAdjustmentMode = .Normal
                toViewController.view.alpha = 1
            } else {
                toViewController.view.userInteractionEnabled = true
                toViewController.view.tintAdjustmentMode = .Automatic
                fromViewController.view.alpha = 0
            }

            }, completion: { (finished) -> Void in
                transitionContext.completeTransition(true)
        })
    }

}