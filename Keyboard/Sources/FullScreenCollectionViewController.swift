//
//  UIScrollView+NJKScrollFullScreen.swift
//  Often
//
//  Created by Luc Succes on 12/16/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class FullScreenCollectionViewController: UICollectionViewController, NJKScrollFullscreenDelegate {
    var scrollProxy: NJKScrollFullScreen?
    var shouldSendScrollEvents: Bool = true

    var tabBarFrame: CGRect {
        guard let containerViewController = containerViewController else {
            return CGRectZero
        }

        return containerViewController.tabBar.frame
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollProxy = NJKScrollFullScreen(forwardTarget: nil)
        scrollProxy?.delegate = self
    }

    // MARK: UIScrollViewDelegate

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollProxy?.scrollViewDidScroll(scrollView)
    }

    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollProxy?.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }

    override func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        guard let scrollProxy = scrollProxy else {
            return false
        }
        return scrollProxy.scrollViewShouldScrollToTop(scrollView)
    }

    // MARK: NJKScrollFullscreenDelegate
    func scrollFullScreen(fullScreenProxy: NJKScrollFullScreen!, scrollViewDidScrollUp deltaY: CGFloat) {
        moveNavigationBar(deltaY, animated: true)
    }

    func scrollFullScreen(fullScreenProxy: NJKScrollFullScreen!, scrollViewDidScrollDown deltaY: CGFloat) {
        moveNavigationBar(deltaY, animated: true)
    }

    func scrollFullScreenScrollViewDidEndDraggingScrollDown(fullScreenProxy: NJKScrollFullScreen!) {
        showNavigationBar(true)
    }

    func scrollFullScreenScrollViewDidEndDraggingScrollUp(fullScreenProxy: NJKScrollFullScreen!) {
        hideNavigationBar(true)
    }

#if KEYBOARD
    func showNavigationBar(animated: Bool) {
        if shouldSendScrollEvents {
            setNavigationBarOriginY(0, animated: true)
        }
    }

    func hideNavigationBar(animated: Bool) {
        if shouldSendScrollEvents {
            let top = -CGRectGetHeight(tabBarFrame)
            setNavigationBarOriginY(top, animated: true)
        }
    }

    func moveNavigationBar(deltaY: CGFloat, animated: Bool) {
        let frame = tabBarFrame
        let nextY = frame.origin.y + deltaY

        if shouldSendScrollEvents {
            setNavigationBarOriginY(nextY, animated: animated)
        }
    }

    func setNavigationBarOriginY(y: CGFloat, animated: Bool) {
        guard let containerViewController = containerViewController else {
            return
        }

        var frame = tabBarFrame
        let tabBarHeight = CGRectGetHeight(frame)

        frame.origin.y = fmax(fmin(y, 0), -tabBarHeight + 2)

        UIView.animateWithDuration(animated ? 0.1 : 0) {
            containerViewController.tabBar.frame = frame
        }
    }
#endif
}