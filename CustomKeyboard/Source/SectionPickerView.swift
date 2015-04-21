//
//  SectionPickerView.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/13/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

let SectionPickerViewHeight: CGFloat = 45.0

class SectionPickerView: UIView {
    
    var categoriesTableView: UITableView
    var categoriesCollectionView: UICollectionView
    var nextKeyboardButton: UIButton
    var toggleDrawerButton: UIButton
    var currentCategoryView: UIView
    var currentCategoryLabel: UILabel
    var drawerOpened: Bool = false
    var heightConstraint: NSLayoutConstraint?
    var delegate: SectionPickerViewDelegate?
    var selectedBgView: UIView

    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        categoriesTableView = UITableView(frame: CGRectZero)
        categoriesTableView.backgroundColor = UIColor.clearColor()
        categoriesTableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        categoriesTableView.separatorStyle = .None
        categoriesTableView.rowHeight = 50

        categoriesCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: SectionPickerView.provideCollectionViewLayout(frame))
        categoriesCollectionView.backgroundColor = UIColor(fromHexString: "#121314")
        categoriesCollectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        categoriesCollectionView.registerClass(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCellReuseIdentifier)
        categoriesCollectionView.hidden = true
        
        nextKeyboardButton = UIButton()
        nextKeyboardButton.titleLabel!.font = UIFont(name: "font_icons8", size:20)
        nextKeyboardButton.setTitle("\u{f114}", forState: .Normal)
        nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        nextKeyboardButton.backgroundColor = UIColor(fromHexString: "#121314")
        
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
        selectedBgView.backgroundColor = UIColor(fromHexString: "#1f1f1f")
        
        super.init(frame: frame)

//        heightConstraint = al_height == SectionPickerViewHeight

        backgroundColor = UIColor(fromHexString: "#121314")
        
        currentCategoryView.addSubview(toggleDrawerButton)
        currentCategoryView.addSubview(currentCategoryLabel)
        
        addSubview(categoriesTableView)
        addSubview(categoriesCollectionView)
        addSubview(nextKeyboardButton)
        addSubview(currentCategoryView)

        categoriesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        
        setupLayout()
    }
    
    class func provideCollectionViewLayout(frame: CGRect) -> UICollectionViewLayout {
        var viewLayout = UICollectionViewFlowLayout()
//        let viewSize = frame.size
//        viewLayout.itemSize = CGSizeMake(140, viewSize.height / 2 - 10)
        viewLayout.scrollDirection = .Horizontal
        viewLayout.sectionInset = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
        return viewLayout
    }
    
    func setupLayout() {
        var tableView = categoriesTableView
        var collectionView = categoriesCollectionView
        var keyboardButton = nextKeyboardButton
        var categoryLabel = currentCategoryLabel
        var toggleDrawer = toggleDrawerButton
        
        addConstraints([
//            heightConstraint!,
            
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
            tableView.al_bottom == al_bottom,
            
            collectionView.al_top == keyboardButton.al_bottom,
            collectionView.al_left == al_left,
            collectionView.al_right == al_right,
            collectionView.al_bottom == al_bottom
        ])
    }
    
    func animateArrow(pointingUp: Bool = true) {
        let angle = (pointingUp) ? CGFloat(M_PI) : 0
        
        UIView.animateWithDuration(0.2, animations: {
            self.toggleDrawerButton.transform = CGAffineTransformMakeRotation(angle)
        })
    }
    
    func open() {
        
        UIView.animateWithDuration(0.2, animations: {
            println("superview height ", self.superview!.bounds.height)
            var frame = self.frame
            frame.size.height = self.superview!.bounds.height
            frame.origin.y = 0
            self.frame = frame
            self.toggleDrawerButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            self.layoutIfNeeded()
            return
            }, completion: { completed in
                completionBlock(self, completed)
        })
    }
    
    func close() {
        UIView.animateWithDuration(0.2, animations: {
            var frame = self.frame
            frame.size.height = SectionPickerViewHeight
            frame.origin.y = self.superview!.bounds.height - SectionPickerViewHeight
            self.frame = frame
            self.toggleDrawerButton.transform = CGAffineTransformMakeRotation(0)
            self.layoutIfNeeded()
            return
            }, completion: { completed in
                completionBlock(self, completed)
        })
    }
}

let completionBlock: (SectionPickerView, Bool) -> Void = { (view, done) in
}

protocol SectionPickerViewDelegate {
    func didSelectSection(sectionPickerView: SectionPickerView, category: Category)
}
