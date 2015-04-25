//
//  ArtistPickerCollectionViewController.swift
//  Drizzy
//
//  Created by Luc Success on 4/24/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

let ArtistCollectionViewCellReuseIdentifier = "ArtistCollectionViewCell"

class ArtistPickerCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var closeButton: UIButton!
    var viewModel: KeyboardViewModel?
    var keyboards: [Keyboard]? {
        didSet {
            dispatch_async(dispatch_get_main_queue(), {
                self.collectionView!.reloadData()
            })
        }
        
    }
    
    class func provideCollectionViewLayout(frame: CGRect) -> UICollectionViewLayout {
        var viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .Horizontal
        viewLayout.minimumInteritemSpacing = 5.0
        viewLayout.sectionInset = UIEdgeInsets(top: 5.0, left: 40.0, bottom: 5.0, right: 0.0)
        return viewLayout
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        var closeButtonFrame = view.frame
        closeButtonFrame.size.width = 30

        closeButton = UIButton(frame: closeButtonFrame)
        closeButton.addTarget(self, action: "didTapCloseButton", forControlEvents: .TouchUpInside)
        closeButton.setTitle("\u{f10d}", forState: .Normal)
        closeButton.titleLabel!.font = UIFont(name: "font_icons8", size: 21)
        closeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        closeButton.backgroundColor = ArtistCollectionViewCloseButtonBackgroundColor

        view.addSubview(closeButton)
    
        // Register cell classes
        collectionView!.registerClass(ArtistCollectionViewCell.self, forCellWithReuseIdentifier: ArtistCollectionViewCellReuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let keyboards = keyboards {
            return keyboards.count
        }
        
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ArtistCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as! ArtistCollectionViewCell
        
        var keyboard = keyboards![indexPath.row]
        
        cell.titleLabel.text = keyboard.artist?.name
        cell.subtitleLabel.text = "\(keyboard.categories.count) categories"
        
        cell.imageView.setImageWithURL(keyboard.artist?.imageURLSmall)

        return cell
    }
    
    func didTapCloseButton() {
        
    }
    
    func slideIn() {
    }

    // MARK: UICollectionViewFlowLayoutDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(ArtistCollectionViewCellWidth, CGRectGetHeight(collectionView.bounds) - 10)
    }

}
