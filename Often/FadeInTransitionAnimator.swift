//
//  FadeInTransitionAnimator.swift
//  Often
//
//  Created by Kervins Valcourt on 3/10/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

enum FadeInTransitionDirection {
    case up
    case down
    case left
    case right
    case none
}

class FadeInTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let presenting: Bool
    private let fadeInTransitionDirection: FadeInTransitionDirection
    private let duration: TimeInterval

    init(presenting: Bool, direction: FadeInTransitionDirection = .none, duration: TimeInterval = 0.15) {
        self.presenting = presenting
        self.duration = duration
        fadeInTransitionDirection = direction
    }
    
    @objc func transitionDuration(_ transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    @objc func animateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextFromViewControllerKey),
            let toViewController = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey) else {
                return
        }
        
        let transitionContextContainerView = transitionContext.containerView()
        let lastViewControllerFrame = CGRect(x: fromViewController.view.bounds.origin.x, y: fromViewController.view.bounds.origin.y,  width: fromViewController.view.bounds.width, height: fromViewController.view.bounds.height)
        let tintView = UIView(frame: lastViewControllerFrame)

        tintView.backgroundColor = UIColor.black().withAlphaComponent(0.54)

        if presenting {
            transitionContextContainerView.addSubview(tintView)
            transitionContextContainerView.addSubview(toViewController.view)

            toViewController.view.alpha = 0
            toViewController.view.frame = lastViewControllerFrame


            switch fadeInTransitionDirection {
            case .up:
                toViewController.view.frame.origin.y += lastViewControllerFrame.height
            case .down:
                toViewController.view.frame.origin.y -= lastViewControllerFrame.height
            case .left:
                toViewController.view.frame.origin.x += lastViewControllerFrame.width
            case .right:
                toViewController.view.frame.origin.x -= lastViewControllerFrame.width
            case .none:
                break
            }
            
        }
        
        UIView.animate(withDuration: transitionDuration(transitionContext), delay: 0.0, options: .curveEaseIn, animations: {
            if self.presenting {
                fromViewController.view.isUserInteractionEnabled = false
                fromViewController.view.tintAdjustmentMode = .normal
                toViewController.view.alpha = 1
                tintView.alpha = 1

                switch self.fadeInTransitionDirection {
                case .up:
                    toViewController.view.frame.origin.y -= lastViewControllerFrame.height
                case .down:
                    toViewController.view.frame.origin.y += lastViewControllerFrame.height
                case .left:
                    toViewController.view.frame.origin.x -= lastViewControllerFrame.width
                case .right:
                    toViewController.view.frame.origin.x += lastViewControllerFrame.width
                case .none:
                    break
                }
                
            } else {
                transitionContextContainerView.alpha = 0
                toViewController.view.isUserInteractionEnabled = true
                toViewController.view.tintAdjustmentMode = .automatic
                fromViewController.view.alpha = 0
            }

            }, completion: { (finished) -> Void in
                transitionContext.completeTransition(true)
        })
    }

}
