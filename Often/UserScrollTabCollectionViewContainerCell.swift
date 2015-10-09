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
        tabScrollView.translatesAutoresizingMaskIntoConstraints = false
        tabScrollView.pagingEnabled = true
        
        leftScrollContainerView = UIView(frame: CGRectMake(0, 0, frame.width, frame.height))
        leftScrollContainerView.translatesAutoresizingMaskIntoConstraints = false
        leftScrollContainerView.backgroundColor = WhiteColor
        
        rightScrollContainerView = UIView(frame: CGRectMake(frame.width, 0, frame.width, frame.height))
        rightScrollContainerView.translatesAutoresizingMaskIntoConstraints = false
        rightScrollContainerView.backgroundColor = WhiteColor
        
        userFavoritesCollectionViewController = UserFavoritesCollectionViewController()
        userRecentsCollectionViewController = UserRecentsCollectionViewController()
        
        super.init(frame: frame)
        
        tabScrollView.delegate = self
        tabScrollView.frame = CGRectMake(0, 0, frame.width, frame.height)
        
        leftScrollContainerView.addSubview(userFavoritesCollectionViewController.view)
        rightScrollContainerView.addSubview(userRecentsCollectionViewController.view)
        
        tabScrollView.addSubview(leftScrollContainerView)
        tabScrollView.addSubview(rightScrollContainerView)
        addSubview(tabScrollView)
        
        tabScrollView.contentSize = CGSizeMake(tabScrollView.frame.width * 2, tabScrollView.frame.height)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetX: CGFloat = scrollView.contentOffset.x
        
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
    
    func setupLayout() {
        
    }
}

// lets the cell send info to the main view controller
protocol UserScrollTabCellDelegate {
    func userScrollViewDidScroll(offsetX: CGFloat)
}
