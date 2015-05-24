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
    
    var closeButton: ArtistCollectionCloseButton
    var viewModel: KeyboardViewModel?
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

    var keyboards: [Keyboard]? {
        didSet {
            dispatch_async(dispatch_get_main_queue(), {
                self.collectionView!.reloadData()
                self.isDeletionModeOn = false
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
        self.init(collectionViewLayout: ArtistPickerCollectionViewLayout.provideCollectionViewLayout())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.73)
        collectionView?.backgroundColor = UIColor.clearColor()
        
        var closeButtonFrame = view.bounds
        closeButtonFrame.size.width = 30
        closeButtonFrame.size.height = KeyboardHeight
        closeButton.frame = closeButtonFrame
    
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
        
        if let keyboards = keyboards {
            return keyboards.count
        }
        
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ArtistCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as! ArtistCollectionViewCell
        
        var keyboard = keyboards![indexPath.row]
        
        if let currentKeyboard = viewModel?.currentKeyboard {
            if currentKeyboard.index == keyboard.index {
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
        cell.imageView.setImageWithURL(keyboard.artist?.imageURLLarge)
        cell.deleteButton.addTarget(self, action: "didTapDeleteButton:", forControlEvents: .TouchUpInside)

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var keyboard = keyboards![indexPath.row]
        
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
    
    func scrollToCellAtIndex(index: Int) {
        if let collectionView = collectionView {
            var xPosition = CGFloat(index) * (ArtistCollectionViewCellWidth + 5.0)
                - (collectionView.frame.size.width - ArtistCollectionViewCellWidth) / 2
                + 30.0
            
            let cellCount = CGFloat(self.collectionView(collectionView, numberOfItemsInSection: 0))
            xPosition = max(0, min(xPosition, collectionView.contentSize.width))
            
            collectionView.setContentOffset(CGPointMake(xPosition, 0), animated: true)
        }
    }
    
    func didTapCloseButton() {
        
    }
    
    func didTapDeleteButton(target: UIButton) {
        if let cell = target.superview as? ArtistCollectionViewCell,
            let indexPath = collectionView?.indexPathForCell(cell),
            let keyboard = keyboards?[indexPath.row] {
                keyboards?.removeAtIndex(indexPath.row)
                collectionView?.deleteItemsAtIndexPaths([indexPath])
                
                if isDeletionModeOn {
                    self.endDeleteMode(indexPath: indexPath)
                }
                
                
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

protocol ArtistPickerCollectionViewControllerDelegate {
    func artistPickerCollectionViewControllerDidSelectKeyboard(artistPicker: ArtistPickerCollectionViewController, keyboard: Keyboard)
}
