//
//  AddContentPrompt.swift
//  Often
//
//  Created by Kervins Valcourt on 8/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class AddContentPrompt: UIButton {
    private var addPackImageView: UIImageView
    private var title: UILabel
    private var subTitle: UILabel
    private var isShowing: Bool = false
    private var animationDuration: NSTimeInterval = 0.3
    private var promptDownDuration: NSTimeInterval = 1.3
    private let promptViewHeight: CGFloat = 96.5
    private var titleFontSize: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 10
        }
        return 15
    }

    private var subTitleFontSize: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 9
        }
        return 12
    }

    private var subTitleRightMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 30
        }
        return 46
    }

    private var titleRightMargin: CGFloat {
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            return 43
        }
        return 58
    }

    var closeButton: UIButton

    override init(frame: CGRect) {
        addPackImageView = UIImageView()
        addPackImageView.translatesAutoresizingMaskIntoConstraints = false
        addPackImageView.backgroundColor = VeryLightGray
        addPackImageView.layer.cornerRadius = 3

        title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false

        subTitle = UILabel()
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.numberOfLines = 0

        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(StyleKit.imageOfClose(scale: 0.4), forState: .Normal)

        super.init(frame: frame)
        title.setTextWith(UIFont(name: "Montserrat-Regular", size: titleFontSize)!, letterSpacing: 0.5, color: UIColor.oftBlackColor(), text: "Let's start making your pack!")
        subTitle.setTextWith(UIFont(name: "OpenSans", size: subTitleFontSize)!, letterSpacing: 0.6, color: UIColor.oftDarkGrey74Color(), text: "Add your favorite GIF's, Photo's, and Quote to start sharing")

        backgroundColor = UIColor.oftWhiteColor()
        layer.cornerRadius = 3

        addSubview(addPackImageView)
        addSubview(title)
        addSubview(subTitle)
        addSubview(closeButton)

        addTarget(self, action: #selector(AddContentPrompt.hideView), forControlEvents: .TouchUpInside)
        closeButton.addTarget(self, action: #selector(AddContentPrompt.hideView), forControlEvents: .TouchUpInside)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddContentPrompt.hideView), name: "DismissAllNotification", object: nil)

        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func setupLayout() {
        addConstraints([
            addPackImageView.al_top == al_top + 18,
            addPackImageView.al_left == al_left + 18,
            addPackImageView.al_bottom == al_bottom - 18,
            addPackImageView.al_width == 60.5,

            closeButton.al_top == al_top,
            closeButton.al_right == al_right,
            closeButton.al_height == 40,
            closeButton.al_width == 40,

            title.al_top == al_top + 22,
            title.al_left == addPackImageView.al_right + 18,
            title.al_right == al_right - titleRightMargin,
            title.al_height == 14.5,

            subTitle.al_top == title.al_bottom,
            subTitle.al_left == addPackImageView.al_right + 18,
            subTitle.al_right == al_right - subTitleRightMargin,
            subTitle.al_bottom == al_bottom - 13
            ])
    }

    func hideView() {
        UIView.animateWithDuration(animationDuration, animations: {
            var frame: CGRect = self.frame
            frame.origin.y = -self.promptViewHeight
            self.frame = frame
            self.performSelector(#selector(AddContentPrompt.removeView(_:)), withObject: self, afterDelay: 0.3)
        })
    }

    func dismissAllPrompt() {
        NSNotificationCenter.defaultCenter().postNotificationName("DismissAllNotification", object: nil)
    }

    func showPrompt() {
        SessionManagerFlags.defaultManagerFlags.hasSeeAddContentPrompt = true
        AddContentPrompt(frame: CGRectMake(18, -promptViewHeight, UIScreen.mainScreen().bounds.size.width - 36, promptViewHeight)).setPrompt()
    }

    func removeView(alertView: UIButton) {
        alertView.removeFromSuperview()
        isShowing = false
    }

    private func setErrorMessage(title: String, duration: NSTimeInterval, subtitle: String, errorBackgroundColor: UIColor) {
        promptDownDuration = duration

        setPrompt()
    }

    private func setPrompt() {
        let frontToBackWindows = UIApplication.sharedApplication().windows.reverse()
        for window in frontToBackWindows {
            if !window.hidden {
                window.addSubview(self)
            }
        }

        isShowing = true

        UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            var frame: CGRect = self.frame
            frame.origin.y = 24
            self.frame = frame
            }, completion: nil)

    }

}