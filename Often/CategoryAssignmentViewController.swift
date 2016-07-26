//
//  CategoryAssignmentViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 7/21/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class CategoryAssignmentViewController: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    AssignCategoryViewModelDelegate {
    private var imageView: GifCollectionViewCell
    private var headerView: UILabel
    private var viewModel: AssignCategoryViewModel
    private var categoryCollectionView: UICollectionView


    init(viewModel: AssignCategoryViewModel) {
        self.viewModel = viewModel

        imageView = GifCollectionViewCell()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        headerView = UILabel()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.textAlignment = .Center
        headerView.setTextWith(UIFont(name: "Montserrat", size: 9)!, letterSpacing: 1.0, color: UIColor.oftBlackColor(), text: "PICK A CATEGORY")
        headerView.backgroundColor = UIColor.oftWhiteColor()

        categoryCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: CategoryAssignmentViewController.provideCollectionViewLayout())
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoryCollectionView.backgroundColor = VeryLightGray

        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = MainBackgroundColor

        categoryCollectionView.registerClass(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCellReuseIdentifier)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self

        viewModel.delegate = self
        viewModel.fetchData(nil)

        setupNavBar()

        view.addSubview(imageView)
        view.addSubview(headerView)
        view.addSubview(categoryCollectionView)

        setupLayout()
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

        if let gif = self.viewModel.mediaItem as? GifMediaItem, url = gif.largeImageURL {
            self.imageView.setImageWith(url)
        }
    }

    func setupNavBar() {
        navigationItem.setHidesBackButton(true, animated: false)

        let brandLabel = UILabel(frame: CGRectMake(0, 0, 64, 20))
        brandLabel.textAlignment = .Center
        brandLabel.setTextWith(UIFont(name: "Montserrat-Regular", size: 15)!,
                               letterSpacing: 1.0,
                               color: UIColor.oftBlackColor(),
                               text: "Add GIF")

        navigationItem.titleView = brandLabel

        let topLeftBarButton = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(CategoryAssignmentViewController.backButtonDidTap))
        topLeftBarButton.setTitleTextAttributes(([
            NSKernAttributeName: NSNumber(float: 0.2),
            NSFontAttributeName: UIFont(name: "OpenSans", size: 15)!,
            NSForegroundColorAttributeName: UIColor.oftBlackColor()
            ]), forState: .Normal)


        updateAddButtonState(false)

        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixedSpace.width = 19

        navigationItem.leftBarButtonItems = [fixedSpace, topLeftBarButton]
    }

    func updateAddButtonState(enable: Bool) {
        let topRightBarButton = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: #selector(CategoryAssignmentViewController.addButtonDidTap))
        topRightBarButton.setTitleTextAttributes(([
            NSKernAttributeName: NSNumber(float: 0.2),
            NSFontAttributeName: UIFont(name: "OpenSans", size: 15)!,
            NSForegroundColorAttributeName: UIColor.oftWhiteTwoColor()
            ]), forState: .Disabled)
        topRightBarButton.setTitleTextAttributes(([
            NSKernAttributeName: NSNumber(float: 0.2),
            NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 15)!,
            NSForegroundColorAttributeName: UIColor.oftVividPurpleColor()
            ]), forState: .Normal)
        topRightBarButton.enabled = enable

        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixedSpace.width = 19

        navigationItem.rightBarButtonItems = [fixedSpace, topRightBarButton]
    }

    func setupLayout() {
        view.addConstraints([
            imageView.al_top == view.al_top,
            imageView.al_left == view.al_left,
            imageView.al_right == view.al_right,
            imageView.al_height == UIScreen.mainScreen().bounds.height / 3,

            headerView.al_top == imageView.al_bottom,
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
        navigationController?.popToRootViewControllerAnimated(true)
    }

    func addButtonDidTap() {
        PKHUD.sharedHUD.contentView = HUDProgressView()
        PKHUD.sharedHUD.show()

        viewModel.submitNewMediaItem()

        delay(0.5) {
            PKHUD.sharedHUD.hide(animated: true)
            self.navigationController?.popToRootViewControllerAnimated(true)
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

        updateAddButtonState(cell.selected)
        viewModel.updateMediaItemCategory(indexPath.row)
    }

    func assignCategoryViewModelDelegateDataDidLoad(viewModel: AssignCategoryViewModel, categories: [Category]?) {
        categoryCollectionView.reloadData()
    }

}