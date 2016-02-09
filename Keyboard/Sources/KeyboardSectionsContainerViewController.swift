//
//  KeyboardSectionsContainerViewController.swift
//  Often
//
//  Created by Luc Succes on 12/14/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class KeyboardSectionsContainerViewController: UIViewController, UITabBarDelegate {
    weak var delegate: KeyboardSectionsContainerViewControllerDelegate?
    var oldScreenWidth: CGFloat?

    var viewControllers: [UIViewController] {
        didSet {
            setupViewControllers()
        }
    }

    var tabBarHeight: CGFloat {
        return 44.0
    }

    var tabBar: UITabBar
    var selectedViewController: UIViewController? {
        didSet {
            if let selectedViewController = selectedViewController {
                transitionToChildViewController(selectedViewController)
            }
        }
    }

    var currentTab: Int = 1

    private var containerView: UIView
    private(set) var tabBarHidden: Bool

    let didChangeTab = Event<UITabBarItem>()
    let didChangeOrientation = Signal()

    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers

        tabBar = SlideTabBar(highlightBarEnabled: true)
        tabBar.backgroundColor = WhiteColor
        tabBar.translucent = false
        tabBar.tintColor = BlackColor

        containerView = UIView()
        tabBarHidden = false

        super.init(nibName: nil, bundle: nil)

        tabBar.delegate = self

        view.addSubview(containerView)
        view.addSubview(tabBar)

        setupViewControllers()
    }

    convenience init() {
        self.init(viewControllers: [])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViewControllers() {
        if viewControllers.count > 0 {
            var i = 0
            tabBar.items = viewControllers.map { viewController in

                let tabBarItem = UITabBarItem()
                tabBarItem.image = viewController.tabBarItem.image
                tabBarItem.tag = i++
                tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)

                return tabBarItem
            }

            if let tabBarButtons = tabBar.items {
                tabBar.selectedItem = tabBarButtons[currentTab]
            }

            selectedViewController = viewControllers[currentTab]
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        positionTabBar(false)
        checkOrientation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if viewControllers.count > currentTab {
            selectedViewController = selectedViewController ?? viewControllers[currentTab]

            if let item = tabBar.items?[currentTab] {
                didChangeTab.emit(item)
            }
        }
    }

    func checkOrientation() {
        let newScreenWidth = UIScreen.mainScreen().bounds.height
        if newScreenWidth != oldScreenWidth {
            didChangeOrientation.emit()
            oldScreenWidth = newScreenWidth
        }
    }
    
    func showTabBar(animated: Bool, animations: (() -> Void)? = nil) {
        tabBarHidden = false
        positionTabBar(animated, animations: animations)
    }

    func hideTabBar(animated: Bool, animations: (() -> Void)? = nil) {
        tabBarHidden = true
        positionTabBar(animated, animations: animations)
    }

    func resetPosition() {
        var frame = tabBar.frame
        frame.origin = CGPointZero
        tabBar.frame = frame
    }

    private func positionTabBar(animated: Bool = false, animations: (() -> Void)? = nil) {
        if animated {
            UIView.setAnimationDuration(0.3)
            UIView.beginAnimations(nil, context: nil)
        }

        let oldTabBarFrame = tabBar.frame

        if tabBarHidden {
            tabBar.frame = CGRectMake(0, -tabBarHeight, view.frame.size.width, tabBarHeight)
            containerView.frame = CGRectMake(0, -tabBarHeight, view.frame.size.width, view.frame.size.height + tabBarHeight)
        } else {
            tabBar.frame = CGRectMake(oldTabBarFrame.origin.x, oldTabBarFrame.origin.y, view.frame.size.width, tabBarHeight)
            containerView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        }

        animations?()

        if animated {
            UIView.commitAnimations()
        }
    }

    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        self.selectedViewController = viewControllers[item.tag]
        currentTab = item.tag
        didChangeTab.emit(item)
    }

    private func transitionToChildViewController(toViewController: UIViewController) {
        let fromViewController: UIViewController? = childViewControllers.count > 0 ? childViewControllers[0] : nil

        if toViewController == fromViewController || !isViewLoaded() {
            return
        }

        let toView = toViewController.view
        toView.translatesAutoresizingMaskIntoConstraints = true
        toView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        toView.frame = containerView.bounds

        fromViewController?.willMoveToParentViewController(nil)
        addChildViewController(toViewController)

        containerView.addSubview(toViewController.view)
        toViewController.didMoveToParentViewController(self)

        tabBar.userInteractionEnabled = false
        fromViewController?.view.removeFromSuperview()
        fromViewController?.removeFromParentViewController()
        toViewController.didMoveToParentViewController(self)
        tabBar.userInteractionEnabled = true
    }

    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return selectedViewController
    }
}

@objc protocol KeyboardSectionsContainerViewControllerDelegate {
    func keyboardSectionsContainerViewControllerShouldShowBarShadow(containerViewController: KeyboardSectionsContainerViewController) -> Bool
}