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
    var toggleDrawerButton: UIButton
    var mediaItemImageView: UIImageView
    var switchKeyboardButton: UIButton
    var switchKeyboardButtonSeperator: UIView
    var togglePackSelectedView: UIView

    var topSeperator: UIView
    var bottomSeperator: UIView
    var categoriesCollectionView: UICollectionView

    private var currentCategoryLabel: UILabel
    private var middleCategoryLabel: UILabel
    private var mediaItemTitle: UILabel
    private var mediaItemItemCount: UILabel
    private var drawerOpened: Bool = false

    private var tapRecognizer: UITapGestureRecognizer!
    private var toggleCategorySelectedView: UIView
    private var selectedBgView: UIView
    private var toolbarView: UIView

    let didToggle = Event<Bool>()
    let attributes: [String: AnyObject] = [
        NSKernAttributeName: NSNumber(float: 1.0),
        NSFontAttributeName: UIFont(name: "Montserrat", size: 9)!,
        NSForegroundColorAttributeName: UIColor.oftBlackColor()
    ]

    var style: CategoryPanelStyle = .Detailed {
        didSet {
            setupPanelStyle()
        }
    }
    
    var currentCategoryCount: String? {
        didSet {
            let attributedString = NSAttributedString(string: "(\(currentCategoryCount!.uppercaseString))", attributes: attributes)
            mediaItemItemCount.attributedText = attributedString
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
        mediaItemImageView = UIImageView()
        mediaItemImageView.translatesAutoresizingMaskIntoConstraints = false
        mediaItemImageView.contentMode = .ScaleAspectFill
        mediaItemImageView.image = UIImage(named: "placeholder")
        mediaItemImageView.layer.cornerRadius = 2.0
        mediaItemImageView.clipsToBounds = true

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

        switchKeyboardButtonSeperator = UIView()
        switchKeyboardButtonSeperator.translatesAutoresizingMaskIntoConstraints = false
        switchKeyboardButtonSeperator.backgroundColor = BlackColor

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

        toggleDrawerButton = UIButton()
        toggleDrawerButton.setImage(StyleKit.imageOfCategoryicon(scale: 0.5), forState: .Normal)
        toggleDrawerButton.setImage(StyleKit.imageOfCategoryicon(scale: 0.5, selected: true), forState: .Selected)
        toggleDrawerButton.translatesAutoresizingMaskIntoConstraints = false
        toggleDrawerButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -7, bottom: 0, right: 7)

        switchKeyboardButton = UIButton()
        switchKeyboardButton.setImage(StyleKit.imageOfGlobe(scale: 0.65), forState: .Normal)
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

        mediaItemItemCount = UILabel()
        mediaItemItemCount.textColor = SectionPickerViewCurrentCategoryLabelTextColor
        mediaItemItemCount.translatesAutoresizingMaskIntoConstraints = false
        mediaItemItemCount.userInteractionEnabled = true
        mediaItemItemCount.textAlignment = .Right

        selectedBgView = UIView(frame: CGRectZero)
        selectedBgView.backgroundColor = SectionPickerViewCellHighlightedBackgroundColor

        super.init(frame: frame)

        backgroundColor = SectionPickerViewBackgroundColor

        addSubview(toolbarView)
        addSubview(categoriesCollectionView)
        addSubview(topSeperator)
        addSubview(bottomSeperator)

        toolbarView.addSubview(toggleDrawerButton)
        toolbarView.addSubview(currentCategoryLabel)
        toolbarView.addSubview(middleCategoryLabel)
        toolbarView.addSubview(mediaItemItemCount)
        toolbarView.addSubview(switchKeyboardButton)
        toolbarView.addSubview(switchKeyboardButtonSeperator)
        toolbarView.addSubview(mediaItemImageView)
        toolbarView.addSubview(mediaItemTitle)
        toolbarView.addSubview(togglePackSelectedView)
        toolbarView.addSubview(toggleCategorySelectedView)

        setupLayout()
        setupPanelStyle()

        let toggleSelector = Selector("toggleDrawer")
        tapRecognizer = UITapGestureRecognizer(target: self, action: toggleSelector)
        toggleDrawerButton.addTarget(self, action: toggleSelector, forControlEvents: .TouchUpInside)
        toggleCategorySelectedView.addGestureRecognizer(tapRecognizer)
    }
    
    func setupPanelStyle() {
        switch style {
        case .Simple:
            middleCategoryLabel.hidden = false
            currentCategoryLabel.hidden = true
            mediaItemImageView.hidden = true
            mediaItemTitle.hidden = true
            switchKeyboardButtonSeperator.hidden = true
            switchKeyboardButton.hidden = true
            toggleDrawerButton.hidden = true
            mediaItemItemCount.hidden = true
        case .Detailed:
            middleCategoryLabel.hidden = true
            currentCategoryLabel.hidden = false
            mediaItemImageView.hidden = false
            mediaItemTitle.hidden = false
            switchKeyboardButtonSeperator.hidden = false
            switchKeyboardButton.hidden = false
            toggleDrawerButton.hidden = false
            mediaItemItemCount.hidden = false
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
            switchKeyboardButton.al_right == switchKeyboardButtonSeperator.al_left,
            switchKeyboardButton.al_width == switchKeyboardButton.al_height,

            // switch keyboard button seperator
            switchKeyboardButtonSeperator.al_width == 0.5,
            switchKeyboardButtonSeperator.al_height == 20,
            switchKeyboardButtonSeperator.al_centerY == toolbarView.al_centerY,

            // media item imageview
            mediaItemImageView.al_left == switchKeyboardButtonSeperator.al_right + 10,
            mediaItemImageView.al_centerY == toolbarView.al_centerY,
            mediaItemImageView.al_height == SectionPickerViewSwitchArtistHeight,
            mediaItemImageView.al_width == mediaItemImageView.al_height,

            // media item title label
            mediaItemTitle.al_left ==  mediaItemImageView.al_right + 7,
            mediaItemTitle.al_centerY == toolbarView.al_centerY,
            mediaItemTitle.al_right == al_centerX,
            mediaItemTitle.al_height == SectionPickerViewHeight,
            mediaItemTitle.al_top == toggleCategorySelectedView.al_top,

            // current category view
            toggleCategorySelectedView.al_left == mediaItemTitle.al_right,
            toggleCategorySelectedView.al_right == toolbarView.al_right,
            toggleCategorySelectedView.al_height == SectionPickerViewHeight,
            toggleCategorySelectedView.al_top == toolbarView.al_top,

            // toggle drawer
            toggleDrawerButton.al_right == toggleCategorySelectedView.al_right + 7,
            toggleDrawerButton.al_top == toggleCategorySelectedView.al_top,
            toggleDrawerButton.al_height == SectionPickerViewHeight,
            toggleDrawerButton.al_width == toggleDrawerButton.al_height,
            toggleDrawerButton.al_left == mediaItemItemCount.al_right,

            // toggle pack selected view
            togglePackSelectedView.al_centerY == toolbarView.al_centerY,
            togglePackSelectedView.al_left == switchKeyboardButtonSeperator.al_right,
            togglePackSelectedView.al_right == mediaItemTitle.al_right,
            togglePackSelectedView.al_height == SectionPickerViewHeight,

            // current category label
            currentCategoryLabel.al_left == mediaItemTitle.al_right + 10,
            currentCategoryLabel.al_right == mediaItemItemCount.al_left - 2,
            currentCategoryLabel.al_height == SectionPickerViewHeight,
            currentCategoryLabel.al_top == toggleCategorySelectedView.al_top,
            currentCategoryLabel.al_centerY == mediaItemImageView.al_centerY,

            // current category item count label
            mediaItemItemCount.al_left == currentCategoryLabel.al_right,
            mediaItemItemCount.al_right == toggleDrawerButton.al_left,
            mediaItemItemCount.al_height == SectionPickerViewHeight,
            mediaItemItemCount.al_top == toggleCategorySelectedView.al_top,
            mediaItemItemCount.al_centerY == mediaItemImageView.al_centerY,

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
        toggleDrawerButton.selected = true
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
        toggleDrawerButton.selected = false
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
