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
import AudioToolbox

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
            if PacksService.defaultInstance.doesPackContainTypeFilter(.Gif) {
                collectionView?.setContentOffset(CGPointZero, animated: true)
                packViewModel.typeFilter = .Gif
                self.tabBar.lastSelectedTab = item
            } else {
                self.tabBar.selectedItem =  self.tabBar.lastSelectedTab
            }
        case .Quotes:
            if PacksService.defaultInstance.doesPackContainTypeFilter(.Quote) {
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
            backspaceDown()
            self.tabBar.selectedItem = self.tabBar.lastSelectedTab
        }
    }

    func cancelBackspaceTimers() {
        backspaceDelayTimer?.invalidate()
        backspaceRepeatTimer?.invalidate()
        backspaceDelayTimer = nil
        backspaceRepeatTimer = nil
        backspaceStartTime = nil
    }

    func backspaceDown() {
        cancelBackspaceTimers()
        backspaceStartTime = CFAbsoluteTimeGetCurrent()
        textProcessor?.deleteBackward()

        // trigger for subsequent deletes
        backspaceDelayTimer = NSTimer.scheduledTimerWithTimeInterval(backspaceDelay - backspaceRepeat, target: self, selector: Selector("backspaceDelayCallback"), userInfo: nil, repeats: false)
    }

    func backspaceUp(button: KeyboardKeyButton?) {
        if let button = button {
            button.selected = false
        }

        cancelBackspaceTimers()
        firstWordQuickDeleted = false
    }

    func backspaceDelayCallback() {
        backspaceDelayTimer = nil
        backspaceRepeatTimer = NSTimer.scheduledTimerWithTimeInterval(backspaceRepeat, target: self, selector: Selector("backspaceRepeatCallback"), userInfo: nil, repeats: true)
    }

    func backspaceRepeatCallback() {
        playKeySound()

        let timeElapsed = CFAbsoluteTimeGetCurrent() - backspaceStartTime
        if timeElapsed < 2.0 {
            textProcessor?.deleteBackward()
        } else {
            backspaceLongPressed()
        }
    }

    func playKeySound() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            AudioServicesPlaySystemSound(1104)
        })
    }

    func backspaceLongPressed() {
        if firstWordQuickDeleted == true {
            NSThread.sleepForTimeInterval(0.4)
        }

        firstWordQuickDeleted = true

        if let documentContextBeforeInput = textProcessor?.currentProxy.documentContextBeforeInput as NSString? {
            if documentContextBeforeInput.length > 0 {
                var charactersToDelete = 0
                switch documentContextBeforeInput {
                // If cursor is next to a letter
                case let stringLeft where NSCharacterSet.letterCharacterSet().characterIsMember(stringLeft.characterAtIndex(stringLeft.length - 1)):
                    let range = documentContextBeforeInput.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet().invertedSet, options: .BackwardsSearch)
                    if range.location != NSNotFound {
                        charactersToDelete = documentContextBeforeInput.length - range.location
                    } else {
                        charactersToDelete = documentContextBeforeInput.length
                    }
                // If cursor is next to a whitespace
                case let stringLeft where stringLeft.hasSuffix(" "):
                    let range = documentContextBeforeInput.rangeOfCharacterFromSet(NSCharacterSet.whitespaceCharacterSet().invertedSet, options: .BackwardsSearch)
                    if range.location != NSNotFound {
                        charactersToDelete = documentContextBeforeInput.length - range.location - 1
                    } else {
                        charactersToDelete = documentContextBeforeInput.length
                    }
                // if there is only one character left
                default:
                    charactersToDelete = 1
                }

                for _ in 0..<charactersToDelete {
                    textProcessor?.deleteBackward()
                }
            }
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
