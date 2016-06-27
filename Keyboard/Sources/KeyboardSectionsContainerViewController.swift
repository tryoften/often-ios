//
//  KeyboardSectionsContainerViewController.swift
//  Often
//
//  Created by Luc Succes on 12/14/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit
import MediaPlayer

private let KeyboardSectionCurrentTabKey = "CurrentTabKey"

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

    var currentTab: Int {
        get {
            if let value = UserDefaults.standard().object(forKey: KeyboardSectionCurrentTabKey) as? Int {
                return value
            }
            return 1
        }
        
        set(value) {
            UserDefaults.standard().set(value, forKey: KeyboardSectionCurrentTabKey)
        }
    }

    private var containerView: UIView
    private(set) var tabBarHidden: Bool

    let didChangeTab = Event<UITabBarItem>()

    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers

        tabBar = SlideTabBar(highlightBarEnabled: true)
        tabBar.backgroundColor = WhiteColor
        tabBar.isTranslucent = false
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
                tabBarItem.tag = i
                tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
                i = i + 1
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
        let newScreenWidth = UIScreen.main().bounds.size.width
        if newScreenWidth != oldScreenWidth {
            NotificationCenter.default().post(name: Foundation.Notification.Name(rawValue: KeyboardOrientationChangeEvent), object: self)
            oldScreenWidth = newScreenWidth
        }
    }
    
    func showTabBar(_ animated: Bool, animations: (() -> Void)? = nil) {
        tabBarHidden = false
        positionTabBar(animated, animations: animations)
    }

    func hideTabBar(_ animated: Bool, animations: (() -> Void)? = nil) {
        tabBarHidden = true
        positionTabBar(animated, animations: animations)
    }

    func resetPosition() {
        var frame = tabBar.frame
        frame.origin = CGPoint.zero
        tabBar.frame = frame
    }

    private func positionTabBar(_ animated: Bool = false, animations: (() -> Void)? = nil) {
        if animated {
            UIView.setAnimationDuration(0.3)
            UIView.beginAnimations(nil, context: nil)
        }

        let oldTabBarFrame = tabBar.frame

        if tabBarHidden {
            tabBar.frame = CGRect(x: 0, y: -tabBarHeight, width: view.frame.size.width, height: tabBarHeight)
            containerView.frame = CGRect(x: 0, y: -tabBarHeight, width: view.frame.size.width, height: view.frame.size.height + tabBarHeight)
        } else {
            tabBar.frame = CGRect(x: oldTabBarFrame.origin.x, y: oldTabBarFrame.origin.y, width: view.frame.size.width, height: tabBarHeight)
            containerView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        }

        animations?()

        if animated {
            UIView.commitAnimations()
        }
    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.selectedViewController = viewControllers[item.tag]
        currentTab = item.tag
        didChangeTab.emit(item)
    }

    private func transitionToChildViewController(_ toViewController: UIViewController) {
        let fromViewController: UIViewController? = childViewControllers.count > 0 ? childViewControllers[0] : nil

        if toViewController == fromViewController || !isViewLoaded() {
            return
        }

        let toView = toViewController.view
        toView?.translatesAutoresizingMaskIntoConstraints = true
        toView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toView?.frame = containerView.bounds

        fromViewController?.willMove(toParentViewController: nil)
        addChildViewController(toViewController)

        containerView.addSubview(toViewController.view)
        toViewController.didMove(toParentViewController: self)

        tabBar.isUserInteractionEnabled = false
        fromViewController?.view.removeFromSuperview()
        fromViewController?.removeFromParentViewController()
        toViewController.didMove(toParentViewController: self)
        tabBar.isUserInteractionEnabled = true
    }

    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return selectedViewController
    }
}

@objc protocol KeyboardSectionsContainerViewControllerDelegate {
    func keyboardSectionsContainerViewControllerShouldShowBarShadow(_ containerViewController: KeyboardSectionsContainerViewController) -> Bool
}
