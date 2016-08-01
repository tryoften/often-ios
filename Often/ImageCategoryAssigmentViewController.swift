//
//  ImageCategoryAssigmentViewController.swift
//  Often
//
//  Created by Luc Succes on 8/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class ImageCategoryAssigmentViewController: BaseCategoryAssignmentViewController {
    var imageView: UIImageView
    var progressView: UIProgressView
    var imageUploaded: Bool {
        didSet {
            navigationView.rightButton.enabled = imageUploaded && viewModel.selectedCategory != nil
        }
    }

    init(viewModel: AssignCategoryViewModel, localImage: UIImage) {
        imageView = UIImageView(image: localImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        progressView = UIProgressView()
        progressView.progressTintColor = TealColor
        progressView.translatesAutoresizingMaskIntoConstraints = false

        imageUploaded = false

        super.init(viewModel: viewModel)

        view.addSubview(imageView)
        view.addSubview(progressView)

        navigationView.setTitleText("Add Image")
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupLayout() {
        super.setupLayout()

        view.addConstraints([
            imageView.al_top == navigationView.al_bottom + 25,
            imageView.al_left == view.al_left,
            imageView.al_right == view.al_right,
            imageView.al_height == UIScreen.mainScreen().bounds.height / 3,

            progressView.al_bottom == imageView.al_bottom,
            progressView.al_left == imageView.al_left,
            progressView.al_right == imageView.al_right,
            progressView.al_height == 4.0,

            headerView.al_top == imageView.al_bottom
        ])
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CategoryCollectionViewCell  else {
            return
        }

        if imageUploaded {
            navigationView.rightButton.enabled = cell.selected
        }

        viewModel.updateMediaItemCategory(indexPath.row)
    }


}