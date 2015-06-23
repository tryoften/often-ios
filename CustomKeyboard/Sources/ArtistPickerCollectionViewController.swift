//
//  ArtistPickerCollectionViewController.swift
//  Drizzy
//
//  Created by Luc Success on 4/24/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

let ArtistCollectionViewCellReuseIdentifier = "ArtistCollectionViewCell"

class ArtistPickerCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout,
    ArtistPickerCollectionViewLayoutDelegate {

    var viewModel: KeyboardViewModel?
    var dataSource: ArtistPickerCollectionViewDataSource?
    var delegate: ArtistPickerCollectionViewControllerDelegate?
    var selectedCell: ArtistCollectionViewCell?
    var isDeletionModeOn: Bool = false {
        willSet(newValue) {
            if newValue {
                self.startDeleteMode()
            } else {
                self.endDeleteMode()
            }
        }
    }
    var closeButtonWidth: CGFloat = 0.0

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }

    required convenience init(coder aDecoder: NSCoder) {
        self.init()
    }
    
    convenience init(edgeInsets: UIEdgeInsets) {
        var layout = ArtistPickerCollectionViewLayout.provideCollectionViewLayout()
        layout.sectionInset = edgeInsets
        self.init(collectionViewLayout: layout)
    }
    
    convenience init() {
        self.init(collectionViewLayout: ArtistPickerCollectionViewLayout.provideCollectionViewLayout())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.73)
        collectionView?.backgroundColor = UIColor.clearColor()
        
        if let dataSource = dataSource {
            if dataSource.artistPickerShouldHaveCloseButton(self) {
                let closeButton = ArtistCollectionCloseButton(frame: CGRectZero)
                var closeButtonFrame = view.bounds
                closeButtonWidth = 30.0
                closeButtonFrame.size.width = closeButtonWidth
                closeButtonFrame.size.height = KeyboardHeight
                closeButton.frame = closeButtonFrame
                closeButton.addTarget(self, action: "didTapCloseButton", forControlEvents: .TouchUpInside)
                view.addSubview(closeButton)
            }
        }
    
        collectionView?.showsHorizontalScrollIndicator = false
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
        if let numberOfItems = dataSource?.numberOfItemsInArtistPicker(self) {
            return numberOfItems
        }
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ArtistCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as! ArtistCollectionViewCell
        
        if let keyboard = dataSource?.artistPickerItemAtIndex(self, index: indexPath.row) {
            
            if let dataSource = dataSource {
                if dataSource.artistPickerItemAtIndexIsSelected(self, index: indexPath.row) {
                    selectedCell = cell
                    cell.selected = true
                } else {
                    cell.selected = false
                }
            } else {
                cell.selected = false
            }
            
            cell.titleLabel.text = keyboard.artist?.name
            cell.subtitleLabel.text = "\(keyboard.categories.count) categories".uppercaseString
            cell.imageView.alpha = 0.0
            if let imageURLLarge = keyboard.artist?.imageURLLarge {
                cell.imageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: imageURLLarge)!), placeholderImage: UIImage(), success: { (req, res, image) in
                    UIView.animateWithDuration(0.3) {
                        cell.imageView.image = image
                        cell.imageView.alpha = 1.0
                    }
                    }, failure: { (req, res, err) in
                        
                })
            }
            cell.deleteButton.addTarget(self, action: "didTapDeleteButton:", forControlEvents: .TouchUpInside)
        }

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let keyboard = dataSource?.artistPickerItemAtIndex(self, index: indexPath.row) {
            delegate?.artistPickerCollectionViewControllerDidSelectKeyboard(self, keyboard: keyboard)
            
            if let cell = selectedCell {
                cell.selected = false
            }
            
            if let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as? ArtistCollectionViewCell {
                self.selectedCell = selectedCell
                selectedCell.selected = true
            }
            
            scrollToCellAtIndex(indexPath.row)
        }
    }
    
    func scrollToCellAtIndex(index: Int) {
        if let collectionView = collectionView {
            var xPosition = CGFloat(index) * (ArtistCollectionViewCellWidth + 5.0)
                - (collectionView.frame.size.width - ArtistCollectionViewCellWidth) / 2
                + (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset.left
            
            println("Section left inset: \((collectionViewLayout as! UICollectionViewFlowLayout).sectionInset)")
            
            let cellCount = CGFloat(self.collectionView(collectionView, numberOfItemsInSection: 0))
            xPosition = max(0, min(xPosition, collectionView.contentSize.width))
            
            collectionView.setContentOffset(CGPointMake(xPosition, 0), animated: true)
        }
    }
    
    func didTapCloseButton() {
        delegate?.artistPickerCollectionViewDidClosePanel?(self)
    }
    
    func didTapDeleteButton(target: UIButton) {
        if let cell = target.superview as? ArtistCollectionViewCell,
            let indexPath = collectionView?.indexPathForCell(cell),
            let keyboard = dataSource?.artistPickerItemAtIndex(self, index: indexPath.row) {
                collectionView?.deleteItemsAtIndexPaths([indexPath])
                
                if isDeletionModeOn {
                    self.endDeleteMode(indexPath: indexPath)
                }

                delegate?.artistPickerCollectionViewControllerDidDeleteKeyboard?(self, keyboard: keyboard, index: indexPath.row)
        }
    }
    
    func startDeleteMode(indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 0) ) {
        let layout = collectionView?.collectionViewLayout as! ArtistPickerCollectionViewLayout
        var attributes = layout.layoutAttributesForItemAtIndexPath(indexPath)
        
        layout.invalidateLayout()
        
        for cell in collectionView?.visibleCells() as! [ArtistCollectionViewCell] {
            cell.applyLayoutAttributes(attributes)
        }
    }
    
    func endDeleteMode(indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)) {
        let layout = collectionView?.collectionViewLayout as! ArtistPickerCollectionViewLayout
        let attributes = layout.layoutAttributesForItemAtIndexPath(indexPath)
        
        layout.invalidateLayout()
        
        for cell in collectionView?.visibleCells() as! [ArtistCollectionViewCell] {
            cell.applyLayoutAttributes(attributes)
        }
    }

    // MARK: UICollectionViewFlowLayoutDelegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(ArtistCollectionViewCellWidth, CGRectGetHeight(collectionView.bounds) - 10)
    }
    
    // MARK: ArtistPickerCollectionViewLayoutDelegate
    func isDeletionModeActiveForCollectionView(collectionView: UICollectionView, layout: UICollectionViewLayout) -> Bool {
        return isDeletionModeOn
    }

}

class ArtistPickerCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var deleteButtonHidden: Bool = true
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        var attributes: ArtistPickerCollectionViewLayoutAttributes = super.copyWithZone(zone) as! ArtistPickerCollectionViewLayoutAttributes
        attributes.deleteButtonHidden = deleteButtonHidden
        return attributes
    }
}

@objc protocol ArtistPickerCollectionViewControllerDelegate {
    func artistPickerCollectionViewControllerDidSelectKeyboard(artistPicker: ArtistPickerCollectionViewController, keyboard: Keyboard)
    optional func artistPickerCollectionViewControllerDidDeleteKeyboard(artistPicker: ArtistPickerCollectionViewController, keyboard: Keyboard, index: Int)
    optional func artistPickerCollectionViewDidClosePanel(artistPicker: ArtistPickerCollectionViewController)
}

protocol ArtistPickerCollectionViewDataSource {
    func numberOfItemsInArtistPicker(artistPicker: ArtistPickerCollectionViewController) -> Int
    func artistPickerItemAtIndex(artistPicker: ArtistPickerCollectionViewController, index: Int) -> Keyboard?
    func artistPickerShouldHaveCloseButton(artistPicker: ArtistPickerCollectionViewController) -> Bool
    func artistPickerItemAtIndexIsSelected(artistPicker: ArtistPickerCollectionViewController, index: Int) -> Bool
}
