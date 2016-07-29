//
//  ImageCategoryAssignmentViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 7/29/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class ImageCategoryAssignmentViewController: BaseCategoryAssignmentViewController {
    var imageView: GifCollectionViewCell
    
    override init(viewModel: AssignCategoryViewModel) {
        imageView = GifCollectionViewCell()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(viewModel: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let image = self.viewModel.mediaItem as? ImageMediaItem, url = image.largeImageURL {
            self.imageView.setImageWith(url)
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        view.addConstraints([
            imageView.al_top == navigationView.al_bottom + 25,
            imageView.al_left == view.al_left,
            imageView.al_right == view.al_right,
            imageView.al_height == UIScreen.mainScreen().bounds.height / 3,
            
            headerView.al_top == imageView.al_bottom
        ])
    }
}
