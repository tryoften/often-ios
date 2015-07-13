//
//  CategoryCollectionViewController.swift
//  DrizzyChat
//
//  Created by Luc Success on 12/14/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class CategoryCollectionViewController: UIViewController,
    UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    weak var keyboardViewController: KeyboardViewController!
    var tapRecognizer: UITapGestureRecognizer!
    var drawerOpened: Bool = false
    var startingPoint: CGPoint?
    var pickerView: CategoriesPanelView!
    var currentCategory: Category?
    var categories: [Category] = [] {
        didSet {
            if (categories.count > 1) {
                currentCategory = categories[0]
                pickerView.delegate?.didSelectSection(pickerView, category: currentCategory!, index: 0)
                pickerView.categoriesCollectionView.reloadData()
                pickerView.categoriesCollectionView.setNeedsLayout()
            }
        }
    }

    override func loadView() {
        view = CategoriesPanelView(frame: keyboardViewController.view.bounds)
        pickerView = (view as! CategoriesPanelView)
        pickerView.categoriesCollectionView.dataSource = self
        pickerView.categoriesCollectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toggleSelector = Selector("toggleDrawer")
        tapRecognizer = UITapGestureRecognizer(target: self, action: toggleSelector)
        pickerView.toggleDrawerButton.addTarget(self, action: toggleSelector, forControlEvents: .TouchUpInside)
        pickerView.currentCategoryLabel.addGestureRecognizer(tapRecognizer)
        pickerView.messageBarView.closeButton.addTarget(self, action: "didTapCloseButton", forControlEvents: .TouchUpInside)
        pickerView.messageBarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "didTapCloseButton"))
        pickerView.shareButton.addTarget(self, action: "didTapShareButton", forControlEvents: .TouchUpInside)
        
        var viewLayout = CategoriesPanelView.provideCollectionViewLayout(pickerView.bounds)
        pickerView.categoriesCollectionView.setCollectionViewLayout(viewLayout, animated: false)
    }
    
    func toggleDrawer() {
        if (!pickerView.drawerOpened) {
            pickerView.open()
            Flurry.logEvent("keyboard:categoryPanelOpened", timed: true)
            SEGAnalytics.sharedAnalytics().track("keyboard:categoryPanelOpened")
        } else {
            pickerView.close()
            var params = [String: String]()
            
            if let currentCategory = currentCategory {
                params["current_category_id"] = currentCategory.id
            }
            Flurry.endTimedEvent("keyboard:categoryPanelClosed", withParameters: params)
        }
        pickerView.drawerOpened = !pickerView.drawerOpened
    }

    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        return CGSizeMake(
            CGRectGetWidth(collectionView.bounds) / 2.5 - 10,
            CGRectGetHeight(collectionView.bounds) / 2 - 5
        )
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CategoryCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as! CategoryCollectionViewCell
        
        if indexPath.row < categories.count {
            let category = categories[indexPath.row]
            cell.titleLabel.text = category.name
            cell.highlightColorBorder.backgroundColor = category.highlightColor
            cell.subtitleLabel.text = "\(category.lyrics.count) lyrics".uppercaseString
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let category = categories[indexPath.row] as? Category {
            currentCategory = category
            toggleDrawer()
            
            var data: [String: AnyObject] = [
                "category_name": category.name,
                "category_id": category.id
            ]
            
            if let keyboard = category.keyboard {
                data["keyboard_id"] = keyboard.id
            }
            SEGAnalytics.sharedAnalytics().track("keyboard:categorySelected", properties: data)
            pickerView.delegate?.didSelectSection(pickerView, category: category, index: indexPath.row)
        }
    }
    
    func didTapShareButton() {
        let shareText = "I'm using October, a new lyric keyboard. Check it out! http://octbr.co/app"
        let proxy = keyboardViewController.textDocumentProxy as! UITextDocumentProxy
        keyboardViewController.textProcessor.lastInsertedString = shareText
        keyboardViewController.textProcessor.clearInput()
        proxy.insertText(shareText)
    }
    
    func didTapCloseButton() {
        pickerView.hideMessageBar()
    }
}
