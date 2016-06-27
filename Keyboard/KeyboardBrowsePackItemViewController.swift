//
//  KeyboardBrowsePackItemViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 4/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit
import Nuke

class KeyboardBrowsePackItemViewController: BaseBrowsePackItemViewController, KeyboardMediaItemPackPickerViewControllerDelegate, UITabBarDelegate {
    private var packServiceListener: Listener? = nil
    var tabBar: BrowsePackTabBar

//    private let isFullAccessEnabled = UIPasteboard.general().isKind(of: UIPasteboard)
    private let isFullAccessEnabled = true

    init(viewModel: PacksService, textProcessor: TextProcessingManager?) {
        tabBar = BrowsePackTabBar(highlightBarEnabled: true)
        
        super.init(viewModel: viewModel, textProcessor: textProcessor)
        
        collectionView?.register(MediaItemsSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier)
        
        tabBar.delegate = self
        packViewModel.delegate = self
        showLoadingView()
        
        NotificationCenter.default().addObserver(self, selector: #selector(KeyboardBrowsePackItemViewController.onOrientationChanged), name: KeyboardOrientationChangeEvent, object: nil)
        
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
        NotificationCenter.default().addObserver(self, selector: #selector(KeyboardBrowsePackItemViewController.didReceiveMemoryWarning), name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: nil)
    }

    deinit {
        packServiceListener = nil
        packCollectionListener = nil
        NotificationCenter.default().removeObserver(self)
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
            self.showFullAccessMessageIfNeeded()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tabBar.frame = CGRect(x: view.bounds.origin.x, y: view.bounds.height - 44.5, width: view.bounds.width, height: 44.5)
    }

    func showFullAccessMessageIfNeeded() {
        if !isFullAccessEnabled {
            hideLoadingView()
            showEmptyStateViewForState(.noKeyboard, completion: { view in
                view.imageViewTopConstraint?.constant = -100
                view.titleLabel.text = "You forgot to allow Full-Access"
                view.primaryButton.addTarget(self, action: #selector(KeyboardBrowsePackItemViewController.didTapGoToSettingsButton), for: .touchUpInside)
                self.view.bringSubview(toFront: view)
                self.view.bringSubview(toFront: self.tabBar)
            })
        } else {
            hideEmptyStateView()
        }
    }

    func didTapGoToSettingsButton() {
        let appSettingsString = "prefs:root=General&path=Keyboard/KEYBOARDS"
        if let appSettings = URL(string: appSettingsString) {
            self.openURL(appSettings)
        }
    }

    func openURL(_ url: URL) {
        do {
            let application = try BaseKeyboardContainerViewController.sharedApplication(self)
            application.perform(#selector(KeyboardMediaItemPackPickerViewController.openURL(_:)), with: url)
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
        presentViewControllerWithCustomTransitionAnimator(packsVC, direction: .left, duration: 0.2)
    }

    func keyboardMediaItemPackPickerViewControllerDidSelectPack(_ packPicker: KeyboardMediaItemPackPickerViewController, pack: PackMediaItem) {
        collectionView?.setContentOffset(CGPoint.zero, animated: true)
        PacksService.defaultInstance.switchCurrentPack(pack.id)
        loadPackData()
    }
    
    override func categoriesCollectionViewControllerDidSwitchCategory(_ CategoriesViewController: CategoryCollectionViewController, category: Category, categoryIndex: Int) {
        collectionView?.setContentOffset(CGPoint.zero, animated: true)
        SessionManagerFlags.defaultManagerFlags.lastCategoryIndex = categoryIndex
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let group = packViewModel.getMediaItemGroupForCurrentType() else {
            return CGSize.zero
        }
        
        let screenWidth = UIScreen.main().bounds.width
        let screenHeight = UIScreen.main().bounds.height
        
        switch group.type {
        case .Gif:
            var width: CGFloat

            if screenHeight > screenWidth {
                width = screenWidth / 2 - 12.5
            } else {
                width = screenWidth / 3 - 12.5
            }

            let height = width * (4/7)
            return CGSize(width: width, height: height)
        case .Quote:
            return CGSize(width: screenWidth, height: 75)
        default:
            return CGSize.zero
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            // Create Header
            if let sectionView: MediaItemsSectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, for: indexPath) as? MediaItemsSectionHeaderView {

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
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if packViewModel.typeFilter == .Gif {
            return UIEdgeInsets(top: 9.0, left: 9.0, bottom: 60.0, right: 9.0)
        }
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let type = BrowsePackTabType(rawValue: item.tag) else {
            return
        }

        if !isFullAccessEnabled {
            if type == .keyboard {
                NotificationCenter.default().post(name: Foundation.Notification.Name(rawValue: SwitchKeyboardEvent), object: nil)
            }
            return
        }
        
        switch type {
        case .keyboard:
            NotificationCenter.default().post(name: Foundation.Notification.Name(rawValue: SwitchKeyboardEvent), object: nil)
            self.tabBar.selectedItem = self.tabBar.lastSelectedTab
        case .gifs:
            if PacksService.defaultInstance.doesCurrentPackContainTypeForCategory(.Gif) {
                collectionView?.setContentOffset(CGPoint.zero, animated: true)
                packViewModel.typeFilter = .Gif
                self.tabBar.lastSelectedTab = item
            } else {
                packViewModel.typeFilter = .Quote
                self.tabBar.selectedItem = self.tabBar.lastSelectedTab
            }
        case .quotes:
            if PacksService.defaultInstance.doesCurrentPackContainTypeForCategory(.Quote) {
                 collectionView?.setContentOffset(CGPoint.zero, animated: true)
                packViewModel.typeFilter = .Quote
                self.tabBar.lastSelectedTab = item
            } else {
                self.tabBar.selectedItem = self.tabBar.lastSelectedTab
                packViewModel.typeFilter = .Gif
            }
        case .categories:
            toggleCategoryViewController()
            self.tabBar.selectedItem = self.tabBar.lastSelectedTab
        case .packs:
            togglePack()
            self.tabBar.selectedItem = self.tabBar.lastSelectedTab
        case .delete:
           textProcessor?.deleteBackward()
           
           self.tabBar.selectedItem = self.tabBar.lastSelectedTab
        }
    }

    override func mediaItemGroupViewModelDataDidLoad(_ viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        if isFullAccessEnabled {
            super.mediaItemGroupViewModelDataDidLoad(viewModel, groups: groups)
        }

        guard let viewModel = viewModel as? PackItemViewModel, _ = viewModel.pack else {
            return
        }

        hideLoadingView()
    }

}
