//
//  CategoriesPanelView.swift
//  Often
//
//  Created by Luc Succes on 3/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit
enum CategoryPanelStyle {
    case Simple
    case Detailed
}

class CategoriesPanelView: UIView {
    var switchKeyboardButton: UIButton
    var togglePackSelectedView: UIView
    var toggleCategorySelectedView: UIView

    var topSeperator: UIView
    var bottomSeperator: UIView
    var categoriesCollectionView: UICollectionView

    private var currentCategoryLabel: UILabel
    private var middleCategoryLabel: UILabel
    private var mediaItemTitle: UILabel
    private var drawerOpened: Bool = false

    private var tapRecognizer: UITapGestureRecognizer!
    private var selectedBgView: UIView
    private var toolbarView: UIView

    let didToggle = Event<Bool>()
    var attributes: [String: AnyObject] = [
        NSKernAttributeName: NSNumber(float: 1.0),
        NSFontAttributeName: UIFont(name: "Montserrat", size: 9)!,
        NSForegroundColorAttributeName: UIColor.oftBlackColor()
    ]

    var style: CategoryPanelStyle = .Detailed {
        didSet {
            setupPanelStyle()
        }
    }

    var currentCategoryText: String? {
        didSet {
            let attributedString = NSAttributedString(string: currentCategoryText!.uppercaseString, attributes: attributes)
            currentCategoryLabel.attributedText = attributedString
            middleCategoryLabel.attributedText = attributedString
        }
    }

    var mediaItemTitleText: String? {
        didSet {
            let attributedString = NSAttributedString(string: mediaItemTitleText!.uppercaseString, attributes: attributes)
            mediaItemTitle.attributedText = attributedString
        }
    }

    var isOpened: Bool {
        return drawerOpened
    }

    convenience required init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }

    override init(frame: CGRect) {

        mediaItemTitle = UILabel()
        mediaItemTitle.translatesAutoresizingMaskIntoConstraints = false
        mediaItemTitle.textColor = BlackColor
        mediaItemTitle.userInteractionEnabled = true
        mediaItemTitle.textAlignment = .Left

        togglePackSelectedView = UIView()
        togglePackSelectedView.translatesAutoresizingMaskIntoConstraints = false

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

        toggleCategorySelectedView = UIView()
        toggleCategorySelectedView.translatesAutoresizingMaskIntoConstraints = false

        switchKeyboardButton = UIButton()
        switchKeyboardButton.setImage(StyleKit.imageOfGlobe(scale: 1.1), forState: .Normal)
        switchKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        switchKeyboardButton.contentEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)

        currentCategoryLabel = UILabel()
        currentCategoryLabel.textColor = SectionPickerViewCurrentCategoryLabelTextColor
        currentCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        currentCategoryLabel.userInteractionEnabled = true
        currentCategoryLabel.textAlignment = .Right
        
        middleCategoryLabel = UILabel()
        middleCategoryLabel.textColor = SectionPickerViewCurrentCategoryLabelTextColor
        middleCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        middleCategoryLabel.userInteractionEnabled = true
        middleCategoryLabel.textAlignment = .Center

        selectedBgView = UIView(frame: CGRectZero)
        selectedBgView.backgroundColor = SectionPickerViewCellHighlightedBackgroundColor

        super.init(frame: frame)

        backgroundColor = SectionPickerViewBackgroundColor

        addSubview(toolbarView)
        addSubview(categoriesCollectionView)
        addSubview(topSeperator)
        addSubview(bottomSeperator)

        toolbarView.addSubview(currentCategoryLabel)
        toolbarView.addSubview(middleCategoryLabel)
        toolbarView.addSubview(switchKeyboardButton)
        toolbarView.addSubview(mediaItemTitle)
        toolbarView.addSubview(togglePackSelectedView)
        toolbarView.addSubview(toggleCategorySelectedView)

        setupLayout()
        setupPanelStyle()
    }
    
    func setupPanelStyle() {
        switch style {
        case .Simple:
            middleCategoryLabel.hidden = false
            currentCategoryLabel.hidden = true
            mediaItemTitle.hidden = true
            switchKeyboardButton.hidden = true
        case .Detailed:
            middleCategoryLabel.hidden = true
            currentCategoryLabel.hidden = false
            mediaItemTitle.hidden = false
            switchKeyboardButton.hidden = false
        }
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
        let collectionViewTopConstraint = categoriesCollectionView.al_top == toolbarView.al_bottom
        collectionViewTopConstraint.priority = 800

        let constraints: [NSLayoutConstraint] = [
            // toolbar
            toolbarView.al_left == al_left,
            toolbarView.al_right == al_right,
            toolbarView.al_top == al_top,
            toolbarView.al_height == SectionPickerViewHeight,

            // switch keyboard button
            switchKeyboardButton.al_left == al_left,
            switchKeyboardButton.al_centerY == toolbarView.al_centerY,
            switchKeyboardButton.al_height == SectionPickerViewHeight,
            switchKeyboardButton.al_right == mediaItemTitle.al_left,
            switchKeyboardButton.al_width == switchKeyboardButton.al_height,

            // media item title label
            mediaItemTitle.al_left ==  switchKeyboardButton.al_right + 7,
            mediaItemTitle.al_centerY == toolbarView.al_centerY,
            mediaItemTitle.al_right == al_centerX,
            mediaItemTitle.al_height == SectionPickerViewHeight,
            mediaItemTitle.al_top == toggleCategorySelectedView.al_top,

            // current category view
            toggleCategorySelectedView.al_left == mediaItemTitle.al_right,
            toggleCategorySelectedView.al_right == toolbarView.al_right,
            toggleCategorySelectedView.al_height == SectionPickerViewHeight,
            toggleCategorySelectedView.al_top == toolbarView.al_top,

            // toggle pack selected view
            togglePackSelectedView.al_centerY == toolbarView.al_centerY,
            togglePackSelectedView.al_left == switchKeyboardButton.al_right,
            togglePackSelectedView.al_right == mediaItemTitle.al_right,
            togglePackSelectedView.al_height == SectionPickerViewHeight,

            // current category label
            currentCategoryLabel.al_left == mediaItemTitle.al_right + 10,
            currentCategoryLabel.al_right == al_right - 7,
            currentCategoryLabel.al_height == SectionPickerViewHeight,
            currentCategoryLabel.al_top == toggleCategorySelectedView.al_top,
            currentCategoryLabel.al_centerY == switchKeyboardButton.al_centerY,

            //middle category label
            middleCategoryLabel.al_centerX == toolbarView.al_centerX,
            middleCategoryLabel.al_centerY == toolbarView.al_centerY,


            collectionViewTopConstraint,
            categoriesCollectionView.al_left == al_left,
            categoriesCollectionView.al_right == al_right,
            categoriesCollectionView.al_bottom == al_bottom,
        ]

        addConstraints(constraints)
    }

    func open() {
        togglePackSelectedView.userInteractionEnabled = false
        categoriesCollectionView.reloadData()

        UIView.animateWithDuration(0.25) {
            var frame = self.frame
            frame.origin.y = self.superview!.frame.height - SectionPickerViewOpenedHeight
            self.frame = frame
        }

        didToggle.emit(true)
    }

    func close() {
        togglePackSelectedView.userInteractionEnabled = true

        UIView.animateWithDuration(0.25) {
            var frame = self.frame
            switch self.style {
            case .Detailed:
                frame.origin.y = self.superview!.frame.height - SectionPickerViewHeight
            case .Simple:
                frame.origin.y = self.superview!.frame.height
            }
            
            self.frame = frame
        }

        didToggle.emit(false)
    }

}
