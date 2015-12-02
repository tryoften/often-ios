//
//  SoundcloudCollectionViewController.swift
//  Surf
//
//  Created by Komran Ghahremani on 7/30/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

let soundcloudCellReuseIdentifier = "soundcloudCell"

class SoundcloudCollectionViewController: UICollectionViewController {
    var screenWidth = UIScreen.mainScreen().bounds.width
    var resultsLabel: UILabel
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        resultsLabel = UILabel()
        
        super.init(collectionViewLayout: layout)
        
        view.backgroundColor = LightGrey
        
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        if let collectionView = collectionView {
            collectionView.registerClass(SoundcloudCollectionViewCell.self, forCellWithReuseIdentifier: soundcloudCellReuseIdentifier)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func provideCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(screenWidth, 100)
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 5.0
        layout.minimumLineSpacing = 5.0
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 5.0, bottom: 5.0, right: 5.0)
        return layout
    }
    
    func setupLayout() {
        view.addConstraints([
            resultsLabel.al_top == view.al_top + 3,
            resultsLabel.al_left == view.al_left + 3
        ])
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(soundcloudCellReuseIdentifier, forIndexPath: indexPath) as? SoundcloudCollectionViewCell else {
            return UICollectionViewCell()
        }
    
        cell.usernameLabel.text = "octobersveryown"
        cell.trackLabel.text = "Back to Back Freestyle"
        cell.playsLabel.text = "4,593,284 Plays"
        cell.dateLabel.text = "July 25, 2015"
        cell.trackImageView.image = UIImage(named: "")
        
        return cell
    }
}
