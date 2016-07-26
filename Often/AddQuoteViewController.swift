//
//  AddQuoteViewController.swift
//  Often
//
//  Created by Katelyn Findlay on 7/25/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class AddQuoteViewController : UIViewController, UITextViewDelegate {
    var navigationView: AddQuoteNavigationView
    var cardView: AddQuoteView
    var gradientView: UIImageView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        navigationView = AddQuoteNavigationView()
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.addButton.enabled = false
        
        cardView = AddQuoteView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        gradientView = UIImageView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.contentMode = .ScaleAspectFill
        gradientView.clipsToBounds = true
        gradientView.image = UIImage(named: "gradient")
        gradientView.layer.cornerRadius = 4.0
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        view.backgroundColor = UIColor.oftLightPinkColor()
        
        cardView.quoteTextView.delegate = self
        navigationView.cancelButton.addTarget(self, action: #selector(AddQuoteViewController.cancelButtonDidTap), forControlEvents: .TouchUpInside)
        navigationView.addButton.addTarget(self, action: #selector(AddQuoteViewController.addButtonDidTap), forControlEvents: .TouchUpInside)
        
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
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addButtonDidTap() {
        // add quotes
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textViewDidChange(textView: UITextView) {
        let isText = textView.text.length > 0
        cardView.placeholderLabel.hidden = isText
        navigationView.addButton.enabled = isText
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        let isText = textView.text.length > 0
        cardView.placeholderLabel.hidden = isText
        navigationView.addButton.enabled = isText
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return textView.text.characters.count + (text.characters.count - range.length) <= 100
    }
    
}