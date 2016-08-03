//
//  BaseCategoryAssignmentViewController.swift
//  Often
//
//  Created by Katelyn Findlay on 7/27/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class BaseCategoryAssignmentViewController: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    AssignCategoryViewModelDelegate {
    
    var viewModel: AssignCategoryViewModel
    var navigationView: AddContentNavigationView
    var headerView: UILabel
    var categoryCollectionView: UICollectionView
    
    init(viewModel: AssignCategoryViewModel) {
        self.viewModel = viewModel
        
        navigationView = AddContentNavigationView()
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.setRightButtonText("Next")
        navigationView.setLeftButtonText("Back")
        
        headerView = UILabel()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.textAlignment = .Center
        headerView.setTextWith(UIFont(name: "Montserrat", size: 9)!, letterSpacing: 1.0, color: UIColor.oftBlackColor(), text: "PICK A CATEGORY")
        headerView.backgroundColor = UIColor.oftWhiteColor()
        
        categoryCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: BaseCategoryAssignmentViewController.provideCollectionViewLayout())
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoryCollectionView.backgroundColor = VeryLightGray
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = MainBackgroundColor
        
        navigationView.leftButton.addTarget(self, action: #selector(BaseCategoryAssignmentViewController.backButtonDidTap), forControlEvents: .TouchUpInside)
        navigationView.rightButton.addTarget(self, action: #selector(BaseCategoryAssignmentViewController.addButtonDidTap), forControlEvents: .TouchUpInside)
        
        categoryCollectionView.registerClass(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCellReuseIdentifier)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        viewModel.delegate = self
        viewModel.fetchData(nil)
        
        view.addSubview(navigationView)
        view.addSubview(headerView)
        view.addSubview(categoryCollectionView)
    }
    
    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .Vertical
        viewLayout.itemSize = CGSizeMake(113, 60)
        viewLayout.minimumInteritemSpacing = 3
        viewLayout.minimumLineSpacing = 3
        viewLayout.sectionInset = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        return viewLayout
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barStyle = .Default
            navigationBar.translucent = false
            navigationBar.hidden = true
        }
    }

    func setupLayout() {
        view.addConstraints([
            navigationView.al_top == view.al_top,
            navigationView.al_left == view.al_left,
            navigationView.al_right == view.al_right,
            navigationView.al_height == 65,
            
            headerView.al_left == view.al_left,
            headerView.al_right == view.al_right,
            headerView.al_height == 33,
            
            categoryCollectionView.al_top == headerView.al_bottom,
            categoryCollectionView.al_right == view.al_right,
            categoryCollectionView.al_left == view.al_left,
            categoryCollectionView.al_bottom == view.al_bottom
        ])
    }
    
    func backButtonDidTap() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func addButtonDidTap() {
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()
        
        viewModel.submitNewMediaItem()
        
        delay(0.5) {
            PKHUD.sharedHUD.hide(animated: true)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CategoryCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let category = viewModel.categories[indexPath.row]
        cell.title = category.name
        
        
        if let image = category.smallImageURL {
            cell.backgroundImageView.nk_setImageWith(image)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CategoryCollectionViewCell  else {
            return
        }
        
        navigationView.rightButton.enabled = cell.selected
        viewModel.updateMediaItemCategory(indexPath.row)
    }
    
    func assignCategoryViewModelDelegateDataDidLoad(viewModel: AssignCategoryViewModel, categories: [Category]?) {
        categoryCollectionView.reloadData()
    }
    
}
