//
//  UserProfileViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/6/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class UserProfileViewController: UICollectionViewController, UserProfileHeaderDelegate {
    var headerView: UserProfileHeaderView?
    var sectionHeaderView: UserProfileSectionHeaderView?
    
    var setServicesRevealView: UIView
    var settingsRevealView: UIView
    var setServiceViewWidthConstraint: NSLayoutConstraint?
    var settingsViewWidthConstraint: NSLayoutConstraint?
    
    var contentFilterTabView: UIView
    var allFilterButton: UIButton
    var songsFilterButton: UIButton
    var videosFilterButton: UIButton
    var linksFilterButton: UIButton
    var gifsFilterButton: UIButton
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(collectionViewLayout: UICollectionViewLayout) {
        contentFilterTabView = UIView()
        contentFilterTabView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentFilterTabView.backgroundColor = WhiteColor
        
        allFilterButton = UIButton()
        allFilterButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        allFilterButton.setTitle("ALL", forState: .Normal)
        allFilterButton.setTitleColor(BlackColor, forState: .Selected)
        allFilterButton.setTitleColor(LightGrey, forState: .Normal)
        allFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10)
        allFilterButton.selected = true
        
        songsFilterButton = UIButton()
        songsFilterButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        songsFilterButton.setTitle("SONGS", forState: .Normal)
        songsFilterButton.setTitleColor(BlackColor, forState: .Selected)
        songsFilterButton.setTitleColor(LightGrey, forState: .Normal)
        songsFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10)
        
        videosFilterButton = UIButton()
        videosFilterButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        videosFilterButton.setTitle("VIDEOS", forState: .Normal)
        videosFilterButton.setTitleColor(BlackColor, forState: .Selected)
        videosFilterButton.setTitleColor(LightGrey, forState: .Normal)
        videosFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10)
        
        linksFilterButton = UIButton()
        linksFilterButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        linksFilterButton.setTitle("LINKS", forState: .Normal)
        linksFilterButton.setTitleColor(BlackColor, forState: .Selected)
        linksFilterButton.setTitleColor(LightGrey, forState: .Normal)
        linksFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10)
        
        gifsFilterButton = UIButton()
        gifsFilterButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        gifsFilterButton.setTitle("GIFS", forState: .Normal)
        gifsFilterButton.setTitleColor(BlackColor, forState: .Selected)
        gifsFilterButton.setTitleColor(LightGrey, forState: .Normal)
        gifsFilterButton.titleLabel?.font = UIFont(name: "Montserrat", size: 10)
        
        setServicesRevealView = UIView()
        setServicesRevealView.setTranslatesAutoresizingMaskIntoConstraints(false)
        setServicesRevealView.backgroundColor = TealColor
        
        settingsRevealView = UIView()
        settingsRevealView.setTranslatesAutoresizingMaskIntoConstraints(false)
        settingsRevealView.backgroundColor = TealColor
        
        setServiceViewWidthConstraint = setServicesRevealView.al_width == 0
        settingsViewWidthConstraint = settingsRevealView.al_width == 0
        
        super.init(collectionViewLayout: collectionViewLayout)
        
        allFilterButton.addTarget(self, action: "filterButtonTapped:", forControlEvents: .TouchUpInside)
        songsFilterButton.addTarget(self, action: "filterButtonTapped:", forControlEvents: .TouchUpInside)
        videosFilterButton.addTarget(self, action: "filterButtonTapped:", forControlEvents: .TouchUpInside)
        linksFilterButton.addTarget(self, action: "filterButtonTapped:", forControlEvents: .TouchUpInside)
        gifsFilterButton.addTarget(self, action: "filterButtonTapped:", forControlEvents: .TouchUpInside)
        
        view.addSubview(setServicesRevealView)
        view.addSubview(settingsRevealView)
        
        view.addSubview(contentFilterTabView)
        contentFilterTabView.addSubview(allFilterButton)
        contentFilterTabView.addSubview(songsFilterButton)
        contentFilterTabView.addSubview(videosFilterButton)
        contentFilterTabView.addSubview(linksFilterButton)
        contentFilterTabView.addSubview(gifsFilterButton)
        
        setupLayout()
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
        
        cell.sourceLogoView.image = UIImage(named: "complex")
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
                headerView?.delegate = self
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
    
    
    func setupLayout() {
        setServiceViewWidthConstraint = setServicesRevealView.al_width == 0
        settingsViewWidthConstraint = settingsRevealView.al_width == 0
        
        view.addConstraints([
            
            setServicesRevealView.al_left == view.al_left,
            setServicesRevealView.al_bottom == view.al_bottom,
            setServicesRevealView.al_top == view.al_top,
            setServiceViewWidthConstraint!,
            
            settingsRevealView.al_right == view.al_right,
            settingsRevealView.al_top == view.al_top,
            settingsRevealView.al_bottom == view.al_bottom,
            settingsViewWidthConstraint!,
            
            contentFilterTabView.al_bottom == view.al_bottom,
            contentFilterTabView.al_left == view.al_left,
            contentFilterTabView.al_right == view.al_right,
            contentFilterTabView.al_height == 50,
            
            allFilterButton.al_top == contentFilterTabView.al_top,
            allFilterButton.al_left == contentFilterTabView.al_left,
            allFilterButton.al_bottom == contentFilterTabView.al_bottom,
            allFilterButton.al_width == UIScreen.mainScreen().bounds.width / 5,
            
            songsFilterButton.al_left == allFilterButton.al_right,
            songsFilterButton.al_top == contentFilterTabView.al_top,
            songsFilterButton.al_bottom == contentFilterTabView.al_bottom,
            songsFilterButton.al_width == UIScreen.mainScreen().bounds.width / 5,
            
            videosFilterButton.al_left == songsFilterButton.al_right,
            videosFilterButton.al_top == contentFilterTabView.al_top,
            videosFilterButton.al_bottom == contentFilterTabView.al_bottom,
            videosFilterButton.al_width == UIScreen.mainScreen().bounds.width / 5,
            
            linksFilterButton.al_left == videosFilterButton.al_right,
            linksFilterButton.al_top == contentFilterTabView.al_top,
            linksFilterButton.al_bottom == contentFilterTabView.al_bottom,
            linksFilterButton.al_width == UIScreen.mainScreen().bounds.width / 5,
            
            gifsFilterButton.al_left == linksFilterButton.al_right,
            gifsFilterButton.al_top == contentFilterTabView.al_top,
            gifsFilterButton.al_bottom == contentFilterTabView.al_bottom,
            gifsFilterButton.al_right == contentFilterTabView.al_right
        ])
    }
    
    //Filter Method
    func filterButtonTapped(button: UIButton) {
        if let title = button.titleLabel?.text {
            switch title {
                case "ALL":
                    if allFilterButton.selected == true {
                        //do nothing
                    } else {
                        allFilterButton.selected = true
                        songsFilterButton.selected = false
                        videosFilterButton.selected = false
                        linksFilterButton.selected = false
                        gifsFilterButton.selected = false
                    }
                    break
                case "SONGS":
                    if songsFilterButton.selected == true {
                        //do nothing
                    } else {
                        allFilterButton.selected = false
                        songsFilterButton.selected = true
                        videosFilterButton.selected = false
                        linksFilterButton.selected = false
                        gifsFilterButton.selected = false
                    }
                    break
                case "VIDEOS":
                    if videosFilterButton.selected == true {
                        //do nothing
                    } else {
                        allFilterButton.selected = false
                        songsFilterButton.selected = false
                        videosFilterButton.selected = true
                        linksFilterButton.selected = false
                        gifsFilterButton.selected = false
                    }
                    break
                case "LINKS":
                    if linksFilterButton.selected == true {
                        //do nothing
                    } else {
                        allFilterButton.selected = false
                        songsFilterButton.selected = false
                        videosFilterButton.selected = false
                        linksFilterButton.selected = true
                        gifsFilterButton.selected = false
                    }
                    break
                case "GIFS":
                    if gifsFilterButton.selected == true {
                        //do nothing
                    } else {
                        allFilterButton.selected = false
                        songsFilterButton.selected = false
                        videosFilterButton.selected = false
                        linksFilterButton.selected = false
                        gifsFilterButton.selected = true
                    }
                    break
            default:
                println("Defaulted")
                break
            }
        }
    }
    
    // User profile header delegate
    func revealSetServicesViewDidTap() {
        revealController.showViewController(leftViewController)
    }
    
    func revealSettingsViewDidTap() {
        revealController.showViewController(rightViewController)
    }
    
    func userFavoritesTabSelected() {
        println("Favorites")
    }
    
    func userRecentsTabSelected() {
        println("Recents")
    }
}
