//
//  AddQuoteViewController.swift
//  Often
//
//  Created by Katelyn Findlay on 7/25/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class AddQuoteViewController : UIViewController {
    var navigationView: UIView
    var cancelButton: UIButton
    var addButton: UIButton
    var headerTitle: UILabel
    var cardView: UIView
    var quoteTextField: UITextField
    var sourceTextField: UITextField
    
    init() {
        navigationView = UIView()
        
        cancelButton = UIButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        
    }
    
}