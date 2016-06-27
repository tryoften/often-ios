//
//  UIScrollView+NJKScrollFullScreen.swift
//  Often
//
//  Created by Luc Succes on 12/16/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class FullScreenCollectionViewController: UICollectionViewController {
    var scrollProxy: NJKScrollFullScreen?
    var shouldSendScrollEvents: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

//        scrollProxy = NJKScrollFullScreen(forwardTarget: nil)
//        scrollProxy?.delegate = self
    }

    // MARK: UIScrollViewDelegate

//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollProxy?.scrollViewDidScroll(scrollView)
//    }
//
//    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        scrollProxy?.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
//    }
//
//    override func scrollViewShouldScroll(toTop scrollView: UIScrollView) -> Bool {
//        guard let scrollProxy = scrollProxy else {
//            return false
//        }
//        return scrollProxy.scrollViewShouldScroll(toTop: scrollView)
//    }

    // MARK: NJKScrollFullscreenDelegate
//    func scrollFullScreen(_ fullScreenProxy: NJKScrollFullScreen!, scrollViewDidScrollUp deltaY: CGFloat) {
//        moveNavigationBar(deltaY, animated: true)
//    }
//
//    func scrollFullScreen(_ fullScreenProxy: NJKScrollFullScreen!, scrollViewDidScrollDown deltaY: CGFloat) {
//        moveNavigationBar(deltaY, animated: true)
//    }
//
//    func scrollFullScreenScrollViewDidEndDraggingScrollDown(_ fullScreenProxy: NJKScrollFullScreen!) {
//        showNavigationBar(true)
//    }
//
//    func scrollFullScreenScrollViewDidEndDraggingScrollUp(_ fullScreenProxy: NJKScrollFullScreen!) {
//        hideNavigationBar(true)
//    }

#if KEYBOARD && !(KEYBOARD_DEBUG)
//    var tabBarFrame: CGRect {
//        guard let containerViewController = containerViewController else {
//            return CGRectZero
//        }
//
//        return containerViewController.tabBar.frame
//    }
//
//    func showNavigationBar(animated: Bool) {
//        if shouldSendScrollEvents {
//            setNavigationBarOriginY(0, animated: true)
//        }
//    }
//
//    func hideNavigationBar(animated: Bool) {
//        if shouldSendScrollEvents {
//            let top = -CGRectGetHeight(tabBarFrame)
//            setNavigationBarOriginY(top, animated: true)
//        }
//    }
//
//    func moveNavigationBar(deltaY: CGFloat, animated: Bool) {
//        let frame = tabBarFrame
//        let nextY = frame.origin.y + deltaY
//
//        if shouldSendScrollEvents {
//            setNavigationBarOriginY(nextY, animated: animated)
//        }
//    }
//
//    func setNavigationBarOriginY(y: CGFloat, animated: Bool) {
//        guard let containerViewController = containerViewController else {
//            return
//        }
//
//        var frame = tabBarFrame
//        let tabBarHeight = CGRectGetHeight(frame)
//
//        frame.origin.y = fmax(fmin(y, 0), -tabBarHeight + 2)
//
//        UIView.animateWithDuration(animated ? 0.1 : 0) {
//            containerViewController.tabBar.frame = frame
//        }
//    }
#else
    var tabBarFrame: CGRect {
        return CGRect.zero
    }

    override func setNavigationBarOriginY(_ y: CGFloat, animated: Bool) { }
#endif
}
