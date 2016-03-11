//
//  CategoriesPanelView.swift
//  Often
//
//  Created by Luc Succes on 3/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class CategoriesPanelView: UIView {
    var toggleDrawerButton: UIButton
    var switchArtistButton: UIButton

    var topSeperator: UIView
    var bottomSeperator: UIView
    var categoriesCollectionView: UICollectionView

    private var currentCategoryLabel: UILabel
    private var drawerOpened: Bool = false

    private var tapRecognizer: UITapGestureRecognizer!
    private var currentCategoryView: UIView
    private var selectedBgView: UIView
    private var toolbarView: UIView

    let didToggle = Event<Bool>()

    var currentCategoryText: String? {
        didSet {
            let attributes: [String: AnyObject] = [
                NSKernAttributeName: NSNumber(float: 1.0),
                NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 11)!,
                NSForegroundColorAttributeName: UIColor.oftBlackColor()
            ]
            let attributedString = NSAttributedString(string: currentCategoryText!.uppercaseString, attributes: attributes)
            currentCategoryLabel.attributedText = attributedString
        }
    }

    var isOpened: Bool {
        return drawerOpened
    }

    convenience required init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }

    override init(frame: CGRect) {
        topSeperator = UIView()
        topSeperator.backgroundColor = DarkGrey

        bottomSeperator = UIView()
        bottomSeperator.backgroundColor = DarkGrey

        categoriesCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: CategoriesPanelView.provideCollectionViewLayout(frame))
        categoriesCollectionView.backgroundColor = CategoriesCollectionViewBackgroundColor
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.registerClass(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCellReuseIdentifier)
        categoriesCollectionView.showsHorizontalScrollIndicator = false

        toolbarView = UIView()
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        toolbarView.backgroundColor = UIColor.oftWhiteColor()
        toolbarView.layer.shadowOffset = CGSizeMake(0, 0)
        toolbarView.layer.shadowOpacity = 0.8
        toolbarView.layer.shadowColor = DarkGrey.CGColor
        toolbarView.layer.shadowRadius = 4

        currentCategoryView = UIView()
        currentCategoryView.translatesAutoresizingMaskIntoConstraints = false

        toggleDrawerButton = UIButton()
        toggleDrawerButton.setImage(StyleKit.imageOfBackarrow(scale: 0.5, rotate: -90), forState: .Normal)
        toggleDrawerButton.translatesAutoresizingMaskIntoConstraints = false
        toggleDrawerButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        switchArtistButton = UIButton()
        switchArtistButton.setImage(StyleKit.imageOfMenu(scale: 1.0), forState: .Normal)
        switchArtistButton.translatesAutoresizingMaskIntoConstraints = false

        currentCategoryLabel = UILabel()
        currentCategoryLabel.textColor = SectionPickerViewCurrentCategoryLabelTextColor
        currentCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        currentCategoryLabel.userInteractionEnabled = true
        currentCategoryLabel.textAlignment = .Center
        currentCategoryLabel.font = UIFont(name: "OpenSans-Semibold", size: 11)

        selectedBgView = UIView(frame: CGRectZero)
        selectedBgView.backgroundColor = SectionPickerViewCellHighlightedBackgroundColor

        super.init(frame: frame)

        backgroundColor = SectionPickerViewBackgroundColor

        currentCategoryView.addSubview(toggleDrawerButton)
        currentCategoryView.addSubview(currentCategoryLabel)

        addSubview(toolbarView)
        addSubview(categoriesCollectionView)
        addSubview(topSeperator)
        addSubview(bottomSeperator)

        toolbarView.addSubview(currentCategoryView)
        toolbarView.addSubview(switchArtistButton)

        setupLayout()

        let toggleSelector = Selector("toggleDrawer")
        tapRecognizer = UITapGestureRecognizer(target: self, action: toggleSelector)
        toggleDrawerButton.addTarget(self, action: toggleSelector, forControlEvents: .TouchUpInside)
        currentCategoryLabel.addGestureRecognizer(tapRecognizer)
    }

    class func provideCollectionViewLayout(frame: CGRect) -> UICollectionViewLayout {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .Horizontal
        viewLayout.minimumInteritemSpacing = 6
        viewLayout.minimumLineSpacing = 6
        viewLayout.sectionInset = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
        return viewLayout
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        topSeperator.frame = CGRectMake(0, 0, CGRectGetWidth(frame), 0.6)
        bottomSeperator.frame = CGRectMake(0, SectionPickerViewHeight - 0.6, CGRectGetWidth(frame), 0.6)
    }

    func toggleDrawer() {
        if (!drawerOpened) {
            open()
        } else {
            close()
        }
        drawerOpened = !drawerOpened
    }

    func setupLayout() {
        let collectionView = categoriesCollectionView
        let toggleDrawer = toggleDrawerButton
        let switchArtistButton = self.switchArtistButton

        let currentCategoryLabelLeftConstraint = currentCategoryLabel.al_left == al_left
        currentCategoryLabelLeftConstraint.priority = 800

        let switchArtistButtonLeftConstraint = switchArtistButton.al_left == al_left + 10
        switchArtistButtonLeftConstraint.priority = 800

        let collectionViewTopConstraint = collectionView.al_top == toolbarView.al_bottom
        collectionViewTopConstraint.priority = 800

        let constraints: [NSLayoutConstraint] = [
            // toolbar
            toolbarView.al_left == al_left,
            toolbarView.al_right == al_right,
            toolbarView.al_top == al_top,
            toolbarView.al_height == SectionPickerViewHeight,

            // switch artist button
            switchArtistButtonLeftConstraint,
            switchArtistButton.al_centerY == toolbarView.al_centerY,
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
            currentCategoryLabel.al_right == al_right,
            currentCategoryLabel.al_height == SectionPickerViewHeight,
            currentCategoryLabel.al_top == currentCategoryView.al_top,
            currentCategoryLabel.al_centerY == switchArtistButton.al_centerY,

            collectionViewTopConstraint,
            collectionView.al_left == al_left,
            collectionView.al_right == al_right,
            collectionView.al_bottom == al_bottom,
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
            frame.origin.y = self.superview!.frame.height - SectionPickerViewOpenedHeight
            self.frame = frame
            self.toggleDrawerButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        }

        didToggle.emit(true)
    }

    func close() {
        UIView.animateWithDuration(0.25) {
            var frame = self.frame
            frame.origin.y = self.superview!.frame.height - SectionPickerViewHeight
            self.frame = frame
            self.toggleDrawerButton.transform = CGAffineTransformMakeRotation(CGFloat(0))
        }

        didToggle.emit(false)
    }
}
