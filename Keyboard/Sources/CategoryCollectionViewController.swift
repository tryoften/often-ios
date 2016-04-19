//
//  CategoryCollectionViewController.swift
//  Often
//
//  Created by Luc Succes on 3/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class CategoryCollectionViewController: UIViewController, UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var drawerOpened: Bool = false
    var panelView: CategoriesPanelView
    var viewModel: BrowseViewModel

    var currentCategory: Category? {
        didSet {
            panelView.currentCategoryText = currentCategory?.name.uppercaseString
            if let category = currentCategory {
                viewModel.applyFilter(category)
            }
        }
    }
    var categories: [Category] = [] {
        didSet {
            if (categories.count >= 1) {
                currentCategory = categories[0]
                panelView.categoriesCollectionView.reloadData()
                panelView.categoriesCollectionView.setNeedsLayout()
            }
        }
    }

    private var categoryServiceListener: Listener?

    init(viewModel: BrowseViewModel, categories: [Category]) {
        self.viewModel = viewModel

        self.categories = [Category.all]

        for category in categories {
            self.categories.append(category)
        }

        panelView = CategoriesPanelView(frame: CGRectZero)
        
        super.init(nibName: nil, bundle: nil)

        panelView.categoriesCollectionView.backgroundColor = VeryLightGray
        panelView.categoriesCollectionView.dataSource = self
        panelView.categoriesCollectionView.delegate = self

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = panelView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewLayout = CategoriesPanelView.provideCollectionViewLayout(panelView.bounds)
        panelView.categoriesCollectionView.setCollectionViewLayout(viewLayout, animated: false)

        currentCategory = self.categories.first
    }

    func handleCategories(categories: [Category]) {
        var newCategories: [Category] = [Category.all]

        for category in categories {
            newCategories.append(category)
        }
        self.categories = newCategories
    }

    // MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var screenWidth = CGRectGetWidth(collectionView.bounds)
        if screenWidth == 0 {
            screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        }

        return CGSizeMake(screenWidth / 2.5 - 12, 65)
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CategoryCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }

        if indexPath.row < categories.count {
            let category = categories[indexPath.row]
            cell.title = category.name

            if let image = category.smallImageURL, let pathExtension = image.pathExtension {
                if pathExtension == "gif" {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        let data = NSData(contentsOfURL: image)
                        let animatedImage = FLAnimatedImage(animatedGIFData: data)
                        dispatch_async(dispatch_get_main_queue()) {
                            cell.backgroundImageView.animatedImage = animatedImage
                        }
                    }
                } else {
                    cell.backgroundImageView.setImageWithURL(image)
                }
                cell.backgroundImageView.frame = cell.bounds
            }
        }
        
        if currentCategory == categories[indexPath.row] {
            cell.selected = true
        } else {
            cell.selected = false
        }

        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < categories.count {
            let category = categories[indexPath.row]
            SessionManagerFlags.defaultManagerFlags.lastCategoryIndex = indexPath.row
            currentCategory = category
            panelView.toggleDrawer()

            let data: [String: AnyObject] = [
                "category_name": category.name,
                "category_id": category.id
            ]

            SEGAnalytics.sharedAnalytics().track("keyboard:categorySelected", properties: data)
        }
    }
}
