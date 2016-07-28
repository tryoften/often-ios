//
//  AddQuoteViewController.swift
//  Often
//
//  Created by Katelyn Findlay on 7/25/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class AddQuoteViewController : UIViewController, UITextViewDelegate {
    var navigationView: AddContentNavigationView
    var cardView: AddQuoteView
    var viewModel: UserPackService
    
    init(viewModel: UserPackService) {
        
        self.viewModel = viewModel
        
        navigationView = AddContentNavigationView()
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.rightButton.enabled = false
        navigationView.setTitleText("Add Quote")
        
        cardView = AddQuoteView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor.oftLightPinkColor()
        
        cardView.quoteTextView.delegate = self
        navigationView.leftButton.addTarget(self, action: #selector(AddQuoteViewController.cancelButtonDidTap), forControlEvents: .TouchUpInside)
        navigationView.rightButton.addTarget(self, action: #selector(AddQuoteViewController.nextButtonDidTap), forControlEvents: .TouchUpInside)
        
        view.addSubview(navigationView)
        view.addSubview(cardView)
        setupLayout()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        view.addConstraints([
            
            navigationView.al_top == view.al_top,
            navigationView.al_left == view.al_left,
            navigationView.al_right == view.al_right,
            navigationView.al_height == 65,
            
            cardView.al_top == navigationView.al_bottom + 25,
            cardView.al_left == view.al_left + 18,
            cardView.al_right == view.al_right - 18,
            cardView.al_height == cardView.al_width
        ])
    }
    
    func cancelButtonDidTap() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func nextButtonDidTap() {        
        let quote = QuoteMediaItem(data: [
            "text": cardView.quoteTextView.text,
            "type": "quote",
            "owner_id": viewModel.userId
            ])
        
        if let source = cardView.sourceTextField.text {
            quote.origin_name = source
        }
        
        if let name = viewModel.currentUser?.name {
            quote.owner_name = name
        }
        
        quote.toDictionary()
        
        let vc = QuoteCategoryAssignmentViewController(viewModel: AssignCategoryViewModel(mediaItem: quote))
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func textViewDidChange(textView: UITextView) {
        let isText = textView.text.length > 0
        cardView.placeholderLabel.hidden = isText
        navigationView.rightButton.enabled = isText
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        let isText = textView.text.length > 0
        cardView.placeholderLabel.hidden = isText
        navigationView.rightButton.enabled = isText
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return textView.text.characters.count + (text.characters.count - range.length) <= 100
    }
    
}