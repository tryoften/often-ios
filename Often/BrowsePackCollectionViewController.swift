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
        screenWidth = UIScreen.main().bounds.width
        
        reachabilityView = DropDownMessageView()
        reachabilityView.text = "no internet connection".uppercased()
        reachabilityView.frame = CGRect(x: 0, y: -35, width: screenWidth, height: 35)
        
        super.init(collectionViewLayout: BrowsePackCollectionViewController.getLayout(),
                   collectionType: .Packs,
                   viewModel: viewModel)

        let brandLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 64, height: 20))
        brandLabel.textAlignment = .center
        brandLabel.setTextWith(UIFont(name: "Montserrat-Regular", size: 15)!,
                               letterSpacing: 2.0,
                               color: UIColor.oftBlackColor(),
                               text: "OFTEN")

        navigationItem.titleView = brandLabel

        packServiceListener = PacksService.defaultInstance.didUpdateCurrentMediaItem.on { [weak self] items in
            self?.collectionView?.reloadData()
        }
        
        NotificationCenter.default().addObserver(self, selector: #selector(BrowsePackCollectionViewController.didClickPackLink(_:)), name: "didClickPackLink", object: nil)
        
        view.addSubview(reachabilityView)
        startMonitoring()
    }
    
    func didClickPackLink(_ notification: Foundation.Notification) {
        if let id = (notification as NSNotification).userInfo!["packid"] as? String {
            let packVC = MainAppBrowsePackItemViewController(viewModel: PackItemViewModel(packId: id), textProcessor: nil)
            navigationController?.navigationBar.isHidden = false
            navigationController?.pushViewController(packVC, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionView = collectionView {
            collectionView.backgroundColor = VeryLightGray
            collectionView.showsVerticalScrollIndicator = false
            collectionView.register(BrowsePackHeaderView.self, forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, withReuseIdentifier: "header")
            collectionView.register(BrowsePackSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "section-header")
        }
    }

    class func getLayout() -> UICollectionViewLayout {
        let screenWidth = UIScreen.main().bounds.size.width
        let flowLayout = CSStickyHeaderFlowLayout()
        flowLayout.parallaxHeaderMinimumReferenceSize = CGSize(width: screenWidth, height: 0)
        flowLayout.parallaxHeaderReferenceSize = CGSize(width: screenWidth, height: 370)
        flowLayout.itemSize = CGSize(width: screenWidth / 2 - 16.5, height: 225) /// height of the cell
        flowLayout.parallaxHeaderAlwaysOnTop = false
        flowLayout.disableStickyHeaders = false
        flowLayout.minimumInteritemSpacing = 6.0
        flowLayout.minimumLineSpacing = 6.0
        flowLayout.sectionInset = UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)
        return flowLayout
    }

    deinit {
        packServiceListener = nil
        NotificationCenter.default().removeObserver(self)
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
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared().setStatusBarHidden(false, with: .none)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = WhiteColor
        navigationController?.navigationBar.barTintColor = MainBackgroundColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateReachabilityView()
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == CSStickyHeaderParallaxHeader {
            guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? BrowsePackHeaderView else {
                return UICollectionViewCell()
            }
            
            if headerView == nil {
                headerView = cell
                addChildViewController(cell.browsePicker)
            }
            return headerView!
        } else if kind == UICollectionElementKindSectionHeader {
            guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "section-header", for: indexPath) as? BrowsePackSectionHeaderView else {
                return UICollectionViewCell()
            }
            
            sectionHeaderView = cell
            
            return cell
        }
        
        return UICollectionReusableView()
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)

        if collectionType == .Packs {
            let result = viewModel.mediaItemGroupItemsForIndex((indexPath as NSIndexPath).section)[(indexPath as NSIndexPath).row]
            guard let pack = result as? PackMediaItem, let id = pack.pack_id else {
                return
            }

            let packVC = MainAppBrowsePackItemViewController(viewModel: PackItemViewModel(packId: id), textProcessor: nil)
            navigationController?.navigationBar.isHidden = false
            navigationController?.pushViewController(packVC, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 9.0 as CGFloat
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0 as CGFloat
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenWidth = UIScreen.main().bounds.size.width
        return CGSize(width: screenWidth, height: 35.0)
        
    }
    
    //MARK: ConnectivityObservable
    func updateReachabilityView() {
        if isNetworkReachable {
            UIView.animate(withDuration: 0.3, animations: {
                self.reachabilityView.frame = CGRect(x: 0, y: -35, width: self.screenWidth, height: 35)
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.reachabilityView.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: 35)
            })
        }
    }
}
