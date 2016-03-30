//
//  KeyboardMediaItemPackViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 3/29/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

private let KeyboardMediaItemPackHeaderViewCellReuseIdentifier = "PackHeaderViewCell"

class KeyboardMediaItemPackViewController: TrendingArtistsHorizontalCollectionViewController {
    var packPanelView: PackPanelView

    override init(viewModel: BrowseViewModel) {
        packPanelView = PackPanelView()
        packPanelView.translatesAutoresizingMaskIntoConstraints = false

        super.init(viewModel: viewModel)

        view.backgroundColor = VeryLightGray
        view.addSubview(packPanelView)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView!.registerClass(KeyboardMediaItemPackHeaderView.self, forCellWithReuseIdentifier: KeyboardMediaItemPackHeaderViewCellReuseIdentifier)
    }

    func setupLayout() {
        view.addConstraints([
            packPanelView.al_right == view.al_right,
            packPanelView.al_left == view.al_left,
            packPanelView.al_bottom == view.al_bottom,
            packPanelView.al_height == 40
            ])
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if section == 0 {
            return 1
        }

        if let group = group {
            return group.items.count
        }

        return 5
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4.5, left: 4.5, bottom: 4.5, right: 4.5)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(KeyboardMediaItemPackHeaderViewCellReuseIdentifier, forIndexPath: indexPath) as? KeyboardMediaItemPackHeaderView else {
                return UICollectionViewCell()
            }

            return cell
        default:
            return super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        }
    }

}