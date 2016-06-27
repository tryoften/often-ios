//
//  CategoryCollectionViewController.swift
//  Often
//
//  Created by Luc Succes on 3/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit
import Nuke
import FLAnimatedImage

class CategoryCollectionViewController: UIViewController, UICollectionViewDelegate,
    UICollectionViewDataSource {
    weak var delegate: CategoriesCollectionViewControllerDelegate?

    private var dismissalView: UIView
    private var cancelBarView: KeyboardCancelBar
    private var categoriesCollectionView: UICollectionView
    private var viewModel: PackItemViewModel
    private var categoryServiceListener: Listener?
    private var categories: [Category] = [] {
        didSet {
            if (categories.count >= 1) {
                categoriesCollectionView.reloadData()
                categoriesCollectionView.setNeedsLayout()
            }
        }
    }

    init(viewModel: PackItemViewModel, categories: [Category]) {
        cancelBarView = KeyboardCancelBar()
        cancelBarView.translatesAutoresizingMaskIntoConstraints = false

        dismissalView = UIView()
        dismissalView.translatesAutoresizingMaskIntoConstraints = false
        dismissalView.backgroundColor = ClearColor

        categoriesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CategoryCollectionViewController.provideCollectionViewLayout())
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.backgroundColor = VeryLightGray
        categoriesCollectionView.showsHorizontalScrollIndicator = false

        self.viewModel = viewModel
        self.categories = categories

        super.init(nibName: nil, bundle: nil)

        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self

        view.addSubview(dismissalView)
        view.addSubview(categoriesCollectionView)
        view.addSubview(cancelBarView)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        categoriesCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCellReuseIdentifier)
        cancelBarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(CategoryCollectionViewController.cancelButtonDidTap)))
        cancelBarView.cancelButton.addTarget(self, action: #selector(CategoryCollectionViewController.cancelButtonDidTap), for: .touchUpInside)
        dismissalView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(CategoryCollectionViewController.cancelButtonDidTap)))
    }

    class func provideCollectionViewLayout() -> UICollectionViewLayout {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        viewLayout.itemSize = CGSize(width: 113, height: 60)
        viewLayout.minimumInteritemSpacing = 3
        viewLayout.minimumLineSpacing = 3
        viewLayout.sectionInset = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        return viewLayout
    }

    func setupLayout() {
        let constraints = [
            categoriesCollectionView.al_left == cancelBarView.al_right,
            categoriesCollectionView.al_right == view.al_right,
            categoriesCollectionView.al_bottom == view.al_bottom,
            categoriesCollectionView.al_height == 144,

            cancelBarView.al_left == view.al_left,
            cancelBarView.al_top == categoriesCollectionView.al_top,
            cancelBarView.al_bottom == categoriesCollectionView.al_bottom,
            cancelBarView.al_width == 31,

            dismissalView.al_top == view.al_top,
            dismissalView.al_left == view.al_left,
            dismissalView.al_right == view.al_right,
            dismissalView.al_bottom == view.al_bottom
        ]

        view.addConstraints(constraints)
    }

    func cancelButtonDidTap() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCellReuseIdentifier, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }

        if (indexPath as NSIndexPath).row < categories.count {
            let category = categories[(indexPath as NSIndexPath).row]
            cell.title = category.name

            if categories[(indexPath as NSIndexPath).row].id == Category.all.id {
                if let image = viewModel.pack?.smallImageURL {
                    cell.backgroundImageView.nk_setImageWith(image)
                }

            } else {
                if let image = category.smallImageURL {
                    cell.backgroundImageView.nk_setImageWith(image)
                }
            }
        }


        if viewModel.currentCategory == categories[(indexPath as NSIndexPath).row] {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }


        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row < categories.count {
            let category = categories[(indexPath as NSIndexPath).row]

            viewModel.applyFilter(category)

            let data: [String: AnyObject] = [
                "category_name": category.name,
                "category_id": category.id
            ]

            SEGAnalytics.shared().track("keyboard:categorySelected", properties: data)
            delegate?.categoriesCollectionViewControllerDidSwitchCategory(self, category: category, categoryIndex: (indexPath as NSIndexPath).row)
            dismiss(animated: true, completion: nil)
        }
    }
}

protocol CategoriesCollectionViewControllerDelegate: class {
    func categoriesCollectionViewControllerDidSwitchCategory(_ CategoriesViewController: CategoryCollectionViewController, category: Category, categoryIndex: Int)
}
