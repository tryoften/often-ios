//
//  KeyboardViewController.swift
//  CustomKeyboard
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, LyricPickerDelegate {

    @IBOutlet var nextKeyboardButton: UIButton!
    var lyricPicker: LyricPickerTableViewController!
    var heightConstraint: NSLayoutConstraint?
    var categoryService: CategoryService?
    var sectionPickerView: SectionPickerView?

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
        let screenBounds = UIScreen.mainScreen().bounds
//        self.inputView.removeConstraint(self.heightConstraint!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for family in UIFont.familyNames() {
            println("\(family)")
            
            for name in UIFont.fontNamesForFamilyName(family as String) {
                println("  \(name)")
            }
        }
        
        self.lyricPicker = LyricPickerTableViewController()
        self.view.addSubview(self.lyricPicker.view)
        self.lyricPicker.delegate = self
        self.lyricPicker.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.categoryService = CategoryService()
        
        // Perform custom UI setup here
//        self.nextKeyboardButton = UIButton.buttonWithType(.System) as UIButton
//    
//        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
//        self.nextKeyboardButton.sizeToFit()
//        self.nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
//    
//        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
//        self.view.addSubview(self.nextKeyboardButton)
        
        self.sectionPickerView = SectionPickerView(frame: CGRectZero)
        self.sectionPickerView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.sectionPickerView?.categories = self.categoryService?.categories
        self.sectionPickerView?.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.sectionPickerView!)
        
        setupLayout()
    }
    
    func setupLayout() {
        let view = self.view as ALView
        let lyricPicker = self.lyricPicker.view as ALView
        let sectionPickerView = self.sectionPickerView! as ALView

        //section Picker View
        view.addConstraints([
            sectionPickerView.al_height == 50.0 * 1.0,
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
            lyricPicker.al_bottom == sectionPickerView.al_top,
        ])
    }
    
    override func viewWillLayoutSubviews() {
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
//        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }
    
    func didPickLyric(lyricPicker: LyricPickerTableViewController, lyric: String?) {
        let proxy = self.textDocumentProxy as UIKeyInput
        
        proxy.insertText(lyric!)
    }

}
