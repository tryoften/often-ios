//
//  BrowseCategoryPanelAnimator.swift
//  Often
//
//  Created by Komran Ghahremani on 6/20/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class BrowseCategoryPanelAnimator: FadeInTransitionAnimator, UIViewControllerTransitioningDelegate {
    private let presenting: Bool
    private let duration: NSTimeInterval
    private var tintView = UIView()
    private var whiteView = UIView()
    
    init(presenting: Bool, duration: NSTimeInterval = 0.25) {
        self.presenting = presenting
        self.duration = duration
        
        super.init(presenting: presenting, direction: .Right, duration: duration)
    }
    
    @objc override func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey), let transitionContextContainerView = transitionContext.containerView()  else {
                return
        }
    
        let screenWidth = UIScreen.mainScreen().bounds.width
        let lastViewControllerFrame = CGRectMake(fromViewController.view.bounds.origin.x, fromViewController.view.bounds.origin.y, fromViewController.view.bounds.width, fromViewController.view.bounds.height)
        
        let tintViewFrame = CGRectMake(fromViewController.view.bounds.origin.x + (screenWidth * 0.45), fromViewController.view.bounds.origin.y + 21.0 + 44.0, (fromViewController.view.bounds.width - screenWidth * 0.45), fromViewController.view.bounds.height - 21.0 - 44.0)
        let whiteViewFrame = CGRectMake(fromViewController.view.bounds.origin.x, fromViewController.view.bounds.origin.y + 22.0 + 44.0, screenWidth * 0.45, fromViewController.view.bounds.height - 22.0 - 44.0)
        
        tintView = UIView(frame: tintViewFrame)
        whiteView = UIView(frame: whiteViewFrame)
        
        tintView.alpha = 0
        whiteView.alpha = 0
        
        tintView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.54)
        whiteView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.80)
        
        if presenting {
            transitionContextContainerView.addSubview(tintView)
            transitionContextContainerView.addSubview(whiteView)
            transitionContextContainerView.addSubview(toViewController.view)
            
            toViewController.view.alpha = 0
            toViewController.view.frame = lastViewControllerFrame
            toViewController.view.frame.origin.x -= lastViewControllerFrame.width
            
        }
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, options: .CurveEaseIn, animations: {
            if self.presenting {
                fromViewController.view.userInteractionEnabled = false
                fromViewController.view.tintAdjustmentMode = .Normal
                toViewController.view.alpha = 1
                
                self.tintView.alpha = 1
                self.whiteView.alpha = 1
                
                toViewController.view.frame.origin.x += lastViewControllerFrame.width
                
            } else {
                self.tintView.alpha = 0
                transitionContextContainerView.alpha = 0
                
                toViewController.view.userInteractionEnabled = true
                toViewController.view.tintAdjustmentMode = .Automatic
                
                fromViewController.view.alpha = 1
                fromViewController.view.frame.origin.x -= lastViewControllerFrame.width
            }
            
            }, completion: { (finished) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}
