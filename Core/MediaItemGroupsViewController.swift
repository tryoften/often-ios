//
//  MediaItemGroupsViewController.swift
//  Often
//
//  Created by Luc Succes on 1/27/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class MediaItemGroupsViewController: MediaItemsCollectionBaseViewController, UICollectionViewDelegateFlowLayout {
    var viewModel: BrowseViewModel
    var displayedData: Bool

    init(collectionViewLayout: UICollectionViewLayout = MediaItemGroupsViewController.getLayout(),
        viewModel: BrowseViewModel, textProcessor: TextProcessingManager? = nil) {
        self.viewModel = viewModel
        displayedData = false

        super.init(collectionViewLayout: collectionViewLayout)
        self.textProcessor = textProcessor

        collectionView?.backgroundColor = VeryLightGray
        collectionView?.registerClass(MediaItemsSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier)

        automaticallyAdjustsScrollViewInsets = false
        extendedLayoutIncludesOpaqueBars = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5.0
        layout.minimumLineSpacing = 5.0
        return layout
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()

        do {
            try viewModel.fetchData()
        } catch _ {}
    }

    internal func groupAtIndex(index: Int) -> MediaItemGroup? {
        return viewModel.groupAtIndex(index)
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return viewModel.mediaItemGroups.count
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let group = groupAtIndex(section) else {
            return 1
        }

        switch group.type {
        case .Track:
            return group.items.count
        default:
            return 1
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let baseSize = CGSizeMake(screenWidth, 115)

        guard let group = groupAtIndex(indexPath.section) else {
            return baseSize
        }

        switch group.type {
        case .Lyric:
            return CGSizeMake(screenWidth, 125)
        case .Artist:
            return CGSizeMake(screenWidth, 230)
        case .Track:
            return CGSizeMake(screenWidth - 20, 74)
        default:
            return baseSize
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        guard let group = groupAtIndex(section) else {
            return UIEdgeInsetsZero
        }

        switch group.type {
        case .Track:
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        default:
            return UIEdgeInsetsZero
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        return CGSizeMake(screenWidth, 36)
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        showNavigationBar(true)

        guard let group = groupAtIndex(indexPath.section),
            let viewModel = viewModel as? BrowseViewModel,
            let item = group.items[indexPath.row] as? MediaItem else {
                return
        }

        switch item.type {
        case .Lyric:
            if let lyric = item as? LyricMediaItem {
                print(lyric)
            }
        default:
            break
        }
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaItemsSectionHeaderView,
            let group = groupAtIndex(indexPath.section) else {
                return UICollectionReusableView()
        }

        cell.topSeperator.hidden = indexPath.section == 0
        cell.leftText = group.title

        return cell
    }

    func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        displayedData = true
        collectionView?.reloadData()
    }

}
