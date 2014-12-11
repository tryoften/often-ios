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
    var trackService: TrackService?
    var sectionPickerView: SectionPickerView?
    var seperatorView: UIView!
    var lastInsertedLyric: Lyric?

    override func updateViewConstraints() {
        super.updateViewConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for family in UIFont.familyNames() {
            println("\(family)")
            
            for name in UIFont.fontNamesForFamilyName(family as String) {
                println("  \(name)")
            }
        }
        
        var firebaseRoot = Firebase(url: CategoryServiceEndpoint)
        categoryService = CategoryService(artistId: "drake", root: firebaseRoot)
        
        trackService = TrackService(root: firebaseRoot)
        trackService?.requestData({ data in
            
        })
        
        lyricPicker = LyricPickerTableViewController()
        lyricPicker.delegate = self
        lyricPicker.trackService = trackService
        lyricPicker.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        seperatorView = UIView(frame: CGRectZero)
        seperatorView.backgroundColor = UIColor(fromHexString: "#d8d8d8")
        seperatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        sectionPickerView = SectionPickerView(frame: CGRectZero)
        sectionPickerView?.delegate = lyricPicker
        sectionPickerView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        sectionPickerView?.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        sectionPickerView?.categoryService = categoryService

        view.addSubview(lyricPicker.view)
        view.addSubview(sectionPickerView!)
        view.addSubview(seperatorView)
        
        setupLayout()
        
        categoryService?.requestData { categories in
            self.sectionPickerView?.categories = self.categoryService?.categories
            return
        }
    }
    
    func setupLayout() {
        let lyricPicker = self.lyricPicker.view
        let sectionPickerView = self.sectionPickerView!

        //section Picker View
        view.addConstraints([
            seperatorView.al_height == 1.0,
            seperatorView.al_width == view.al_width,
            seperatorView.al_top == view.al_top,
            seperatorView.al_left == view.al_left,
            
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

        if let beforeInputText = proxy.documentContextBeforeInput {
            for var i = 0, len = beforeInputText.utf16Count; i < len; i++ {
                proxy.deleteBackward()
            }
        }
    }
    
    func didPickLyric(lyricPicker: LyricPickerTableViewController, lyric: Lyric?) {
        
        if lastInsertedLyric != nil {
            clearInput()
        }
        
        insertLyric(lyric!)
    }
    
    func insertLyric(lyric: Lyric) {
        let proxy = textDocumentProxy as UIKeyInput
        proxy.insertText(lyric.text)
        lastInsertedLyric = lyric
    }
    
    // MARK: ShareViewControllerDelegate

    func shareViewControllerDidCancel(shareVC: ShareViewController) {
        let proxy = textDocumentProxy as UIKeyInput
        
        for var i = 0, len = shareVC.lyric!.text.utf16Count; i < len; i++ {
            proxy.deleteBackward()
        }
        
        shareVC.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func shareViewControllerDidToggleShareOption(shareViewController: ShareViewController, option: ShareOption, selected: Bool, url: NSURL?) {
        
        let proxy = textDocumentProxy as UIKeyInput
        var shareString: String
        
        switch option {
        case .Spotify:
            shareString = "\nSpotify: "
            break
        case .Soundcloud:
            shareString = "\nSoundcloud: "
            break
        case .YouTube:
            shareString = "\nYouTube: "
            break
        case .Lyric:
            clearInput()
            if selected == true {
                insertLyric(shareViewController.lyric!)
            }
            break
        default:
            break
        }
        
    }
}
