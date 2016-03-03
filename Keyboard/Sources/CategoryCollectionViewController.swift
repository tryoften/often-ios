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

    var currentCategory: Category? {
        didSet {
            panelView.currentCategoryText = currentCategory?.name.uppercaseString
        }
    }
    var categories: [Category] = [] {
        didSet {
            if (categories.count > 1) {
                currentCategory = categories[0]
                panelView.delegate?.didSelectSection(panelView, category: currentCategory!, index: 0)
                panelView.categoriesCollectionView.reloadData()
                panelView.categoriesCollectionView.setNeedsLayout()
            }
        }
    }

    var categoryServiceListener: Listener?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        panelView = CategoriesPanelView(frame: CGRectZero)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        panelView.categoriesCollectionView.dataSource = self
        panelView.categoriesCollectionView.delegate = self

        categoryServiceListener = CategoryService.defaultInstance.didUpdateCategories.on(self.handleCategories)
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
    }

    func handleCategories(categories: [Category]) {
        self.categories = categories
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

        return CGSizeMake(screenWidth / 2.5 - 12, 60)
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CategoryCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }

        if indexPath.row < categories.count {
            let category = categories[indexPath.row]
            cell.title = category.name
        }

        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let category = categories[indexPath.row] as? Category {
            currentCategory = category
            panelView.toggleDrawer()

            let data: [String: AnyObject] = [
                "category_name": category.name,
                "category_id": category.id
            ]

            SEGAnalytics.sharedAnalytics().track("keyboard:categorySelected", properties: data)
            panelView.delegate?.didSelectSection(panelView, category: category, index: indexPath.row)
        }
    }
}
