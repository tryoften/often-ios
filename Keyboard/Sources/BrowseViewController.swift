//
//  BrowseViewController.swift
//  Often
//
//  Created by Luc Succes on 12/8/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//
//  swiftlint:disable line_length

import UIKit
import MediaPlayer


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
//    var searchViewController: SearchViewController?

    var topPadding: CGFloat {
        if let topPadding = collectionView?.contentInset.top {
            return topPadding
        }

        return 0.0
    }

    var barHeight: CGFloat {
        return MediaItemsSectionHeaderHeight
    }

    override init(collectionViewLayout: UICollectionViewLayout = BrowseViewController.getLayout(),
        viewModel: BrowseViewModel, textProcessor: TextProcessingManager?) {
        errorDropView = DropDownMessageView()
        errorDropView.text = "NO INTERNET FAM :("
        errorDropView.hidden = true
        
        super.init(collectionViewLayout: collectionViewLayout, viewModel: viewModel, textProcessor: textProcessor)

        viewModel.delegate = self
        self.textProcessor = textProcessor

        collectionView?.contentInset = UIEdgeInsetsMake(2 * KeyboardSearchBarHeight + 2, 0, 0, 0)

        setupSearchBar()
        view.addSubview(errorDropView)
        startMonitoring()
    }

    func setupSearchBar() {

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateReachabilityView()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateReachabilityView()
    }

    func onOrientationChanged() {
        collectionView?.performBatchUpdates(nil, completion: nil)
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

        if !displayedData {
            collectionView?.reloadData()
            displayedData = true
        } else {
            collectionView?.performBatchUpdates({
                let range = NSMakeRange(0, viewModel.mediaItemGroups.count)
                self.collectionView?.reloadSections(NSIndexSet(indexesInRange: range))
            }, completion: nil)

        }
    }
    
    // MARK: ConnectivityObservable
    func updateReachabilityView() {
        if isNetworkReachable {
            UIView.animateWithDuration(0.3, animations: {
                self.errorDropView.frame = CGRectMake(0, -self.topPadding, UIScreen.mainScreen().bounds.width, self.barHeight)
            })

            delay(0.5) {
                self.errorDropView.hidden = true
            }
            
        } else {
            UIView.animateWithDuration(0.3, animations: {
                self.errorDropView.frame = CGRectMake(0, self.topPadding, UIScreen.mainScreen().bounds.width, self.barHeight)
            })
            
            errorDropView.hidden = false
        }
    }
}