//
//  ReactionsCollectionViewController.swift
//  Often
//
//  Created by Katelyn Findlay on 8/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class ReactionsCollectionViewController: BaseBrowsePackItemViewController, ReactionsViewModelDelegate {
    
    private var packServiceListener: Listener? = nil
    var reactionsViewModel: ReactionsViewModel
    
    init(viewModel: ReactionsViewModel, textProcessor: TextProcessingManager?) {
        
        self.reactionsViewModel = viewModel
        
        super.init(viewModel: PacksService.defaultInstance, textProcessor: textProcessor)
        
        reactionsViewModel.delegate = self
        reactionsViewModel.fetchReactionsForUser()
        
        collectionView?.registerClass(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCellReuseIdentifier)
        collectionView?.registerClass(MediaItemsSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier)
        
        packServiceListener = PacksService.defaultInstance.didUpdatePacks.on { [weak self] items in
            self?.reactionsViewModel.fetchReactionsForUser()
            self?.collectionView?.reloadData()
        }
        
        if let navigationBar = navigationBar {
            navigationBar.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        packServiceListener = nil
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reactionsViewModel.reactions.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CategoryCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.row < reactionsViewModel.reactions.count {
            let reaction = reactionsViewModel.reactions[indexPath.row]
            cell.title = reaction.name
            
            if let image = reaction.smallImageURL {
                cell.backgroundImageView.nk_setImageWith(image)
            }
            
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            // Create Header
            if let sectionView: MediaItemsSectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: MediaItemsSectionHeaderViewReuseIdentifier, forIndexPath: indexPath) as? MediaItemsSectionHeaderView {
                
                sectionView.artistImageView.image = nil
                sectionView.middleText = "Reactions".uppercaseString
                return sectionView
            }
        }
        
        return UICollectionReusableView()
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // new vc
        let vc = FilteredCollectionViewController(viewModel: reactionsViewModel, reaction: reactionsViewModel.reactions[indexPath.row], textProcessor: textProcessor)
        vc.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 44.5)
        navigationController?.pushViewController(vc, animated: true)
        presentViewControllerWithCustomTransitionAnimator(vc, direction: .Left, duration: 0.2)
        
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        var width: CGFloat
        
        if screenHeight > screenWidth {
            width = screenWidth / 3 - 12.5
        } else {
            width = screenWidth / 3 - 12.5
        }
        
        let height = width * (4/7)
        return CGSizeMake(width, height)
        
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 9.0, left: 9.0, bottom: 60.0, right: 9.0)

    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 7.0
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 7.0
    }
    
    
    func reactionsViewModelDelegateDataDidLoad(viewModel: ReactionsViewModel, reactions: [Category]?) {
        collectionView?.reloadData()
    }
    
}