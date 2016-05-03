//
//  CategoriesPanelView.swift
//  Often
//
//  Created by Luc Succes on 3/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class CategoriesPanelView: UIView {
    var switchKeyboardButton: UIButton
    var backspaceButton: UIButton
    var topSeperator: UIView
    var bottomSeperator: UIView

    private var currentCategoryLabel: UILabel
    private var mediaItemTitle: UILabel
    private var drawerOpened: Bool = false
    private var selectedBgView: UIView
    private var toolbarView: UIView

    var attributes: [String: AnyObject] = [
        NSKernAttributeName: NSNumber(float: 1.0),
        NSFontAttributeName: UIFont(name: "Montserrat", size: 9)!,
        NSForegroundColorAttributeName: UIColor.oftBlackColor()
    ]

    var currentCategoryText: String? {
        didSet {
            let attributedString = NSAttributedString(string: currentCategoryText!.uppercaseString, attributes: [
                NSKernAttributeName: NSNumber(float: 1.0),
                NSFontAttributeName: UIFont(name: "OpenSans-Italic", size: 9)!,
                NSForegroundColorAttributeName: UIColor.oftBlackColor()
                ])
            currentCategoryLabel.attributedText = attributedString
        }
    }

    var mediaItemTitleText: String? {
        didSet {
            let attributedString = NSAttributedString(string: mediaItemTitleText!.uppercaseString, attributes: attributes)
            mediaItemTitle.attributedText = attributedString
        }
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

        topSeperator = UIView()
        topSeperator.backgroundColor = DarkGrey

        bottomSeperator = UIView()
        bottomSeperator.backgroundColor = DarkGrey

        toolbarView = UIView()
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        toolbarView.backgroundColor = UIColor.oftWhiteColor()
        toolbarView.layer.shadowOffset = CGSizeMake(0, 0)
        toolbarView.layer.shadowOpacity = 0.8
        toolbarView.layer.shadowColor = DarkGrey.CGColor
        toolbarView.layer.shadowRadius = 4

        switchKeyboardButton = UIButton()
        switchKeyboardButton.setImage(StyleKit.imageOfGlobe(scale: 1.1), forState: .Normal)
        switchKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        switchKeyboardButton.contentEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)

        backspaceButton = UIButton()
        backspaceButton.setImage(StyleKit.imageOfBackspaceIcon(scale: 0.7), forState: .Normal)
        backspaceButton.translatesAutoresizingMaskIntoConstraints = false
        backspaceButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 3, right: 4)

        currentCategoryLabel = UILabel()
        currentCategoryLabel.textColor = SectionPickerViewCurrentCategoryLabelTextColor
        currentCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        currentCategoryLabel.userInteractionEnabled = true
        currentCategoryLabel.textAlignment = .Right

        selectedBgView = UIView(frame: CGRectZero)
        selectedBgView.backgroundColor = SectionPickerViewCellHighlightedBackgroundColor

        super.init(frame: frame)

        backgroundColor = SectionPickerViewBackgroundColor

        addSubview(toolbarView)
        addSubview(topSeperator)
        addSubview(bottomSeperator)

        toolbarView.addSubview(currentCategoryLabel)
        toolbarView.addSubview(switchKeyboardButton)
        toolbarView.addSubview(mediaItemTitle)
        toolbarView.addSubview(backspaceButton)

        setupLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        topSeperator.frame = CGRectMake(0, 0, CGRectGetWidth(frame), 0.6)
        bottomSeperator.frame = CGRectMake(0, SectionPickerViewHeight - 0.6, CGRectGetWidth(frame), 0.6)
    }

    func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            // toolbar
            toolbarView.al_left == al_left,
            toolbarView.al_right == al_right,
            toolbarView.al_top == al_top,
            toolbarView.al_height == SectionPickerViewHeight,

            // switch keyboard button
            switchKeyboardButton.al_left == al_left + 4,
            switchKeyboardButton.al_centerY == toolbarView.al_centerY,
            switchKeyboardButton.al_height == SectionPickerViewHeight,
            switchKeyboardButton.al_width == switchKeyboardButton.al_height,

            // media item title label
            mediaItemTitle.al_left ==  switchKeyboardButton.al_right + 7,
            mediaItemTitle.al_centerY == toolbarView.al_centerY,
            mediaItemTitle.al_right == al_centerX,
            mediaItemTitle.al_height == SectionPickerViewHeight,

            // current category label
            currentCategoryLabel.al_right == backspaceButton.al_left - 5,
            currentCategoryLabel.al_height == SectionPickerViewHeight,
            currentCategoryLabel.al_centerY == switchKeyboardButton.al_centerY,

            // current category label
            backspaceButton.al_right == al_right,
            backspaceButton.al_height == SectionPickerViewHeight,
            backspaceButton.al_width == SectionPickerViewHeight,
            backspaceButton.al_centerY == switchKeyboardButton.al_centerY
        ]

        addConstraints(constraints)
    }

}
