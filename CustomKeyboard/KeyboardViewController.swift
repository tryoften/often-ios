//
//  KeyboardViewController.swift
//  CustomKeyboard
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, LyricPickerDelegate, ShareViewControllerDelegate {

    @IBOutlet var nextKeyboardButton: UIButton!
    var lyricPicker: LyricPickerTableViewController!
    var heightConstraint: NSLayoutConstraint?
    var categoryService: CategoryService?
    var sectionPickerView: SectionPickerView?

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
        
        var firebaseRoot = Firebase(url: CategoryServiceEndpoint)
        self.categoryService = CategoryService(artistId: "drake", root: firebaseRoot)
        
        self.lyricPicker = LyricPickerTableViewController()
        self.lyricPicker.delegate = self
        self.lyricPicker.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.sectionPickerView = SectionPickerView(frame: CGRectZero)
        self.sectionPickerView?.delegate = self.lyricPicker
        self.sectionPickerView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.sectionPickerView?.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        self.sectionPickerView?.categoryService = self.categoryService

        self.view.addSubview(self.lyricPicker.view)
        self.view.addSubview(self.sectionPickerView!)
        
        setupLayout()
        
        self.categoryService?.requestData { categories in
            self.sectionPickerView?.categories = self.categoryService?.categories
            return
        }
    }
    
    func setupLayout() {
        let view = self.view as ALView
        let lyricPicker = self.lyricPicker.view as ALView
        let sectionPickerView = self.sectionPickerView! as ALView

        //section Picker View
        view.addConstraints([
            sectionPickerView.al_width == view.al_width,
            sectionPickerView.al_bottom == view.al_bottom,
            sectionPickerView.al_left == view.al_left,
            sectionPickerView.al_right == view.al_right
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
        var proxy = self.textDocumentProxy as UITextDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
    }
    
    func didPickLyric(lyricPicker: LyricPickerTableViewController, lyric: Lyric?) {
        let proxy = self.textDocumentProxy as UIKeyInput
        
        let shareVC = ShareViewController(nibName: "ShareView", bundle: nil)
        shareVC.lyric = lyric
        shareVC.delegate = self
        shareVC.modalPresentationStyle = .Custom

        self.presentViewController(shareVC, animated: true, completion: nil)
        proxy.insertText(lyric!.text)
    }
    
    // MARK: ShareViewControllerDelegate

    func shareViewControllerDidCancel(shareVC: ShareViewController) {
        let proxy = self.textDocumentProxy as UIKeyInput
        
        for var i = 0, len = shareVC.lyric!.text.utf16Count; i < len; i++ {
            proxy.deleteBackward()
        }
        
        shareVC.dismissViewControllerAnimated(true, completion: nil)
    }
}
