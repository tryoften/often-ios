//
//  SectionPickerView.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/13/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

private let SectionPickerViewHeight: CGFloat = 45.0

class SectionPickerView: ILTranslucentView, UITableViewDataSource, UITableViewDelegate {
    var categoriesTableView: UITableView
    var nextKeyboardButton: UIButton
    var toggleDrawerButton: UIButton
    var currentCategoryLabel: UILabel
    var drawerOpened: Bool = false
    var heightConstraint: NSLayoutConstraint?
    var delegate: SectionPickerViewDelegate?
    var categoryService: CategoryService?

    var categories: [Category]? {
        didSet {
            categoriesTableView.reloadData()
            if (categories!.count > 0) {
                let category =  categories![0]
                delegate?.didSelectSection(self, category: category)
                dispatch_async(dispatch_get_main_queue(), {
                    self.currentCategoryLabel.text = category.name
                })
            }
        }
    }

    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        categoriesTableView = UITableView(frame: CGRectZero)
        categoriesTableView.backgroundColor = UIColor.clearColor()
        categoriesTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        categoriesTableView.separatorStyle = .None
        
        nextKeyboardButton = UIButton()
        nextKeyboardButton.titleLabel!.font = UIFont(name: "font_icons8", size:20)
        nextKeyboardButton.setTitle("\u{f114}", forState: .Normal)
        nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        nextKeyboardButton.backgroundColor = UIColor(fromHexString: "#ffc538")
        
        toggleDrawerButton = UIButton()
        toggleDrawerButton.titleLabel!.font = UIFont(name: "font_icons8", size:20)
        toggleDrawerButton.setTitle("\u{f132}", forState: .Normal)
        toggleDrawerButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        toggleDrawerButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 0, bottom: 0, right: 0)
        
        currentCategoryLabel = UILabel()
        currentCategoryLabel.textColor = UIColor.whiteColor()
        currentCategoryLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        currentCategoryLabel.userInteractionEnabled = true
        currentCategoryLabel.font = UIFont(name: "Lato-Regular", size: 20)
        
        super.init(frame: frame)

        heightConstraint = (self as ALView).al_height == SectionPickerViewHeight

        translucent = false
//        translucentAlpha = 0.88
//        translucentTintColor = UIColor(fromHexString: "#ffae36")
        backgroundColor = UIColor(fromHexString: "#ffae36")
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        
        addSubview(categoriesTableView)
        addSubview(nextKeyboardButton)
        addSubview(toggleDrawerButton)
        addSubview(currentCategoryLabel)
        
        let toggleSelector = Selector("toggleDrawer")
        toggleDrawerButton.addTarget(self, action: toggleSelector, forControlEvents: .TouchUpInside)
        currentCategoryLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: toggleSelector))
        categoriesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        
        setupLayout()
    }
    
    func setupLayout() {
        var tableView = categoriesTableView
        var keyboardButton = nextKeyboardButton
        var categoryLabel = currentCategoryLabel
        var toggleDrawer = toggleDrawerButton
        
        self.addConstraint(heightConstraint!)
        
        self.addConstraints([
            // keyboard button
            keyboardButton.al_left == self.al_left,
            keyboardButton.al_top == self.al_top,
            keyboardButton.al_height == SectionPickerViewHeight,
            keyboardButton.al_width == SectionPickerViewHeight,
            
            // toggle drawer
            toggleDrawer.al_right == self.al_right,
            toggleDrawer.al_top == self.al_top,
            toggleDrawer.al_height == SectionPickerViewHeight,
            toggleDrawer.al_width == toggleDrawer.al_height,
            
            // current category label
            categoryLabel.al_left == self.al_left + SectionPickerViewHeight + 10.0,
//            categoryLabel.al_right == toggleDrawer.al_left,
            categoryLabel.al_height == SectionPickerViewHeight,
            categoryLabel.al_top == self.al_top,
            
            // table View
            tableView.al_top == keyboardButton.al_bottom,
            tableView.al_left == self.al_left,
            tableView.al_right == self.al_right,
            tableView.al_bottom == self.al_bottom
        ])
    }
    
    func toggleDrawer() {
        layoutIfNeeded()
        
        var completionBlock: (Bool) -> Void = { done in
            self.drawerOpened = !self.drawerOpened
            var icon = (self.drawerOpened) ? "\u{f10f}" : "\u{f132}"
            self.toggleDrawerButton.setTitle(icon, forState: .Normal)
        }
        
        if (!drawerOpened) {
            UIView.animateWithDuration(0.2, animations: {
                self.heightConstraint?.constant = self.superview!.bounds.height
                self.layoutIfNeeded()
                return
            }, completion: completionBlock)
            
        } else {
            UIView.animateWithDuration(0.2, animations: {
                self.heightConstraint?.constant = SectionPickerViewHeight
                self.layoutIfNeeded()
                return
            }, completion: completionBlock)
        }

    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var category = categories![indexPath.row] as Category;
        
        currentCategoryLabel.text = category.name
        toggleDrawer()
        
        categoryService?.requestLyrics(category.id, artistIds: nil).onSuccess({ lyrics in
            self.delegate?.didSelectSection(self, category: category)
            return
        })
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as UITableViewCell
        
        var category = categories![indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        cell.textLabel.text = category.name
        cell.textLabel.font = UIFont(name: "Lato-Light", size: 16)
        cell.textLabel.textColor = UIColor.whiteColor()
        cell.textLabel.textAlignment = .Center

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categories = categories {
            return categories.count
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}

protocol SectionPickerViewDelegate {
    func didSelectSection(sectionPickerView: SectionPickerView, category: Category)
}
