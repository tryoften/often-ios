//
//  KeyboardBrowsePackItemViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 4/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Material
import Nuke

class KeyboardBrowsePackItemViewController: BaseBrowsePackItemViewController, KeyboardMediaItemPackPickerViewControllerDelegate, UITabBarDelegate {
    private var packServiceListener: Listener? = nil
    var tabBar: BrowsePackTabBar
    
    init(viewModel: PacksService, textProcessor: TextProcessingManager?) {
        tabBar = BrowsePackTabBar(highlightBarEnabled: true)
        
        super.init(viewModel: viewModel, textProcessor: textProcessor)
        
        collectionView?.registerClass(MediaItemsSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier)
        
        tabBar.delegate = self
        packViewModel.delegate = self
        showLoadingView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardBrowsePackItemViewController.onOrientationChanged), name: KeyboardOrientationChangeEvent, object: nil)
        
        packCollectionListener = viewModel.didUpdatePacks.on { items in
            self.hideLoadingView()
            self.collectionView?.reloadData()
        }
        
        if let navigationBar = navigationBar {
            navigationBar.removeFromSuperview()
        }

        if packViewModel.typeFilter == .Gif {
            tabBar.selectedItem = tabBar.items![BrowsePackTabType.Gifs.rawValue]
        } else {
            tabBar.selectedItem = tabBar.items![BrowsePackTabType.Quotes.rawValue]
        }
        
        tabBar.lastSelectedTab = tabBar.selectedItem
        
        view.addSubview(tabBar)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardBrowsePackItemViewController.didReceiveMemoryWarning), name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didReceiveMemoryWarning() {
        ImageManager.shared.removeAllCachedImages()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tabBar.frame = CGRectMake(view.bounds.origin.x, view.bounds.height - 44.5, view.bounds.width, 44.5)
    }
    
    override func loadPackData() {
        super.loadPackData()
    }
    
    func onOrientationChanged() {
        collectionView?.performBatchUpdates(nil, completion: nil)
    }

    func togglePack() {
        let packsVC = KeyboardMediaItemPackPickerViewController(viewModel: PacksService.defaultInstance)
        packsVC.delegate = self
        presentViewCotntrollerWithCustomTransitionAnimator(packsVC, direction: .Left, duration: 0.2)
    }

    func keyboardMediaItemPackPickerViewControllerDidSelectPack(packPicker: KeyboardMediaItemPackPickerViewController, pack: PackMediaItem) {
        PacksService.defaultInstance.switchCurrentPack(pack.id)
        loadPackData()
    }
    
    override func categoriesCollectionViewControllerDidSwitchCategory(CategoriesViewController: CategoryCollectionViewController, category: Category, categoryIndex: Int) {
        SessionManagerFlags.defaultManagerFlags.lastCategoryIndex = categoryIndex
    }
    
    override func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        super.mediaItemGroupViewModelDataDidLoad(viewModel, groups: groups)
        
        guard let viewModel = viewModel as? PackItemViewModel, _ = viewModel.pack else {
            return
        }
        
        hideLoadingView()
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard let group = packViewModel.getMediaItemGroupForCurrentType() else {
            return CGSizeZero
        }
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        switch group.type {
        case .Gif:
            var width: CGFloat
            if screenHeight > screenWidth {
                width = screenWidth/2 - 12.5
            } else {
                width = screenWidth/3 - 12.5
            }
            let height = width * (4/7)
            return CGSizeMake(width, height)
        case .Quote:
            return CGSizeMake(screenWidth, 75)
        default:
            return CGSizeZero
        }
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            // Create Header
            if let sectionView: MediaItemsSectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaItemsSectionHeaderView {
                
                guard let packsService = viewModel as? PacksService, let pack = packsService.pack,
                    let mediaItemTitleText = pack.name, let category =  viewModel.currentCategory else {
                        return sectionView
                }

                if let imageURL = self.packViewModel.pack?.smallImageURL {
                    sectionView.artistImageURL = imageURL
                }

                sectionView.leftText = mediaItemTitleText
                sectionView.rightText = category.name
                return sectionView
            }
        }
        
        return UICollectionReusableView()
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if packViewModel.typeFilter == .Gif {
            return UIEdgeInsets(top: 9.0, left: 9.0, bottom: 60.0, right: 9.0)
        }
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        guard let type = BrowsePackTabType(rawValue: item.tag) else {
            return
        }
        
        switch type {
        case .Keyboard:
            NSNotificationCenter.defaultCenter().postNotificationName(SwitchKeyboardEvent, object: nil)
        case .Gifs:
            packViewModel.typeFilter = .Gif
            self.tabBar.lastSelectedTab = item
        case .Quotes:
            packViewModel.typeFilter = .Quote
            self.tabBar.lastSelectedTab = item
        case .Categories:
            toggleCategoryViewController()
            self.tabBar.selectedItem = self.tabBar.lastSelectedTab
        case .Packs:
            togglePack()
            self.tabBar.selectedItem = self.tabBar.lastSelectedTab
        case .Delete:
            textProcessor?.deleteBackward()
        }
    }
}
