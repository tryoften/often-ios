//
//  VenmoContactsViewController.swift
//  Surf
//
//  Created by Luc Succes on 7/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class VenmoContactsViewController: ServiceProviderSupplementaryViewController {
    var collectionViewController: VenmoContactsCollectionViewController!
    var headerLabel: UILabel!

    override var supplementaryViewHeight: CGFloat {
        return 100.0
    }
    
    override var searchBarPlaceholderText: String {
        return "Select contact..."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel = UILabel()
        headerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        headerLabel.font = UIFont(name: "OpenSans", size: 10)
        headerLabel.text = "Contacts".uppercaseString
        
        let width = CGRectGetWidth(UIScreen.mainScreen().bounds) / 2.5
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(width, 60)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        collectionViewController = VenmoContactsCollectionViewController(collectionViewLayout: layout)
        collectionViewController.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        view.addSubview(headerLabel)
        view.addSubview(collectionViewController.view)
    
        setupLayout()
    }
    
    func setupLayout() {
        view.addConstraints([
            headerLabel.al_top == view.al_top + 8,
            headerLabel.al_left == view.al_left + 10,
            
            collectionViewController.view.al_top == headerLabel.al_bottom + 2,
            collectionViewController.view.al_left == view.al_left,
            collectionViewController.view.al_right == view.al_right,
            collectionViewController.view.al_bottom == view.al_bottom
        ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class VenmoContactsCollectionViewController: UICollectionViewController {
    override func viewDidLoad() {
        collectionView?.registerClass(VenmoContactsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! VenmoContactsCollectionViewCell
        
        cell.contactName.text = "Luc Succes"
        cell.contactNumber.text = "(555) 555-5555"
        
        return cell
    }
}

class VenmoContactsCollectionViewCell: UICollectionViewCell {
    var contactImageView: UIImageView
    var contactName: UILabel
    var contactNumber: UILabel
    
    override init(frame: CGRect) {
        contactImageView = UIImageView()
        contactImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contactImageView.backgroundColor = DarkGrey
        
        contactName = UILabel()
        contactName.setTranslatesAutoresizingMaskIntoConstraints(false)
        contactName.font = UIFont(name: "OpenSans", size: 11)
        
        contactNumber = UILabel()
        contactNumber.font = UIFont(name: "OpenSans", size: 10)
        contactNumber.textColor = SystemGrayColor
        contactNumber.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        layer.cornerRadius = 3
        layer.shadowOffset = CGSizeMake(0, 3)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.5
        layer.shadowColor = DarkGrey.CGColor
        
        addSubview(contactImageView)
        addSubview(contactName)
        addSubview(contactNumber)
        
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addConstraints([
            contactImageView.al_top == al_top + 10,
            contactImageView.al_left == al_left + 10,
            contactImageView.al_bottom == al_bottom - 10,
            contactImageView.al_width == contactImageView.al_height,
            
            contactName.al_left == contactImageView.al_right + 10,
            contactName.al_top == contactImageView.al_top,
            
            contactNumber.al_leading == contactName.al_leading,
            contactNumber.al_top == contactName.al_bottom + 5
        ])
    }
}