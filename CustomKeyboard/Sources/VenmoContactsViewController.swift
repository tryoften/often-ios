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