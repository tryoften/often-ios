//
//  KeyboardViewController.swift
//  CustomKeyboard
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, LyricPickerDelegate, ShareViewControllerDelegate, LyricFilterBarPromotable, YIFullScreenScrollDelegate {

    var nextKeyboardButton: UIButton!
    var lyricPicker: LyricPickerTableViewController!
    var sectionPicker: SectionPickerViewController!
    var standardKeyboard: StandardKeyboardViewController!
    var heightConstraint: NSLayoutConstraint!
    var categoryService: CategoryService?
    var trackService: TrackService?
    var sectionPickerView: SectionPickerView?
    var seperatorView: UIView!
    var lastInsertedString: String?
    var fixedFilterBarView: UIView!
    var allowFullAccessMessage: UILabel!

    override func updateViewConstraints() {
        super.updateViewConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Firebase.setOption("persistence", to: true)
        var firebaseRoot = Firebase(url: CategoryServiceEndpoint)
        categoryService = CategoryService(artistId: "drake", root: firebaseRoot)
        
        trackService = TrackService(root: firebaseRoot)
        trackService?.requestData({ data in
            
        })
        
        lyricPicker = LyricPickerTableViewController()
        lyricPicker.delegate = self
        lyricPicker.trackService = trackService
        lyricPicker.keyboardViewController = self
        lyricPicker.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        standardKeyboard = StandardKeyboardViewController()
        standardKeyboard.parentKeyboardViewController = self
        standardKeyboard.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        standardKeyboard.view.alpha = 0.0
        
        seperatorView = UIView(frame: CGRectZero)
        seperatorView.backgroundColor = UIColor(fromHexString: "#d8d8d8")
        seperatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        sectionPicker = SectionPickerViewController()
        sectionPicker.keyboardViewController = self
        sectionPicker.categoryService = categoryService
        
        sectionPickerView = (sectionPicker.view as SectionPickerView)
        sectionPickerView?.delegate = lyricPicker
        sectionPickerView?.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        fixedFilterBarView = UIView(frame: CGRectZero)
        fixedFilterBarView.backgroundColor = UIColor.whiteColor()
        fixedFilterBarView.accessibilityIdentifier = "fixed filter bar view"
        fixedFilterBarView.alpha = 0.0
        fixedFilterBarView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        allowFullAccessMessage = UILabel(frame: CGRectZero)
        allowFullAccessMessage.font = UIFont(name: "Lato-Regular", size: 16)
        allowFullAccessMessage.text = "Ayo! enable \"Full Access\" in Settings for this keyboard to work"
        allowFullAccessMessage.numberOfLines = 0
        allowFullAccessMessage.textAlignment = .Center
        allowFullAccessMessage.backgroundColor = UIColor(fromHexString: "#f7f7f7")
        allowFullAccessMessage.textColor = UIColor.blackColor()
        allowFullAccessMessage.hidden = true
        allowFullAccessMessage.setTranslatesAutoresizingMaskIntoConstraints(false)

        view.addSubview(lyricPicker.view)
        view.addSubview(sectionPickerView!)
        view.addSubview(seperatorView)
        view.addSubview(standardKeyboard.view)
        view.addSubview(fixedFilterBarView)
        view.addSubview(allowFullAccessMessage)
        
        heightConstraint = view.al_height == 230
        
        setupLayout()
        setupAppearance()

        standardKeyboard.addConstraintsToInputView(standardKeyboard.view, rowViews: standardKeyboard.rowViews)
        
        categoryService?.requestData { categories in
            self.sectionPicker.categories = self.categoryService?.categories
            return
        }
    
        let superviewHeight = CGRectGetHeight(view.frame)
        if let sectionPickerView = self.sectionPickerView {
            sectionPickerView.frame = CGRectMake(CGRectGetMinX(view.frame),
                superviewHeight - SectionPickerViewHeight,
                CGRectGetWidth(view.frame),
                superviewHeight)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        var openAccessGranted = isOpenAccessGranted()
        allowFullAccessMessage.hidden = openAccessGranted
        fixedFilterBarView.hidden = !openAccessGranted
        lyricPicker.view.hidden = !openAccessGranted
        sectionPickerView?.hidden = !openAccessGranted
    }
    
    func setupAppearance() {
        var textAttributes = [
            NSFontAttributeName: UIFont(name: "Lato-Light", size: 15)!
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes(textAttributes, forState: .Normal)
        UITextField.appearance().tintColor = UIColor.blackColor()
        UITextField.appearance().font = UIFont(name: "Lato-Light", size: 13)!
    }
    
    func isOpenAccessGranted() -> Bool {
        return UIPasteboard.generalPasteboard().isKindOfClass(UIPasteboard)
    }
    
    func setupLayout() {
        let lyricPicker = self.lyricPicker.view
        let sectionPickerView = self.sectionPickerView!
        let standardKeyboardView = self.standardKeyboard.view

        //section Picker View
        view.addConstraints([
            heightConstraint,

            seperatorView.al_height == 1.0,
            seperatorView.al_width == view.al_width,
            seperatorView.al_top == view.al_top,
            seperatorView.al_left == view.al_left,
            
            standardKeyboardView.al_bottom == view.al_bottom,
            standardKeyboardView.al_width == view.al_width,
            standardKeyboardView.al_top == view.al_top + LyricFilterBarHeight + 2 * LyricTableViewCellHeight,
            standardKeyboardView.al_left == view.al_left,
            standardKeyboardView.al_height <= 200,
            
            fixedFilterBarView.al_height == LyricFilterBarHeight,
            fixedFilterBarView.al_top == view.al_top,
            fixedFilterBarView.al_width == view.al_width,
            fixedFilterBarView.al_left == view.al_left
        ])
        
        //lyric Picker
        view.addConstraints([
            lyricPicker.al_top == view.al_top,
            lyricPicker.al_left == view.al_left,
            lyricPicker.al_right == view.al_right,
            lyricPicker.al_bottom == view.al_bottom,
            
            allowFullAccessMessage.al_top == view.al_top,
            allowFullAccessMessage.al_left == view.al_left,
            allowFullAccessMessage.al_bottom == view.al_bottom,
            allowFullAccessMessage.al_right == view.al_right
        ])
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let superviewHeight = CGRectGetHeight(view.frame)
        if let sectionPickerView = self.sectionPickerView {
            sectionPickerView.frame = CGRectMake(CGRectGetMinX(view.frame),
                superviewHeight - SectionPickerViewHeight,
                CGRectGetWidth(view.frame),
                SectionPickerViewHeight)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        var proxy = textDocumentProxy as UITextDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
    }
    
    func deleteLyricFromDocument(lyric: Lyric) {
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.adjustTextPositionByCharacterOffset(proxy.documentContextAfterInput.utf16Count)
        
        var range = proxy.documentContextBeforeInput.rangeOfString(lyric.text)
        
        if range != nil {
            
        }
    }
    
    func clearInput() {
        let proxy = textDocumentProxy as UITextDocumentProxy

        if let afterInputText = proxy.documentContextAfterInput {
            proxy.adjustTextPositionByCharacterOffset(afterInputText.utf16Count)
        }
        
        if let beforeInputText = lastInsertedString {
            for var i = 0, len = beforeInputText.utf16Count; i < len; i++ {
                proxy.deleteBackward()
            }
        }

        if let beforeInputText = proxy.documentContextBeforeInput {
            for var i = 0, len = beforeInputText.utf16Count; i < len; i++ {
                proxy.deleteBackward()
            }
        }
    }
    
    func insertLyric(lyric: Lyric, selectedOptions: [ShareOption: NSURL]?) {
        let proxy = textDocumentProxy as UIKeyInput
        var text = ""
        
        if let options = selectedOptions {
            
            if (options.indexForKey(.Lyric) != nil) {
                text = lyric.text + "\n\n"
            }
            
            for (option, url) in options {
                if option == .Lyric {
                    continue
                }
                text += shareStringForOption(option, url: url)
            }
        } else {
            text = lyric.text + "\n"
        }
        
        clearInput()
        proxy.insertText(text)
        lastInsertedString = text
    }
    
    func shareStringForOption(option: ShareOption, url: NSURL) -> String {
        var shareString = ""
    
        switch option {
            case .Spotify:
                shareString = "Spotify: "
                break
            case .Soundcloud:
                shareString = "Soundcloud: "
                break
            case .YouTube:
                shareString = "YouTube: "
                break
            default:
                break
        }
        
        return shareString + url.absoluteString! + "\n"
    }
    
    func displayStandardKeyboard() {
        var height = 200
            + LyricTableViewCellHeight * 2 + LyricFilterBarHeight

        UIView.animateWithDuration(0.5, animations: {
            self.heightConstraint.constant = height
            }, completion: { done in
                UIView.animateWithDuration(0.3, animations: {
                    self.sectionPickerView?.alpha = 0.0
                    self.standardKeyboard.view.alpha = 1.0
                })
        })
    }
    
    func hideStandardKeyboard() {
        UIView.animateWithDuration(0.5, animations: {
            self.heightConstraint.constant = 230
            }, completion: { done in
                UIView.animateWithDuration(0.3, animations: {
                    self.sectionPickerView?.alpha = 1.0
                    self.standardKeyboard.view.alpha = 0.0
                })
        })
    }
    
    // MARK: LyricFilterBarPromotable
    func promote(shouldPromote: Bool, animated: Bool) {
        if animated {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.3)
        }
    
        if animated {
            UIView.commitAnimations()
        }
    }
    
    // MARK: LyricPickerDelegate
    func didPickLyric(lyricPicker: LyricPickerTableViewController,shareVC: ShareViewController, lyric: Lyric?) {
        shareVC.delegate = self
        
        insertLyric(lyric!, selectedOptions: nil)
    }
    
    // MARK: ShareViewControllerDelegate

    func shareViewControllerDidCancel(shareVC: ShareViewController) {
        let proxy = textDocumentProxy as UIKeyInput
        
        for var i = 0, len = shareVC.lyric!.text.utf16Count; i < len; i++ {
            proxy.deleteBackward()
        }
        
        shareVC.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func shareViewControllerDidToggleShareOptions(shareViewController: ShareViewController, options: [ShareOption: NSURL]) {
        insertLyric(shareViewController.lyric!, selectedOptions:options)
    }
}
