//
//  VenmoContactsCollectionViewController.swift
//  Surf
//
//  Created by Luc Succes on 7/20/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class VenmoContactsCollectionViewController: UICollectionViewController {
    var userDefaults: NSUserDefaults = NSUserDefaults(suiteName: AppSuiteName)!
    var friendsData: [VenmoFriend] = []
    
    override func viewDidLoad() {
        collectionView?.registerClass(VenmoContactsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.showsHorizontalScrollIndicator = false
        
        if let friendsData = userDefaults.objectForKey("friends") as? [[NSObject : AnyObject]] {
            for var i = 0; i < friendsData.count; i++ {
                var friend = VenmoFriend()
                friend.setValuesForKeysWithDictionary(friendsData[i])
                self.friendsData.append(friend)
            }
        } else {
            println("Keyboard Friends Fail")
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendsData.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! VenmoContactsCollectionViewCell
        
        cell.contactName.text = friendsData[indexPath.row].name
        cell.contactNumber.text = friendsData[indexPath.row].username
        cell.contactImageView.setImageWithURL(NSURL(string: friendsData[indexPath.row].profileURL))
        
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
}