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
        collectionView?.register(MediaItemsSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier)

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

    internal func groupAtIndex(_ index: Int) -> MediaItemGroup? {
        return viewModel.groupAtIndex(index)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.mediaItemGroups.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main().bounds.size.width
        let baseSize = CGSize(width: screenWidth, height: 115)

        guard let group = groupAtIndex((indexPath as NSIndexPath).section) else {
            return baseSize
        }

        switch group.type {
        case .Lyric:
            return CGSize(width: screenWidth, height: 125)
        case .Artist:
            return CGSize(width: screenWidth, height: 230)
        case .Track:
            return CGSize(width: screenWidth - 20, height: 74)
        default:
            return baseSize
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenWidth = UIScreen.main().bounds.size.width
        return CGSize(width: screenWidth, height: 36)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        showNavigationBar(true)

        guard let group = groupAtIndex((indexPath as NSIndexPath).section),
            let viewModel = viewModel as? BrowseViewModel,
            let item = group.items[(indexPath as NSIndexPath).row] as? MediaItem else {
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

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, for: indexPath) as? MediaItemsSectionHeaderView,
            let group = groupAtIndex((indexPath as NSIndexPath).section) else {
                return UICollectionReusableView()
        }

        cell.topSeperator.isHidden = (indexPath as NSIndexPath).section == 0
        cell.leftText = group.title

        return cell
    }

    func mediaItemGroupViewModelDataDidLoad(_ viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup]) {
        displayedData = true
        collectionView?.reloadData()
    }
}
