//
//  BrowseCollectionViewController.swift
//  Often
//
//  Created by Luc Succes on 1/10/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class BrowseCollectionViewController: MediaItemsCollectionBaseViewController,
    KeyboardBrowseNavigationDelegate {
    class var cellHeight: CGFloat {
        return 105.0
    }

    var navigationBar: KeyboardBrowseNavigationBar
    var navigationBarHideConstraint: NSLayoutConstraint?

    init() {
        navigationBar = KeyboardBrowseNavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false

        super.init(collectionViewLayout: self.dynamicType.provideCollectionViewLayout())

        navigationBar.browseDelegate = self
        view.addSubview(navigationBar)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = VeryLightGray
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

        navigationController?.hidesBarsOnSwipe = false
        containerViewController?.resetPosition()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        navigationController?.hidesBarsOnSwipe = true
    }

    class func provideCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, cellHeight)
        layout.minimumLineSpacing = 7.0
        layout.minimumInteritemSpacing = 5.0

        #if KEYBOARD
            let topMargin = CGFloat(115.0)
        #else
            let topMargin = CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame) + CGFloat(60.0)
        #endif

        layout.sectionInset = UIEdgeInsetsMake(topMargin, 0.0, 30.0, 0.0)
        return layout
    }

    // MARK: KeyboardBrowseNavigationDelegate
    func backButtonSelected() {
        navigationController?.popViewControllerAnimated(true)
    }

    override func setNavigationBarOriginY(y: CGFloat, animated: Bool) {
        guard let containerViewController = containerViewController else {
            return
        }

        var frame = tabBarFrame
        var searchBarFrame = navigationBar.frame
        let tabBarHeight = CGRectGetHeight(frame)

        searchBarFrame.origin.y =  fmax(fmin(KeyboardSearchBarHeight + y, KeyboardSearchBarHeight), 0)
        frame.origin.y = fmax(fmin(y, 0), -tabBarHeight)

        navigationBarHideConstraint?.constant = searchBarFrame.origin.y

        UIView.animateWithDuration(animated ? 0.1 : 0) {
            self.view.layoutSubviews()
            containerViewController.tabBar.frame = frame
        }
    }

    func setupLayout() {
        #if KEYBOARD
            let topMargin = KeyboardSearchBarHeight
        #else
            let topMargin = CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)
        #endif

        navigationBarHideConstraint = navigationBar.al_top == view.al_top + topMargin

        view.addConstraints([
            navigationBarHideConstraint!,
            navigationBar.al_left == view.al_left,
            navigationBar.al_right == view.al_right,
            navigationBar.al_height == 64
        ])
    }
}
