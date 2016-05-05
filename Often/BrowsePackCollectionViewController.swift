//
//  BrowsePackContainerViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 3/23/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class BrowsePackCollectionViewController: MediaItemsViewController, ConnectivityObservable {
    var headerView: BrowsePackHeaderView?
    var sectionHeaderView: BrowsePackSectionHeaderView?
    var packServiceListener: Listener?
    var isNetworkReachable: Bool = true
    var reachabilityView: DropDownMessageView
    var screenWidth: CGFloat
    
    init(viewModel: PacksViewModel) {
        screenWidth = UIScreen.mainScreen().bounds.width
        
        reachabilityView = DropDownMessageView()
        reachabilityView.text = "no internet connection".uppercaseString
        reachabilityView.frame = CGRectMake(0, -35, screenWidth, 35)
        
        super.init(collectionViewLayout: BrowsePackCollectionViewController.getLayout(),
                   collectionType: .Packs,
                   viewModel: viewModel)

        let brandLabel = UILabel(frame: CGRectMake(0, 0, 64, 20))
        brandLabel.textAlignment = .Center
        brandLabel.setTextWith(UIFont(name: "Montserrat-Regular", size: 15)!,
                               letterSpacing: 2.0,
                               color: UIColor.oftBlackColor(),
                               text: "OFTEN")

        navigationItem.titleView = brandLabel

        packServiceListener = PacksService.defaultInstance.didUpdateCurrentMediaItem.on { [weak self] items in
            self?.collectionView?.reloadData()
        }
        
        view.addSubview(reachabilityView)
        startMonitoring()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.backgroundColor = VeryLightGray
            collectionView.showsVerticalScrollIndicator = false
            collectionView.registerClass(BrowsePackHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "header")
            collectionView.registerClass(BrowsePackSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "section-header")
        }
    }

    class func getLayout() -> UICollectionViewLayout {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSizeMake(screenWidth, 0)
        flowLayout.parallaxHeaderReferenceSize = CGSizeMake(screenWidth, 370)
        flowLayout.itemSize = CGSizeMake(screenWidth / 2 - 16.5, 225) /// height of the cell
        flowLayout.parallaxHeaderAlwaysOnTop = false
        flowLayout.disableStickyHeaders = false
        flowLayout.minimumInteritemSpacing = 6.0
        flowLayout.minimumLineSpacing = 6.0
        flowLayout.sectionInset = UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)
        return flowLayout
    }

    deinit {
        packServiceListener = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = .Default
        navigationController?.navigationBar.tintColor = WhiteColor
        navigationController?.navigationBar.barTintColor = MainBackgroundColor
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateReachabilityView()
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as? BrowsePackHeaderView else {
                return UICollectionViewCell()
            }
            
            if headerView == nil {
                headerView = cell
                addChildViewController(cell.browsePicker)
            }
            return headerView!
        } else if kind == UICollectionElementKindSectionHeader {
            guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "section-header", forIndexPath: indexPath) as? BrowsePackSectionHeaderView else {
                return UICollectionViewCell()
            }
            
            sectionHeaderView = cell
            
            return cell
        }
        
        return UICollectionReusableView()
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        super.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)

        if collectionType == .Packs {
            let result = viewModel.mediaItemGroupItemsForIndex(indexPath.section)[indexPath.row]
            guard let pack = result as? PackMediaItem, let id = pack.pack_id else {
                return
            }

            let packVC = MainAppBrowsePackItemViewController(viewModel: PackItemViewModel(packId: id), textProcessor: nil)
            navigationController?.navigationBar.hidden = false
            navigationController?.pushViewController(packVC, animated: true)
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 9.0 as CGFloat
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0 as CGFloat
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        return CGSizeMake(screenWidth, 35.0)
        
    }
    
    //MARK: ConnectivityObservable
    func updateReachabilityView() {
        if isNetworkReachable {
            UIView.animateWithDuration(0.3, animations: {
                self.reachabilityView.frame = CGRectMake(0, -35, self.screenWidth, 35)
            })
        } else {
            UIView.animateWithDuration(0.3, animations: {
                self.reachabilityView.frame = CGRectMake(0, 0, self.screenWidth, 35)
            })
        }
    }
}
