//
//  KeyboardViewController.swift
//  CustomKeyboard
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, LyricPickerDelegate, ShareViewControllerDelegate, LyricFilterBarPromotable {

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

    override func updateViewConstraints() {
        super.updateViewConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for family in UIFont.familyNames() {
//            println("\(family)")
//            
//            for name in UIFont.fontNamesForFamilyName(family as String) {
//                println("  \(name)")
//            }
//        }
        
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
        sectionPicker.categoryService = categoryService
        
        sectionPickerView = (sectionPicker.view as SectionPickerView)
        sectionPickerView?.delegate = lyricPicker
        sectionPickerView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        sectionPickerView?.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        sectionPickerView?.categoryService = categoryService
        
        fixedFilterBarView = UIView(frame: CGRectZero)
        fixedFilterBarView.backgroundColor = UIColor.whiteColor()
        fixedFilterBarView.accessibilityIdentifier = "fixed filter bar view"
        fixedFilterBarView.alpha = 0.0
        fixedFilterBarView.setTranslatesAutoresizingMaskIntoConstraints(false)

        view.addSubview(lyricPicker.view)
        view.addSubview(sectionPickerView!)
        view.addSubview(seperatorView)
        view.addSubview(standardKeyboard.view)
        view.addSubview(fixedFilterBarView)
        
        heightConstraint = view.al_height == 230
        
        setupLayout()
        standardKeyboard.addConstraintsToInputView(standardKeyboard.view, rowViews: standardKeyboard.rowViews)
        
        categoryService?.requestData { categories in
            self.sectionPickerView?.categories = self.categoryService?.categories
            return
        }
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
            
            sectionPickerView.al_width == view.al_width,
            sectionPickerView.al_bottom == view.al_bottom,
            sectionPickerView.al_left == view.al_left,
            sectionPickerView.al_right == view.al_right,
            
            standardKeyboardView.al_bottom == view.al_bottom,
            standardKeyboardView.al_width == view.al_width,
            standardKeyboardView.al_top == view.al_top + LyricFilterBarHeight + 2 * LyricTableViewCellHeight,
            standardKeyboardView.al_left == view.al_left,
            standardKeyboardView.al_height <= 230,
            
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
        ])
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
        var screenSize = UIScreen.mainScreen().bounds.size
        
        UIView.animateWithDuration(0.5, animations: {
            self.heightConstraint.constant = screenSize.height * 0.7
            }, completion: { done in
                UIView.animateWithDuration(0.3, animations: {
                    self.standardKeyboard.view.alpha = 1.0
                })
        })
    }
    
    func hideStandardKeyboard() {
        UIView.animateWithDuration(0.5, animations: {
            self.heightConstraint.constant = 230
            }, completion: { done in
                UIView.animateWithDuration(0.3, animations: {
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
        
        if shouldPromote {
            lyricPicker.lyricFilterBar.removeFromSuperview()
            fixedFilterBarView.alpha = 1.0
            fixedFilterBarView.addSubview(lyricPicker.lyricFilterBar)
        } else {
            lyricPicker.tableView.addSubview(lyricPicker.lyricFilterBar)
            fixedFilterBarView.alpha = 0.0
        }
    
        if animated {
            UIView.commitAnimations()
        }
        
//        completion(true)
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
