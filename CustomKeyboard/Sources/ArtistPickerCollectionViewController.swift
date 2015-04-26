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
    
    var closeButton: ArtistCollectionCloseButton
    var viewModel: KeyboardViewModel?
    var delegate: ArtistPickerCollectionViewControllerDelegate?
    var keyboards: [Keyboard]? {
        didSet {
            dispatch_async(dispatch_get_main_queue(), {
                self.collectionView!.reloadData()
            })
        }
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        closeButton = ArtistCollectionCloseButton(frame: CGRectZero)
        super.init(collectionViewLayout: layout)
        
        closeButton.addTarget(self, action: "didTapCloseButton", forControlEvents: .TouchUpInside)
        view.addSubview(closeButton)
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init(collectionViewLayout: ArtistPickerCollectionViewController.provideCollectionViewLayout(CGRectZero))
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
        
        var closeButtonFrame = view.bounds
        closeButtonFrame.size.width = 30
        closeButton.frame = closeButtonFrame
    
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
        
        cell.imageView.setImageWithURL(keyboard.artist?.imageURLLarge)

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var keyboard = keyboards![indexPath.row]
        
        delegate?.artistPickerCollectionViewControllerDidSelectKeyboard(self, keyboard: keyboard)
    }
    
    func didTapCloseButton() {
        
    }

    // MARK: UICollectionViewFlowLayoutDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(ArtistCollectionViewCellWidth, CGRectGetHeight(collectionView.bounds) - 10)
    }

}

protocol ArtistPickerCollectionViewControllerDelegate {
    func artistPickerCollectionViewControllerDidSelectKeyboard(artistPicker: ArtistPickerCollectionViewController, keyboard: Keyboard)
}
