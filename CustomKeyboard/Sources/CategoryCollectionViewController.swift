//
//  CategoryCollectionViewController.swift
//  DrizzyChat
//
//  Created by Luc Success on 12/14/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class CategoryCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var keyboardViewController: KeyboardViewController!
    var tapRecognizer: UITapGestureRecognizer!
    var drawerOpened: Bool = false
    var startingPoint: CGPoint?
    var pickerView: CategoriesPanelView!
    var currentCategory: Category? {
        didSet {
            if let category = currentCategory {
                pickerView.currentCategoryLabel.text = category.name
                pickerView.currentHighlightColorView.backgroundColor = category.highlightColor
            }
        }
    }

    var categories: [Category] = [] {
        didSet {
            if (categories.count > 1) {
                currentCategory = categories[0]
                pickerView.delegate?.didSelectSection(pickerView, category: currentCategory!)
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
        
        var viewLayout = CategoriesPanelView.provideCollectionViewLayout(pickerView.bounds)
        pickerView.categoriesCollectionView.setCollectionViewLayout(viewLayout, animated: false)
    }
    
    func toggleDrawer() {
        SEGAnalytics.sharedAnalytics().track("Drawer_Toggled")
        if (!pickerView.drawerOpened) {
            pickerView.open()
            Flurry.logEvent("Drawer_Toggled", timed: true)
        } else {
            pickerView.close()
            var params = [String: String]()
            
            if let currentCategory = currentCategory {
                params["current_category_id"] = currentCategory.id
            }
            Flurry.endTimedEvent("Drawer_Toggled", withParameters: params)
        }
        pickerView.drawerOpened = !pickerView.drawerOpened
    }

    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("Categories: \(categories)")
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
        let category = categories[indexPath.row] as Category
        
        currentCategory = category
        toggleDrawer()
        
        SEGAnalytics.sharedAnalytics().track("Category_Selected", properties: [
            "category_name": category.name,
            "category_id": category.id
            ])

        pickerView.delegate?.didSelectSection(pickerView, category: category)
    }
}
