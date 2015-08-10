//
//  VenmoContactsCollectionViewController.swift
//  Surf
//
//  Created by Luc Succes on 7/20/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class VenmoContactsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var viewModel: VenmoContactsViewModel!
    
    override func viewDidLoad() {
        viewModel = VenmoContactsViewModel()

        collectionView?.registerClass(VenmoContactsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.showsHorizontalScrollIndicator = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textDidChange:", name: TextProcessingManagerTextChangedEvent, object: nil)
    }
    
    func textDidChange(notification: NSNotification) {
        if let userInfo = notification.userInfo,
            let text = userInfo["text"] as? String {
                viewModel.filterContacts(text)
                collectionView?.reloadData()
                
                if collectionView?.numberOfItemsInSection(0) > 0 {
                    collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: .Left, animated: false)
                }
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfContacts()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! VenmoContactsCollectionViewCell
        
        if let contact = viewModel.contactAtIndex(indexPath.row) {
            cell.contactName.text = contact.name
            cell.contactNumber.text = contact.username
            cell.contactImageView.setImageWithURL(NSURL(string: contact.profileURL))
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! VenmoContactsCollectionViewCell
       
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName(VenmoContactSelectedEvent, object: nil, userInfo: [
            "name": cell.contactName.text!,
            "phone": cell.contactNumber.text!
        ])
        
        let searchButton = SearchBarButton()
        searchButton.setTitle(cell.contactName.text!, forState: .Normal)
        
        notificationCenter.postNotificationName(VenmoAddSearchBarButtonEvent, object: nil, userInfo: [
                "button": searchButton
            ])
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let itemHeight = CGRectGetHeight(collectionView.frame) - 20
        
        if let friend = viewModel.contactAtIndex(indexPath.row) {
            let friendName = NSString(string: friend.name)
            var textSize = friendName.sizeWithAttributes([NSFontAttributeName: UIFont(name: "OpenSans", size: 11)!])
            
            return CGSizeMake(itemHeight + textSize.width + 20, itemHeight)
        }
        
        return CGSizeMake(120, itemHeight)
    }
}