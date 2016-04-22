//
//  FadeInTransitionAnimator.swift
//  Often
//
//  Created by Kervins Valcourt on 3/10/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

enum FadeInTransitionDirection {
    case Up
    case Down
    case Left
    case Right
    case None
}

class FadeInTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let presenting: Bool
    private let fadeInTransitionDirection: FadeInTransitionDirection
    private let duration: NSTimeInterval

    init(presenting: Bool, direction: FadeInTransitionDirection = .None, duration: NSTimeInterval = 0.15) {
        self.presenting = presenting
        self.duration = duration
        fadeInTransitionDirection = direction
    }
    
    @objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }

    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey), let transitionContextContainerView = transitionContext.containerView()  else {
                return
        }

        let lastViewControllerFrame = CGRectMake(fromViewController.view.bounds.origin.x, fromViewController.view.bounds.origin.y,  fromViewController.view.bounds.width, fromViewController.view.bounds.height)
        let tintView = UIView(frame: lastViewControllerFrame)

        tintView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.54)

        if presenting {
            transitionContextContainerView.addSubview(tintView)
            transitionContextContainerView.addSubview(toViewController.view)

            toViewController.view.alpha = 0
            toViewController.view.frame = lastViewControllerFrame

            switch fadeInTransitionDirection {
            case .Up:
                toViewController.view.frame.origin.y += toViewController.view.frame.height
            case .Down:
                toViewController.view.frame.origin.y -= toViewController.view.frame.height
            case .Left:
                toViewController.view.frame.origin.x +=  toViewController.view.frame.width
            case .Right:
                toViewController.view.frame.origin.x -=  toViewController.view.frame.width
            case .None:
                break
            }
            
        }
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, options: .CurveEaseIn, animations: {
            if self.presenting {
                fromViewController.view.userInteractionEnabled = false
                fromViewController.view.tintAdjustmentMode = .Normal
                toViewController.view.alpha = 1
                tintView.alpha = 1

                switch self.fadeInTransitionDirection {
                case .Up:
                    toViewController.view.frame.origin.y -= toViewController.view.frame.height
                case .Down:
                    toViewController.view.frame.origin.y += toViewController.view.frame.height
                case .Left:
                    toViewController.view.frame.origin.x -=  toViewController.view.frame.width
                case .Right:
                    toViewController.view.frame.origin.x +=  toViewController.view.frame.width
                case .None:
                    break
                }
            } else {
                transitionContextContainerView.alpha = 0
                toViewController.view.userInteractionEnabled = true
                toViewController.view.tintAdjustmentMode = .Automatic
                fromViewController.view.alpha = 0
            }

            }, completion: { (finished) -> Void in
                transitionContext.completeTransition(true)
        })
    }

}