//
//  KeyboardBrowsePackItemViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 4/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Nuke

class KeyboardBrowsePackItemViewController: BaseBrowsePackItemViewController, KeyboardMediaItemPackPickerViewControllerDelegate, UITabBarDelegate {
    private var packServiceListener: Listener? = nil
    var tabBar: BrowsePackTabBar
    var backspaceDelayTimer: NSTimer?
    var backspaceRepeatTimer: NSTimer?
    let backspaceDelay: NSTimeInterval = 0.5
    let backspaceRepeat: NSTimeInterval = 0.07
    var backspaceStartTime: CFAbsoluteTime!
    var firstWordQuickDeleted: Bool = false

    private let isFullAccessEnabled = UIPasteboard.generalPasteboard().isKindOfClass(UIPasteboard)
    
    init(viewModel: PacksService, textProcessor: TextProcessingManager?) {
        tabBar = BrowsePackTabBar(highlightBarEnabled: true)
        
        super.init(viewModel: viewModel, textProcessor: textProcessor)
        
        collectionView?.registerClass(MediaItemsSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier)
        
        tabBar.delegate = self
        packViewModel.delegate = self
        showLoadingView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardBrowsePackItemViewController.onOrientationChanged), name: KeyboardOrientationChangeEvent, object: nil)
        
        packCollectionListener = viewModel.didUpdateCurrentMediaItem.on { [weak self] items in
            self?.hideLoadingView()
            self?.collectionView?.reloadData()
        }
        
        if let navigationBar = navigationBar {
            navigationBar.removeFromSuperview()
        }

        tabBar.updateTabBarSelectedItem()
        
        view.addSubview(tabBar)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardBrowsePackItemViewController.didReceiveMemoryWarning), name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
    }

    deinit {
        packCollectionListener?.stopListening()
        packServiceListener?.stopListening()
        packServiceListener = nil
        packCollectionListener = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didReceiveMemoryWarning() {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showFullAccessMessageIfNeeded()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tabBar.frame = CGRectMake(view.bounds.origin.x, view.bounds.height - 44.5, view.bounds.width, 44.5)
    }

    func showFullAccessMessageIfNeeded() {
        if !isFullAccessEnabled {
            showEmptyStateViewForState(.NoKeyboard, completion: { view in
                view.primaryButton.setTitle("Go To Settings", forState: .Normal)
                view.imageViewTopConstraint?.constant = -100
                view.titleLabel.text = "You forgot to allow Full-Access"
                view.primaryButton.addTarget(self, action: #selector(KeyboardBrowsePackItemViewController.didTapGoToSettingsButton), forControlEvents: .TouchUpInside)
                self.view.bringSubviewToFront(view)
                self.view.bringSubviewToFront(self.tabBar)
            })

        } else {
            hideEmptyStateView()
        }
    }

    func didTapGoToSettingsButton() {
        let appSettingsString = "prefs:root=General&path=Keyboard/KEYBOARDS"
        if let appSettings = NSURL(string: appSettingsString) {
            self.openURL(appSettings)
        }
    }

    func openURL(url: NSURL) {
        do {
            let application = try BaseKeyboardContainerViewController.sharedApplication(self)
            application.performSelector(#selector(KeyboardMediaItemPackPickerViewController.openURL(_:)), withObject: url)
        }
        catch {

        }
    }

    func onOrientationChanged() {
        collectionView?.performBatchUpdates(nil, completion: nil)
    }

    func togglePack() {
        let packsVC = KeyboardMediaItemPackPickerViewController(viewModel: PacksService.defaultInstance)
        packsVC.delegate = self
        presentViewControllerWithCustomTransitionAnimator(packsVC, direction: .Left, duration: 0.2)
    }

    func keyboardMediaItemPackPickerViewControllerDidSelectPack(packPicker: KeyboardMediaItemPackPickerViewController, pack: PackMediaItem) {
        collectionView?.setContentOffset(CGPointZero, animated: true)
        PacksService.defaultInstance.switchCurrentPack(pack.id)
        loadPackData()
    }
    
    override func categoriesCollectionViewControllerDidSwitchCategory(CategoriesViewController: CategoryCollectionViewController, category: Category, categoryIndex: Int) {
        collectionView?.setContentOffset(CGPointZero, animated: true)
        SessionManagerFlags.defaultManagerFlags.lastCategoryIndex = categoryIndex
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
                width = screenWidth / 2 - 12.5
            } else {
                width = screenWidth / 3 - 12.5
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

                sectionView.artistImageView.image = nil

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

        if !isFullAccessEnabled {
            if type == .Keyboard {
                NSNotificationCenter.defaultCenter().postNotificationName(SwitchKeyboardEvent, object: nil)
            }
            return
        }
        
        switch type {
        case .Keyboard:
            NSNotificationCenter.defaultCenter().postNotificationName(SwitchKeyboardEvent, object: nil)
            self.tabBar.selectedItem = self.tabBar.lastSelectedTab
        case .Gifs:
            if PacksService.defaultInstance.doesCurrentPackContainType(.Gif) {
                collectionView?.setContentOffset(CGPointZero, animated: true)
                packViewModel.typeFilter = .Gif
                self.tabBar.lastSelectedTab = item
            } else {
                self.tabBar.selectedItem =  self.tabBar.lastSelectedTab
            }
        case .Quotes:
            if PacksService.defaultInstance.doesCurrentPackContainType(.Quote) {
                 collectionView?.setContentOffset(CGPointZero, animated: true)
                packViewModel.typeFilter = .Quote
                self.tabBar.lastSelectedTab = item
            } else {
                self.tabBar.selectedItem =  self.tabBar.lastSelectedTab
            }
        case .Categories:
            toggleCategoryViewController()
            self.tabBar.selectedItem = self.tabBar.lastSelectedTab
        case .Packs:
            togglePack()
            self.tabBar.selectedItem = self.tabBar.lastSelectedTab
        case .Delete:
           textProcessor?.deleteBackward()
           
           self.tabBar.selectedItem = self.tabBar.lastSelectedTab
        }
    }

    override func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        if isFullAccessEnabled {
            super.mediaItemGroupViewModelDataDidLoad(viewModel, groups: groups)
        }
        showFullAccessMessageIfNeeded()

        guard let viewModel = viewModel as? PackItemViewModel, _ = viewModel.pack else {
            return
        }

        hideLoadingView()
        tabBar.updateTabBarSelectedItem()
    }


}
