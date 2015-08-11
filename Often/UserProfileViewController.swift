//
//  UserProfileViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/6/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class UserProfileViewController: UICollectionViewController {
    var headerView: UserProfileHeaderView?
    var sectionHeaderView: UserProfileSectionHeaderView?
    var tableViewsContainerView: UIView
    
    init() {
        userInformationContainerView = UIView()
        userInformationContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        profileImageView = UIImageView()
        profileImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        profileImageView.contentMode = .ScaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 30
        profileImageView.image = UIImage(named: "regy")
        
        nameLabel = UILabel()
        nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        nameLabel.font = UIFont(name: "Montserrat", size: 18.0)
        nameLabel.text = "Regy Perlera"
        nameLabel.textAlignment = .Center
        
        descriptionLabel = UILabel()
        descriptionLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        descriptionLabel.font = UIFont(name: "OpenSans", size: 12.0)
        descriptionLabel.text = "Designer. Co-Founder of @DrizzyApp, Previously @Amazon & @Square. Husting & taking notes."
        descriptionLabel.textAlignment = .Center
        descriptionLabel.numberOfLines = 3
        
        scoreLabel = UILabel()
        scoreLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        scoreLabel.font = UIFont(name: "Montserrat", size: 18.0)
        scoreLabel.text = "583"
        scoreLabel.textAlignment = .Center
        
        scoreNameLabel = UILabel()
        scoreNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        scoreNameLabel.font = UIFont(name: "OpenSans", size: 12.0)
        scoreNameLabel.text = "Source Cred"
        scoreNameLabel.textAlignment = .Center
        
        tableViewsContainerView = UIView()
        tableViewsContainerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableViewsContainerView.backgroundColor = TealColor
        
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(userInformationContainerView)
        userInformationContainerView.addSubview(profileImageView)
        userInformationContainerView.addSubview(nameLabel)
        userInformationContainerView.addSubview(descriptionLabel)
        userInformationContainerView.addSubview(scoreLabel)
        userInformationContainerView.addSubview(scoreNameLabel)
        
        setupLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        var screenWidth = UIScreen.mainScreen().bounds.size.width
        var flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 50)
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, 360)
        flowLayout.parallaxHeaderAlwaysOnTop = true
        flowLayout.disableStickyHeaders = false
        flowLayout.sectionInset = UIEdgeInsetsMake(25.0, 5.0, 5.0, 5.0)
        flowLayout.itemSize = CGSizeMake(screenWidth - 20, 118)
        return flowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.backgroundColor = VeryLightGray
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(UserProfileHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "profile-header")
            collectionView.registerClass(UserProfileSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "section-header")
            collectionView.registerClass(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: "resultCell")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("resultCell", forIndexPath: indexPath) as! SearchResultsCollectionViewCell
        
        cell.avatarImageView.image = UIImage(named: "complex")
        cell.headerLabel.text = "@ComplexMag"
        cell.mainTextLabel.text = "In the heat of the battle, @Drake dropped some new flames in his new track, Charged Up, via..."
        cell.leftSupplementLabel.text = "3.1K Retweets"
        cell.centerSupplementLabel.text = "4.5K Favorites"
        cell.rightSupplementLabel.text = "July 25, 2015"
        cell.rightCornerImageView.image = UIImage(named: "twitter")
        cell.contentImage = UIImage(named: "ovosound")
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "profile-header", forIndexPath: indexPath) as! UserProfileHeaderView
            
            if headerView == nil {
                headerView = cell
            }
            
            return headerView!
        } else if kind == UICollectionElementKindSectionHeader {
            var cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "section-header", forIndexPath: indexPath) as! UserProfileSectionHeaderView
            
            sectionHeaderView = cell
            
            return cell
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5.0 as CGFloat
    }
}
