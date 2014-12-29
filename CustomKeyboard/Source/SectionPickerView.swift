//
//  SectionPickerView.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/13/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

let SectionPickerViewHeight: CGFloat = 45.0

class SectionPickerView: ILTranslucentView, UITableViewDataSource, UITableViewDelegate {
    var categoriesTableView: UITableView
    var nextKeyboardButton: UIButton
    var toggleDrawerButton: UIButton
    var currentCategoryView: UIView
    var currentCategoryLabel: UILabel
    var drawerOpened: Bool = false
    var heightConstraint: NSLayoutConstraint?
    var delegate: SectionPickerViewDelegate?
    var categoryService: CategoryService?
    var currentCategory: Category?
    var selectedBgView: UIView

    var categories: [Category]? {
        didSet {
            categoriesTableView.reloadData()
            if (categories!.count > 0) {
                currentCategory = categories![0]
                delegate?.didSelectSection(self, category: currentCategory!)
                dispatch_async(dispatch_get_main_queue(), {
                    self.currentCategoryLabel.text = self.currentCategory!.name
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
        categoriesTableView.rowHeight = 50
        
        nextKeyboardButton = UIButton()
        nextKeyboardButton.titleLabel!.font = UIFont(name: "font_icons8", size:20)
        nextKeyboardButton.setTitle("\u{f114}", forState: .Normal)
        nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        nextKeyboardButton.backgroundColor = UIColor(fromHexString: "#ffc538")
        
        currentCategoryView = UIView()
        currentCategoryView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        toggleDrawerButton = UIButton()
        toggleDrawerButton.titleLabel!.font = UIFont(name: "font_icons8", size:20)
        toggleDrawerButton.setTitle("\u{f132}", forState: .Normal)
        toggleDrawerButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        toggleDrawerButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 0, bottom: 0, right: 0)
        
        currentCategoryLabel = UILabel()
        currentCategoryLabel.textColor = UIColor.whiteColor()
        currentCategoryLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        currentCategoryLabel.userInteractionEnabled = true
        currentCategoryLabel.font = UIFont(name: "Lato-Regular", size: 19)
        
        selectedBgView = UIView(frame: CGRectZero)
        selectedBgView.backgroundColor = UIColor(fromHexString: "#ffc538")
        
        super.init(frame: frame)

        heightConstraint = al_height == SectionPickerViewHeight

        translucent = false
        backgroundColor = UIColor(fromHexString: "#ffae36")
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        
        currentCategoryView.addSubview(toggleDrawerButton)
        currentCategoryView.addSubview(currentCategoryLabel)
        
        addSubview(categoriesTableView)
        addSubview(nextKeyboardButton)
        addSubview(currentCategoryView)
        
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
        
        addConstraints([
            heightConstraint!,
            
            // keyboard button
            keyboardButton.al_left == al_left,
            keyboardButton.al_top == al_top,
            keyboardButton.al_height == SectionPickerViewHeight,
            keyboardButton.al_width == SectionPickerViewHeight,
            
            // current category view
            currentCategoryView.al_left == al_left + SectionPickerViewHeight + 10.0,
            currentCategoryView.al_right == al_right,
            currentCategoryView.al_height == SectionPickerViewHeight,
            currentCategoryView.al_top == al_top,
            
            // toggle drawer
            toggleDrawer.al_right == currentCategoryView.al_right,
            toggleDrawer.al_top == currentCategoryView.al_top,
            toggleDrawer.al_height == SectionPickerViewHeight,
            toggleDrawer.al_width == toggleDrawer.al_height,
            
            // current category label
            currentCategoryLabel.al_left == currentCategoryView.al_left,
            currentCategoryLabel.al_right == toggleDrawer.al_left,
            currentCategoryLabel.al_height == SectionPickerViewHeight,
            currentCategoryLabel.al_top == currentCategoryView.al_top,
            
            // table View
            tableView.al_top == keyboardButton.al_bottom,
            tableView.al_left == al_left,
            tableView.al_right == al_right,
            tableView.al_bottom == al_bottom
        ])
    }
    
    func toggleDrawer() {
        layoutIfNeeded()
        
        if (!drawerOpened) {
            open()
        } else {
            close()
        }
        drawerOpened = !drawerOpened
    }
    
    func open() {
        UIView.animateWithDuration(0.2, animations: {
            println("superview height ", self.superview!.bounds.height)
            self.heightConstraint?.constant = self.superview!.bounds.height
            self.layoutIfNeeded()
            return
            }, completion: { completed in
                completionBlock(self, completed)
        })
    }
    
    func close() {
        UIView.animateWithDuration(0.2, animations: {
            self.heightConstraint?.constant = SectionPickerViewHeight
            self.layoutIfNeeded()
            return
            }, completion: { completed in
                completionBlock(self, completed)
        })
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var category = categories![indexPath.row] as Category;
        
        currentCategory = category
        currentCategoryLabel.text = category.name
        toggleDrawer()
        
        categoryService?.requestLyrics(category.id, artistIds: nil).onSuccess({ lyrics in
            self.delegate?.didSelectSection(self, category: category)
            return
        })
    }
    
//    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        if let category = categories?[indexPath.row] {
//            var selected = category == currentCategory
//            return selected
//        }
//        return false
//    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as UITableViewCell
        
        var category = categories![indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = selectedBgView
        cell.textLabel!.text = category.name
        cell.textLabel!.font = UIFont(name: "Lato-Light", size: 20)
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.textLabel!.textAlignment = .Center

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

let completionBlock: (SectionPickerView, Bool) -> Void = { (view, done) in
    let angle = (view.drawerOpened) ? CGFloat(M_PI) : 0
    UIView.beginAnimations("rotate", context: nil)
    UIView.setAnimationDuration(0.2)
    view.toggleDrawerButton.transform = CGAffineTransformMakeRotation(angle)
    UIView.commitAnimations()
    
}

protocol SectionPickerViewDelegate {
    func didSelectSection(sectionPickerView: SectionPickerView, category: Category)
}
