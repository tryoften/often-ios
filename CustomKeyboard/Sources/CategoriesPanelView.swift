//
//  CategoriesPanelView.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/13/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class CategoriesPanelView: UIView {

    var categoriesCollectionView: UICollectionView
    var nextKeyboardButton: UIButton
    var toggleDrawerButton: UIButton
    var switchArtistButton: SwitchArtistButton
    var currentCategoryView: UIView
    var currentHighlightColorView: UIView
    var currentCategoryLabel: TOMSMorphingLabel
    var drawerOpened: Bool = false
    var collectionViewEnabled: Bool = true
    var delegate: SectionPickerViewDelegate?
    var selectedBgView: UIView

    convenience required init(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        
        categoriesCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: CategoriesPanelView.provideCollectionViewLayout(frame))
        categoriesCollectionView.backgroundColor = CategoriesCollectionViewBackgroundColor
        categoriesCollectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        categoriesCollectionView.registerClass(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCellReuseIdentifier)
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        
        nextKeyboardButton = UIButton()
        nextKeyboardButton.titleLabel!.font = NextKeyboardButtonFont
        nextKeyboardButton.setTitle("\u{f114}", forState: .Normal)
        nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        nextKeyboardButton.backgroundColor = NextKeyboardButtonBackgroundColor
        
        currentCategoryView = UIView()
        currentCategoryView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        currentHighlightColorView = UIView()
        currentHighlightColorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        currentHighlightColorView.hidden = true
        
        toggleDrawerButton = UIButton()
        toggleDrawerButton.titleLabel!.font = NextKeyboardButtonFont
        toggleDrawerButton.setTitle("\u{f132}", forState: .Normal)
        toggleDrawerButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        toggleDrawerButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 0, bottom: 0, right: 0)
        
        switchArtistButton = SwitchArtistButton()
        switchArtistButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        currentCategoryLabel = TOMSMorphingLabel()
        currentCategoryLabel.textColor = SectionPickerViewCurrentCategoryLabelTextColor
        currentCategoryLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        currentCategoryLabel.userInteractionEnabled = true
        currentCategoryLabel.font = UIFont(name: "Lato-Regular", size: 19)
        
        selectedBgView = UIView(frame: CGRectZero)
        selectedBgView.backgroundColor = SectionPickerViewCellHighlightedBackgroundColor
        
        super.init(frame: frame)

        backgroundColor = SectionPickerViewBackgroundColor
        
        currentCategoryView.addSubview(toggleDrawerButton)
        currentCategoryView.addSubview(currentCategoryLabel)

        addSubview(categoriesCollectionView)
        addSubview(nextKeyboardButton)
        addSubview(currentCategoryView)
        addSubview(currentHighlightColorView)
        addSubview(switchArtistButton)

        setupLayout()
    }
    
    class func provideCollectionViewLayout(frame: CGRect) -> UICollectionViewLayout {
        var viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .Horizontal
        viewLayout.minimumInteritemSpacing = 5
        viewLayout.minimumLineSpacing = 5
        viewLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 5.0, right: 5.0)
        return viewLayout
    }
    
    func setupLayout() {
        var collectionView = categoriesCollectionView
        var keyboardButton = nextKeyboardButton
        var categoryLabel = currentCategoryLabel
        var toggleDrawer = toggleDrawerButton
        var switchArtistButton = self.switchArtistButton
        var currentCategoryLabelLeftConstraint = currentCategoryLabel.al_left == switchArtistButton.al_right + 30.0
        currentCategoryLabelLeftConstraint.priority = 800
        
        var switchArtistButtonLeftConstraint = switchArtistButton.al_left == keyboardButton.al_right + 15
        switchArtistButtonLeftConstraint.priority = 800
        
        var collectionViewTopConstraint = collectionView.al_top == keyboardButton.al_bottom
        collectionViewTopConstraint.priority = 800
        
        let constraints: [NSLayoutConstraint] = [
            // keyboard button
            keyboardButton.al_left == al_left,
            keyboardButton.al_top == al_top,
            keyboardButton.al_height == SectionPickerViewHeight,
            keyboardButton.al_width == SectionPickerViewHeight,
            
            // switch artist button
            switchArtistButtonLeftConstraint,
            switchArtistButton.al_centerY == keyboardButton.al_centerY,
            switchArtistButton.al_height == SectionPickerViewSwitchArtistHeight,
            switchArtistButton.al_width == switchArtistButton.al_height,
            
            // current category view
            currentCategoryView.al_left == switchArtistButton.al_left + SectionPickerViewHeight + 10.0,
            currentCategoryView.al_right == al_right,
            currentCategoryView.al_height == SectionPickerViewHeight,
            currentCategoryView.al_top == al_top,
            
            // current highlight color view
            currentHighlightColorView.al_width == al_width,
            currentHighlightColorView.al_top == al_top - 4.5,
            currentHighlightColorView.al_height == 4.5,
            
            // toggle drawer
            toggleDrawer.al_right == currentCategoryView.al_right,
            toggleDrawer.al_top == currentCategoryView.al_top,
            toggleDrawer.al_height == SectionPickerViewHeight,
            toggleDrawer.al_width == toggleDrawer.al_height,
            
            // current category label
            currentCategoryLabelLeftConstraint,
            currentCategoryLabel.al_right == toggleDrawer.al_left,
            currentCategoryLabel.al_height == SectionPickerViewHeight,
            currentCategoryLabel.al_top == currentCategoryView.al_top,
            currentCategoryLabel.al_centerY == switchArtistButton.al_centerY,
            
            collectionViewTopConstraint,
            collectionView.al_left == al_left,
            collectionView.al_right == al_right,
            collectionView.al_bottom == al_bottom
        ]
        
        addConstraints(constraints)
    }
    
    func animateArrow(pointingUp: Bool = true) {
        let angle = (pointingUp) ? CGFloat(M_PI) : 0
        
        UIView.animateWithDuration(0.2, animations: {
            self.toggleDrawerButton.transform = CGAffineTransformMakeRotation(angle)
        })
    }
    
    func open() {
        UIView.animateWithDuration(0.2, animations: {
            var frame = self.frame
            frame.size.height = self.superview!.bounds.height
            frame.origin.y = 0
            self.frame = frame
            self.toggleDrawerButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            self.layoutIfNeeded()
            return
        }, completion: nil)
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
        }, completion: nil)
    }
}

protocol SectionPickerViewDelegate {
    func didSelectSection(sectionPickerView: CategoriesPanelView, category: Category)
}
