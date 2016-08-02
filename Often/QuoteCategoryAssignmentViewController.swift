//
//  QuoteCategoryAssignmentViewController.swift
//  Often
//
//  Created by Katelyn Findlay on 7/28/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class QuoteCategoryAssignmentViewController: BaseCategoryAssignmentViewController {
    var quoteView: AddQuoteView
    
    override init(viewModel: AssignCategoryViewModel) {
        quoteView = AddQuoteView()
        quoteView.translatesAutoresizingMaskIntoConstraints = false
        quoteView.placeholderLabel.hidden = true
        quoteView.quoteTextView.editable = false
        quoteView.sourceTextField.enabled = false
        
        super.init(viewModel: viewModel)
        
        view.backgroundColor = UIColor.oftLightPinkColor()
        
        view.addSubview(quoteView)
        setupLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let quote = self.viewModel.mediaItem as? QuoteMediaItem else {
            return
        }
        
        quoteView.quoteTextView.text = quote.text
        
        if let source = quote.origin_name {
            quoteView.sourceTextField.text = source
            if source.isEmpty {
                quoteView.sourceTextField.placeholder = "Source"
            }
        }
    } 
    
    override func setupLayout() {
        super.setupLayout()
        
        view.addConstraints([
            quoteView.al_top == navigationView.al_bottom + 25,
            quoteView.al_left == view.al_left + 18,
            quoteView.al_right == view.al_right - 18,
            quoteView.al_height == quoteView.al_width,
            
            headerView.al_top == quoteView.al_bottom + 15
        ])
    }
}