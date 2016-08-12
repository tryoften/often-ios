//
//  FilteredCollectionViewController.swift
//  Often
//
//  Created by Katelyn Findlay on 8/8/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class FilteredCollectionViewController: BaseBrowsePackItemViewController {
    
    var reactionsViewModel: ReactionsViewModel
    var reaction: Category
    var filterHeaderView: FilterCollectionHeaderView
    
    init(viewModel: ReactionsViewModel, reaction: Category, textProcessor: TextProcessingManager?) {
        
        self.reaction = reaction
        reactionsViewModel = viewModel
        reactionsViewModel.generateFilteredGroups(reaction)
        
        filterHeaderView = FilterCollectionHeaderView()
        filterHeaderView.translatesAutoresizingMaskIntoConstraints = false
        filterHeaderView.titleText = reaction.name
        
        super.init(viewModel: PacksService.defaultInstance, textProcessor: textProcessor)
        
        if let navigationBar = navigationBar {
            navigationBar.removeFromSuperview()
        }
        
        filterHeaderView.dismissButton.addTarget(self, action: #selector(FilteredCollectionViewController.didTapBackButton), forControlEvents: .TouchUpInside)
        
        view.addSubview(filterHeaderView)
        setLayout()
        
    }
    
    func setLayout() {
        
        view.addConstraints([
            filterHeaderView.al_top == view.al_top,
            filterHeaderView.al_left == view.al_left,
            filterHeaderView.al_right == view.al_right,
            filterHeaderView.al_height == 33,
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return reactionsViewModel.filteredGroups.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reactionsViewModel.filteredGroups[section].items.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let item = reactionsViewModel.filteredGroups[indexPath.section].items[indexPath.row] as? MediaItem else {
            return UICollectionViewCell()
        }
        
        return setupCell(reactionsViewModel.filteredGroups[indexPath.section], item: item, indexPath: indexPath, collectionView: collectionView)
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let group = reactionsViewModel.filteredGroups[indexPath.section]
        
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
            var width: CGFloat
            
            if screenHeight > screenWidth {
                width = screenWidth / 2 - 15.5
            } else {
                width = screenWidth / 3 - 15.5
            }
            
            let height = screenHeight / 4
            return CGSizeMake(width, height)
        case .Image:
            var width: CGFloat
            
            if screenHeight > screenWidth {
                width = screenWidth / 3 - 12.5
            } else {
                width = screenWidth / 4 - 12.5
            }
            
            let height = width
            return CGSizeMake(width, height)
        default:
            return CGSizeZero
        }
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let group = reactionsViewModel.filteredGroups[section]
        
        var topHeight: CGFloat = 9.0
        if section == 0 {
            topHeight = 42.0
        }
        
        if group.type == .Gif || group.type == .Image {
            return UIEdgeInsets(top: topHeight, left: 9.0, bottom: 0.0, right: 9.0)
        }
        return UIEdgeInsets(top: topHeight, left: 12.0, bottom: 0.0, right: 12.0)
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 7.0
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 7.0
    }
    
    func didTapBackButton() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
