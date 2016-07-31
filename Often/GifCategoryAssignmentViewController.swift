//
//  GifCategoryAssignmentViewController.swift
//  Often
//
//  Created by Katelyn Findlay on 7/28/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class GifCategoryAssignmentViewController: BaseCategoryAssignmentViewController {
    
    var gifView: GifCollectionViewCell
    
    override init(viewModel: AssignCategoryViewModel) {
        gifView = GifCollectionViewCell()
        gifView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(viewModel: viewModel)
        
        view.addSubview(gifView)
        navigationView.setTitleText("Add GIF")
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let gif = self.viewModel.mediaItem as? GifMediaItem, url = gif.largeImageURL {
            gifView.setImageWith(url)
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        view.addConstraints([
            gifView.al_top == navigationView.al_bottom + 25,
            gifView.al_left == view.al_left,
            gifView.al_right == view.al_right,
            gifView.al_height == UIScreen.mainScreen().bounds.height / 3,
            
            headerView.al_top == gifView.al_bottom
        ])
    }
}