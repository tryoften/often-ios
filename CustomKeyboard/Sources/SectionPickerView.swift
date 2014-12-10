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
            self.categoriesTableView.reloadData()
            if (self.categories!.count > 0) {
                let category =  self.categories![0]
                self.delegate?.didSelectSection(self, category: category)
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
        self.categoriesTableView = UITableView(frame: CGRectZero)
        self.categoriesTableView.backgroundColor = UIColor.clearColor()
        self.categoriesTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.categoriesTableView.separatorStyle = .None
        
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
        self.currentCategoryLabel.userInteractionEnabled = true
        self.currentCategoryLabel.font = UIFont(name: "Lato-Regular", size: 20)
        
        super.init(frame: frame)

        self.heightConstraint = (self as ALView).al_height == SectionPickerViewHeight

        self.translucent = false
//        self.translucentAlpha = 0.88
//        self.translucentTintColor = UIColor(fromHexString: "#ffae36")
        self.backgroundColor = UIColor(fromHexString: "#ffae36")
        self.categoriesTableView.dataSource = self
        self.categoriesTableView.delegate = self
        
        self.addSubview(self.categoriesTableView)
        self.addSubview(self.nextKeyboardButton)
        self.addSubview(self.toggleDrawerButton)
        self.addSubview(self.currentCategoryLabel)
        
        let toggleSelector = Selector("toggleDrawer")
        self.toggleDrawerButton.addTarget(self, action: toggleSelector, forControlEvents: .TouchUpInside)
        self.currentCategoryLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: toggleSelector))
        self.categoriesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        
        setupLayout()
    }
    
    func setupLayout() {
        var view = self as ALView
        var tableView = self.categoriesTableView as ALView
        var keyboardButton = self.nextKeyboardButton as ALView
        var categoryLabel = self.currentCategoryLabel as ALView
        var toggleDrawer = self.toggleDrawerButton as ALView
        
        view.addConstraint(self.heightConstraint!)
        
        view.addConstraints([
            // keyboard button
            keyboardButton.al_left == view.al_left,
            keyboardButton.al_top == view.al_top,
            keyboardButton.al_height == SectionPickerViewHeight,
            keyboardButton.al_width == SectionPickerViewHeight,
            
            // toggle drawer
            toggleDrawer.al_right == view.al_right,
            toggleDrawer.al_top == view.al_top,
            toggleDrawer.al_height == SectionPickerViewHeight,
            toggleDrawer.al_width == toggleDrawer.al_height,
            
            // current category label
            categoryLabel.al_left == view.al_left + SectionPickerViewHeight + 10.0,
//            categoryLabel.al_right == toggleDrawer.al_left,
            categoryLabel.al_height == SectionPickerViewHeight,
            categoryLabel.al_top == view.al_top,
            
            // table View
            tableView.al_top == keyboardButton.al_bottom,
            tableView.al_left == view.al_left,
            tableView.al_right == view.al_right,
            tableView.al_bottom == view.al_bottom
        ])
    }
    
    func toggleDrawer() {
        self.layoutIfNeeded()
        
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
        var category = self.categories![indexPath.row] as Category;
        
        self.currentCategoryLabel.text = category.name
        self.toggleDrawer()
        
        self.categoryService?.requestLyrics(category.id, artistIds: nil).onSuccess({ lyrics in
            self.delegate?.didSelectSection(self, category: category)
            return
        })
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as UITableViewCell
        
        var category = self.categories![indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        cell.textLabel.text = category.name
        cell.textLabel.font = UIFont(name: "Lato-Light", size: 16)
        cell.textLabel.textColor = UIColor.whiteColor()
        cell.textLabel.textAlignment = .Center

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

protocol SectionPickerViewDelegate {
    func didSelectSection(sectionPickerView: SectionPickerView, category: Category)
}
