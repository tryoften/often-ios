//
//  UserScrollTabCollectionViewContainerCell.swift
//  Often
//
//  Created by Komran Ghahremani on 9/7/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class UserScrollTabCollectionViewContainerCell: UICollectionViewCell, UIScrollViewDelegate, UserProfileViewControllerDelegate {
    var tabScrollView: UIScrollView
    var leftScrollContainerView: UIView
    var rightScrollContainerView: UIView
    var userFavoritesCollectionViewController: UserFavoritesCollectionViewController
    var userRecentsCollectionViewController: UserRecentsCollectionViewController
    var delegate: UserScrollTabCellDelegate?
    
    override init(frame: CGRect) {
        tabScrollView = UIScrollView()
        tabScrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tabScrollView.pagingEnabled = true
        
        leftScrollContainerView = UIView(frame: CGRectMake(0, 0, frame.width, frame.height))
        leftScrollContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        leftScrollContainerView.backgroundColor = WhiteColor
        
        rightScrollContainerView = UIView(frame: CGRectMake(frame.width, 0, frame.width, frame.height))
        rightScrollContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        rightScrollContainerView.backgroundColor = WhiteColor
        
        userFavoritesCollectionViewController = UserFavoritesCollectionViewController()
        userRecentsCollectionViewController = UserRecentsCollectionViewController()
        
        super.init(frame: frame)
        
        tabScrollView.delegate = self
        tabScrollView.frame = CGRectMake(0, 0, frame.width, frame.height)
        let scrollViewWidth = tabScrollView.frame.width
        let scrollViewHeight = tabScrollView.frame.height
        
        leftScrollContainerView.addSubview(userFavoritesCollectionViewController.view)
        rightScrollContainerView.addSubview(userRecentsCollectionViewController.view)
        
        tabScrollView.addSubview(leftScrollContainerView)
        tabScrollView.addSubview(rightScrollContainerView)
        addSubview(tabScrollView)
        
        tabScrollView.contentSize = CGSizeMake(tabScrollView.frame.width * 2, tabScrollView.frame.height)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offsetX: CGFloat = scrollView.contentOffset.x
        
        if let delegate = delegate {
            delegate.userScrollViewDidScroll(offsetX)
        }
    }
    
    // UserProfileViewControllerDelegate
    func favoritesTabSelected() {
        tabScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    func recentsTabSelected() {
        tabScrollView.setContentOffset(CGPointMake(tabScrollView.frame.width, 0), animated: true)
    }
    
    func setLayout() {
        addConstraints([
            tabScrollView.al_left == al_left,
            tabScrollView.al_right == al_right,
            tabScrollView.al_bottom == al_bottom,
            tabScrollView.al_top == al_top,
            
            leftScrollContainerView.al_left == tabScrollView.al_left,
            leftScrollContainerView.al_top == tabScrollView.al_top,
            leftScrollContainerView.al_bottom == tabScrollView.al_bottom,
            leftScrollContainerView.al_right == tabScrollView.al_centerX,
            
            rightScrollContainerView.al_right == tabScrollView.al_right,
            rightScrollContainerView.al_top == tabScrollView.al_top,
            rightScrollContainerView.al_bottom == tabScrollView.al_bottom,
            rightScrollContainerView.al_left == tabScrollView.al_centerX
        ])
    }
}

// lets the cell send info to the main view controller
protocol UserScrollTabCellDelegate {
    func userScrollViewDidScroll(offsetX: CGFloat)
}
