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
    var currentCategoryLabel: TOMSMorphingLabel
    var messageBarView: MessageBarView
    var messageBarViewTopConstraint: NSLayoutConstraint
    var shareButton: UIButton
    var drawerOpened: Bool = false
    var collectionViewEnabled: Bool = true
    var delegate: SectionPickerViewDelegate?
    var selectedBgView: UIView
    var toolbarView: UIView

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
        
        toolbarView = UIView()
        toolbarView.setTranslatesAutoresizingMaskIntoConstraints(false)
        toolbarView.backgroundColor = BlackColor
        
        shareButton = UIButton()
        shareButton.setImage(UIImage(named: "ShareApp"), forState: .Normal)
        shareButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        shareButton.backgroundColor = BlackColor
        
        currentCategoryView = UIView()
        currentCategoryView.accessibilityLabel = "currentCategoryView"
        currentCategoryView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        toggleDrawerButton = UIButton()
        toggleDrawerButton.titleLabel!.font = NextKeyboardButtonFont
        toggleDrawerButton.setTitle("\u{f132}", forState: .Normal)
        toggleDrawerButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        toggleDrawerButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 0, bottom: 0, right: 0)
        
        switchArtistButton = SwitchArtistButton()
        switchArtistButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        messageBarView = MessageBarView()
        messageBarView.setTranslatesAutoresizingMaskIntoConstraints(false)
        messageBarView.alpha = 0
        
        currentCategoryLabel = TOMSMorphingLabel()
        currentCategoryLabel.textColor = SectionPickerViewCurrentCategoryLabelTextColor
        currentCategoryLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        currentCategoryLabel.userInteractionEnabled = true
        currentCategoryLabel.font = UIFont(name: "OpenSans", size: 17)
        
        selectedBgView = UIView(frame: CGRectZero)
        selectedBgView.backgroundColor = SectionPickerViewCellHighlightedBackgroundColor
        
        messageBarViewTopConstraint = messageBarView.al_top == toolbarView.al_top
        
        super.init(frame: frame)

        backgroundColor = SectionPickerViewBackgroundColor
        
        currentCategoryView.addSubview(toggleDrawerButton)
        currentCategoryView.addSubview(currentCategoryLabel)

        addSubview(messageBarView)
        addSubview(toolbarView)
        addSubview(categoriesCollectionView)
        addSubview(shareButton)
        
        toolbarView.addSubview(nextKeyboardButton)
        toolbarView.addSubview(currentCategoryView)
        toolbarView.addSubview(switchArtistButton)

        setupLayout()
    }
    
    class func provideCollectionViewLayout(frame: CGRect) -> UICollectionViewLayout {
        var viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .Horizontal
        viewLayout.minimumInteritemSpacing = 5
        viewLayout.minimumLineSpacing = 5
        viewLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 35.0, bottom: 5.0, right: 5.0)
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
            // toolbar
            toolbarView.al_left == al_left,
            toolbarView.al_right == al_right,
            toolbarView.al_top == al_top,
            toolbarView.al_height == SectionPickerViewHeight,
            
            // keyboard button
            keyboardButton.al_left == toolbarView.al_left,
            keyboardButton.al_top == toolbarView.al_top,
            keyboardButton.al_height == SectionPickerViewHeight,
            keyboardButton.al_width == SectionPickerViewHeight,
            
            // switch artist button
            switchArtistButtonLeftConstraint,
            switchArtistButton.al_centerY == keyboardButton.al_centerY,
            switchArtistButton.al_height == SectionPickerViewSwitchArtistHeight,
            switchArtistButton.al_width == switchArtistButton.al_height,
            
            // current category view
            currentCategoryView.al_left == switchArtistButton.al_left + SectionPickerViewHeight + 10.0,
            currentCategoryView.al_right == toolbarView.al_right,
            currentCategoryView.al_height == SectionPickerViewHeight,
            currentCategoryView.al_top == toolbarView.al_top,
            
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
            collectionView.al_bottom == al_bottom,
            
            shareButton.al_left == al_left,
            shareButton.al_width == 30,
            shareButton.al_top == keyboardButton.al_bottom,
            shareButton.al_bottom == al_bottom,
            
            messageBarViewTopConstraint,
            messageBarView.al_height == 40,
            messageBarView.al_left == toolbarView.al_left,
            messageBarView.al_width == toolbarView.al_width
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
        categoriesCollectionView.reloadData()
        
        UIView.animateWithDuration(0.25) {
            var frame = self.frame
            frame.origin.y = 0
            self.frame = frame
            self.toggleDrawerButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        }
    }
    
    func close() {
        UIView.animateWithDuration(0.25) {
            var frame = self.frame
            frame.origin.y = self.superview!.frame.height - SectionPickerViewHeight
            self.frame = frame
            self.toggleDrawerButton.transform = CGAffineTransformMakeRotation(CGFloat(0))
        }
    }
    
    func showMessageBar() {
        messageBarView.alpha = 1.0
        UIView.animateWithDuration(0.3) {
            self.messageBarViewTopConstraint.constant = -40
        }
    }
    
    func hideMessageBar() {
        UIView.animateWithDuration(0.3) {
            self.messageBarViewTopConstraint.constant = 0
        }
    }
}

protocol SectionPickerViewDelegate {
    func didSelectSection(sectionPickerView: CategoriesPanelView, category: Category, index: Int)
}
