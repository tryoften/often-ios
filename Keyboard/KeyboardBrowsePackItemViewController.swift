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
    var fullAccessButton: UIButton?

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
            self?.tabBar.updateTabBarSelectedItem()
            self?.packViewModel.checkCurrentPackContents()
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

        delay(0.5) {
            self.showLocalPackIfNeeded()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tabBar.frame = CGRectMake(view.bounds.origin.x, view.bounds.height - 44.5, view.bounds.width, 44.5)
    }

    func showLocalPackIfNeeded() {
        if !isFullAccessEnabled {
            PacksService.defaultInstance.fetchLocalData()
            hideEmptyStateView()
            hideLoadingView()
            showFullAccessButton()
        } else {
            hideFullAccessButton()
            hideEmptyStateView()
        }
    }

    func showFullAccessButton() {
        self.fullAccessButton?.removeFromSuperview()
        self.fullAccessButton = nil
        CGRectMake(0, KeyboardTabBarHeight, view.bounds.width, KeyboardTabBarHeight)
        fullAccessButton = UIButton(frame: CGRectMake(0, view.bounds.height - 2 * KeyboardTabBarHeight, view.bounds.width, KeyboardTabBarHeight))
        fullAccessButton?.setTitle("please allow full access to get the full often keyboard experience", forState: .Normal)
        fullAccessButton?.backgroundColor = UIColor.oftVividPurpleColor()
        fullAccessButton?.alpha = 0.75
        fullAccessButton?.titleLabel!.font = UIFont(name: "Montserrat", size: 11)
        fullAccessButton?.setTitleColor(WhiteColor , forState: .Normal)
        fullAccessButton?.addTarget(self, action: #selector(KeyboardBrowsePackItemViewController.didTapGoToSettingsButton), forControlEvents: .TouchUpInside)

        if let fullAccessButton = fullAccessButton {
            view.addSubview(fullAccessButton)
        }
    }

    func hideFullAccessButton() {
        UIView.animateWithDuration(0.3, animations: {
            self.fullAccessButton?.alpha = 0.0
            }, completion: { done in
                self.fullAccessButton?.removeFromSuperview()
                self.fullAccessButton = nil
        })

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
        let packsVC = KeyboardMediaItemPackPickerViewController(viewModel: PacksService.defaultInstance, textProcessor: textProcessor)
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


    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let group = packViewModel.getMediaItemGroupForCurrentType() else {
            return UICollectionViewCell()
        }

        if !isFullAccessEnabled {
            switch group.type {
            case .Gif:
                guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(gifCellReuseIdentifier, forIndexPath: indexPath) as? GifCollectionViewCell else {
                    return UICollectionViewCell()
                }

                guard let gif = group.items[indexPath.row] as? GifMediaItem else {
                    return cell
                }

                if let path = NSBundle.mainBundle().pathForResource("gif:\(gif.id)", ofType: "gif") {
                    do {
                        let gifData = try NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
                        cell.setImageWithData(gifData)

                    } catch _ {

                    }
                }

                cell.mediaLink = gif
                cell.delegate = self
                return cell
            case .Quote:
                let cell = parseMediaItemData(group.items, indexPath: indexPath, collectionView: collectionView)
                cell.style = .Cell
                cell.type = .NoMetadata
                return cell
            default:
                return UICollectionViewCell()
            }
        } else {
            return super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        }
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
            self.tabBar.selectedItem = self.tabBar.lastSelectedTab
        case .Gifs:
            if PacksService.defaultInstance.doesCurrentPackContainTypeForCategory(.Gif) {
                collectionView?.setContentOffset(CGPointZero, animated: true)
                packViewModel.typeFilter = .Gif
                self.tabBar.lastSelectedTab = item
            } else {
                packViewModel.typeFilter = .Quote
                self.tabBar.selectedItem = self.tabBar.lastSelectedTab
            }
        case .Quotes:
            if PacksService.defaultInstance.doesCurrentPackContainTypeForCategory(.Quote) {
                 collectionView?.setContentOffset(CGPointZero, animated: true)
                packViewModel.typeFilter = .Quote
                self.tabBar.lastSelectedTab = item
            } else {
                self.tabBar.selectedItem = self.tabBar.lastSelectedTab
                packViewModel.typeFilter = .Gif
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
        super.mediaItemGroupViewModelDataDidLoad(viewModel, groups: groups)

        guard let viewModel = viewModel as? PackItemViewModel, _ = viewModel.pack else {
            return
        }
        
        hideLoadingView()
    }

}
