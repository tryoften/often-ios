//
//  SectionPickerView.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/13/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class SectionPickerView: ILTranslucentView, UITableViewDataSource, UITableViewDelegate {
    var categoriesTableView: UITableView
    var nextKeyboardButton: UIButton
    var toggleDrawerButton: UIButton
    var currentCategoryLabel: UILabel
    
    var categories: [Category]? {
        didSet {
            self.categoriesTableView.reloadData()
            if (self.categories!.count > 0) {
                self.currentCategoryLabel.text = self.categories![0].name
            }
        }
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        self.categoriesTableView = UITableView(frame: CGRectZero)
        self.nextKeyboardButton = UIButton()
        self.nextKeyboardButton.titleLabel!.font = UIFont(name: "font_icons8", size:20)
        self.nextKeyboardButton.setTitle("\u{f114}", forState: .Normal)
        self.nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.nextKeyboardButton.backgroundColor = UIColor(fromHexString: "#ffc538")
        
        self.toggleDrawerButton = UIButton()
        self.toggleDrawerButton.titleLabel!.font = UIFont(name: "font_icons8", size:20)
        self.toggleDrawerButton.setTitle("\u{f132}", forState: .Normal)
        self.toggleDrawerButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.toggleDrawerButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 0, bottom: 0, right: 0)
        
        self.currentCategoryLabel = UILabel()
        self.currentCategoryLabel.textColor = UIColor.whiteColor()
        self.currentCategoryLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        super.init(frame: frame)

        self.translucent = true
        self.translucentAlpha = 0.88
        self.translucentTintColor = UIColor(fromHexString: "#ffae36")
        self.categoriesTableView.dataSource = self
        
        self.addSubview(self.categoriesTableView)
        self.addSubview(self.nextKeyboardButton)
        self.addSubview(self.toggleDrawerButton)
        self.addSubview(self.currentCategoryLabel)
        
        self.categoriesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        
        setupLayout()
    }
    
    func setupLayout() {
        var view = self as ALView
        var tableView = self.categoriesTableView as ALView
        var keyboardButton = self.nextKeyboardButton as ALView
        var categoryLabel = self.currentCategoryLabel as ALView
        var toggleDrawer = self.toggleDrawerButton as ALView
        
        // keyboard button
        view.addConstraints([
            keyboardButton.al_left == view.al_left,
            keyboardButton.al_top == view.al_top,
            keyboardButton.al_bottom == view.al_bottom,
            keyboardButton.al_height == view.al_height,
            keyboardButton.al_width == keyboardButton.al_height,
            
            toggleDrawer.al_right == view.al_right,
            toggleDrawer.al_top == view.al_top,
            toggleDrawer.al_height == view.al_height,
            toggleDrawer.al_width == toggleDrawer.al_height,
            toggleDrawer.al_height <= 50.0,
            
            // current category label
            categoryLabel.al_left == keyboardButton.al_right + 10.0,
            categoryLabel.al_right == view.al_right,
            categoryLabel.al_height == view.al_height,
            categoryLabel.al_top == view.al_top,
            
            // table View
            tableView.al_top == keyboardButton.al_bottom,
            tableView.al_left == view.al_left,
            tableView.al_right == view.al_right,
            tableView.al_height == view.al_height
        ])
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as UITableViewCell
        
        var category = self.categories![indexPath.row]
        cell.textLabel.text = category.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categories = self.categories {
            return categories.count
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}
