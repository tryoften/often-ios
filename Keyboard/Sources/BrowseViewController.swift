//
//  BrowseViewController.swift
//  Often
//
//  Created by Luc Succes on 12/8/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//
//  swiftlint:disable line_length

import UIKit


let cellReuseIdentifier = "cell"
let lyricsCellReuseIdentifier = "lyricsCell"
let artistsCellReuseIdentifier = "artistsCell"
let songCellReuseIdentifier = "songCell"

class BrowseViewController: MediaItemGroupsViewController,
    MediaItemGroupViewModelDelegate,
    CellAnimatable,
    ConnectivityObservable {
    var isNetworkReachable: Bool = true
    var errorDropView: DropDownMessageView
    var searchViewController: SearchViewController?
    var hudTimer: NSTimer?

    override init(collectionViewLayout: UICollectionViewLayout = BrowseViewController.getLayout(),
        viewModel: BrowseViewModel, textProcessor: TextProcessingManager?) {
        errorDropView = DropDownMessageView()
        errorDropView.text = "NO INTERNET FAM :("
        errorDropView.hidden = true
        
        super.init(collectionViewLayout: collectionViewLayout, viewModel: viewModel, textProcessor: textProcessor)

        viewModel.delegate = self
        self.textProcessor = textProcessor

        collectionView?.contentInset = UIEdgeInsetsMake(2 * KeyboardSearchBarHeight + 2, 0, 0, 0)

    #if !(KEYBOARD)
        hudTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "showHud", userInfo: nil, repeats: false)
    #endif
        setupSearchBar()
            
        view.addSubview(errorDropView)
        
        startMonitoring()
    }

    func setupSearchBar() {
        let baseURL = Firebase(url: BaseURL)
        searchViewController = SearchViewController(
            viewModel: SearchViewModel(base: baseURL),
            suggestionsViewModel: SearchSuggestionsViewModel(base: baseURL),
            textProcessor: self.textProcessor!,
            SearchBarControllerClass: KeyboardSearchBarController.self,
            SearchBarClass: KeyboardSearchBar.self)

        guard let searchViewController = searchViewController else {
            return
        }

        if let keyboardSearchBarController = searchViewController.searchBarController as? KeyboardSearchBarController {
            keyboardSearchBarController.textProcessor = textProcessor!
        }

        addChildViewController(searchViewController)
        view.addSubview(searchViewController.view)
        view.addSubview(searchViewController.searchBarController.view)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateReachabilityStatusBar()
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        guard let group = viewModel.groupAtIndex(section) else {
            return UIEdgeInsetsZero
        }

        switch group.type {
        case .Track:
            return UIEdgeInsets(top: 10, left: 10, bottom: 50, right: 10)
        default:
            return UIEdgeInsetsZero
        }
    }

    override func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        #if !(KEYBOARD)
            hideHud()
        #endif

        if !displayedData {
            collectionView?.reloadData()
            displayedData = true
        } else {
            collectionView?.performBatchUpdates({
                let range = NSMakeRange(0, viewModel.groups.count)
                self.collectionView?.reloadSections(NSIndexSet(indexesInRange: range))
            }, completion: nil)

        }
    }
    
    // MARK: ConnectivityObservable
    func updateReachabilityStatusBar() {
        if isNetworkReachable {
            UIView.animateWithDuration(0.3, animations: {
                self.errorDropView.frame = CGRectMake(0, -40, UIScreen.mainScreen().bounds.width, 40)
            })
            
        } else {
            UIView.animateWithDuration(0.3, animations: {
                self.errorDropView.frame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, 40)
            })
            
            errorDropView.hidden = false
        }
    }

#if !(KEYBOARD)
    func showHud() {
        hudTimer?.invalidate()
        if !displayedData {
            PKHUD.sharedHUD.contentView = HUDProgressView()
            PKHUD.sharedHUD.show()
            hudTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "hideHud", userInfo: nil, repeats: false)
        }

    }

    func hideHud() {
        PKHUD.sharedHUD.hide(animated: true)
        hudTimer?.invalidate()
    }
#endif

#if KEYBOARD
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
        isFullAccessGranted()
    }

    func isFullAccessGranted() {
        let isFullAccessEnabled = UIPasteboard.generalPasteboard().isKindOfClass(UIPasteboard)

        if !isFullAccessEnabled {
            showEmptyStateViewForState(.NoKeyboard, completion: { view -> Void in
                view.primaryButton.hidden = true
            })
            
        } else {
            hideEmptyStateView()
        }
    }

    override func showNavigationBar(animated: Bool) {
        if shouldSendScrollEvents {
            setNavigationBarOriginY(0, animated: true)
        }
    }

    override func hideNavigationBar(animated: Bool) {
        if shouldSendScrollEvents {
            var top = -2 * CGRectGetHeight(tabBarFrame)
            if searchViewController?.searchBarController.searchBar.selected == true {
                top = -CGRectGetHeight(tabBarFrame)
            }

            setNavigationBarOriginY(top, animated: true)
        }
    }

    override func setNavigationBarOriginY(y: CGFloat, animated: Bool) {
    }
#endif
}