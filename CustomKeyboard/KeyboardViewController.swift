//
//  KeyboardViewController.swift
//  CustomKeyboard
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

let EnableFullAccessMessage = "Ayo! enable \"Full Access\" in Settings\nfor Drizzy to do his thing"

class KeyboardViewController: UIInputViewController, LyricPickerDelegate, ShareViewControllerDelegate, KeyboardViewModelDelegate,
    ArtistPickerCollectionViewControllerDelegate {

    var lyricPicker: LyricPickerTableViewController!
    var categoryPicker: CategoryCollectionViewController!
    var artistPicker: ArtistPickerCollectionViewController?
    var heightConstraint: NSLayoutConstraint!
    var viewModel: KeyboardViewModel!
    var lyricPickerViewModel: LyricPickerViewModel!
    var sectionPickerView: CategoriesPanelView!
    var seperatorView: UIView!
    var lastInsertedString: String?
    var fixedFilterBarView: UIView!
    var allowFullAccessMessage: UILabel!
    var currentlyInjectedLyric: Lyric?
    var lyricInserted = false

    override func updateViewConstraints() {
        super.updateViewConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = KeyboardViewModel()
        viewModel.delegate = self
        
        var firebaseRoot = Firebase(url: BaseURL)
        lyricPickerViewModel = LyricPickerViewModel(trackService: TrackService(root: firebaseRoot))
        
        lyricPicker = LyricPickerTableViewController()
        lyricPicker.delegate = self
        lyricPicker.viewModel = lyricPickerViewModel
        lyricPicker.keyboardViewController = self
        lyricPicker.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        seperatorView = UIView(frame: CGRectZero)
        seperatorView.backgroundColor = KeyboardTableSeperatorColor
        seperatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        categoryPicker = CategoryCollectionViewController()
        categoryPicker.keyboardViewController = self
        
        sectionPickerView = categoryPicker.view as! CategoriesPanelView
        sectionPickerView.delegate = lyricPicker
        sectionPickerView.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        sectionPickerView.switchArtistButton.addTarget(self, action: "didTapSwitchArtistButton", forControlEvents: .TouchUpInside)
    
        view.addSubview(lyricPicker.view)
        view.addSubview(sectionPickerView!)
        view.addSubview(seperatorView)
        
        bootstrap()
    }
    
    override func viewWillAppear(animated: Bool) {
        heightConstraint =  NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: KeyboardHeight)
        
        view.addConstraint(heightConstraint)
        
        setupLayout()
        setupAppearance()
        layoutArtistPickerView()
        layoutSectionPickerView()
    }
    
    func bootstrap() {
        var configuration = SEGAnalyticsConfiguration(writeKey: AnalyticsWriteKey)
        SEGAnalytics.setupWithConfiguration(configuration)
        SEGAnalytics.sharedAnalytics().screen("Keyboard_Loaded")
        AFNetworkReachabilityManager.sharedManager().startMonitoring()

        Flurry.startSession(FlurryClientKey)
        Firebase.defaultConfig().persistenceEnabled = true
        
        self.getCurrentUser()
        self.viewModel.requestData()
    }
    
    func getCurrentUser() {
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        layoutSectionPickerView()
    }
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        layoutSectionPickerView()
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
    
    func layoutArtistPickerView(hidden: Bool = true) {
        var artistPickerViewFrame = view.bounds
        artistPickerViewFrame.origin.x = (hidden) ? -CGRectGetMaxX(view.bounds) : 0
    
        artistPicker?.view.frame = artistPickerViewFrame
    }
    
    func layoutSectionPickerView() {
        let superviewHeight = KeyboardHeight
        if let sectionPickerView = self.sectionPickerView {
            sectionPickerView.frame = CGRectMake(CGRectGetMinX(view.frame),
                superviewHeight - SectionPickerViewHeight,
                CGRectGetWidth(view.frame),
                superviewHeight)
        }
    }
    
    func setupLayout() {
        let lyricPicker = self.lyricPicker.view

        //section Picker View
        var constraints: [NSLayoutConstraint] = [

            seperatorView.al_height == 1.0,
            seperatorView.al_width == view.al_width,
            seperatorView.al_top == view.al_top,
            seperatorView.al_left == view.al_left,

            //lyric Picker
            lyricPicker.al_top == view.al_top,
            lyricPicker.al_left == view.al_left,
            lyricPicker.al_right == view.al_right,
            lyricPicker.al_bottom == view.al_bottom
        ]
        
        view.addConstraints(constraints)
    }
    
    func didTapCloseButton() {
        UIView.animateWithDuration(0.4,
            delay: 0.1,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.1,
            options: .CurveEaseIn,
            animations: {
                self.layoutArtistPickerView()
                self.layoutSectionPickerView()
            },
            completion: nil)
    }
    
    func didTapSwitchArtistButton() {
        
        if artistPicker == nil {
            artistPicker = ArtistPickerCollectionViewController(collectionViewLayout: ArtistPickerCollectionViewLayout.provideCollectionViewLayout())
            artistPicker!.delegate = self
            artistPicker!.viewModel = viewModel
            artistPicker!.keyboards = viewModel.keyboards
            artistPicker!.closeButton.addTarget(self, action: "didTapCloseButton", forControlEvents: .TouchUpInside)
            view.addSubview(artistPicker!.view)
            layoutArtistPickerView(hidden: true)
            
            if let keyboard = viewModel.currentKeyboard,
                artistPicker = artistPicker,
                collectionView = artistPicker.collectionView,
                indexPath = NSIndexPath(forItem: keyboard.index, inSection: 0) {

                artistPicker.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
            }
        }
        
        sectionPickerView.close()
        UIView.animateWithDuration(0.3,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.1,
            options: .CurveEaseOut,
            animations: {
                self.layoutArtistPickerView(hidden: false)
                
                var sectionPickerViewFrame = self.sectionPickerView.frame
                sectionPickerViewFrame.origin.y = CGRectGetHeight(self.view.frame)
                self.sectionPickerView.frame = sectionPickerViewFrame
            },
            completion: nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        layoutSectionPickerView()
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
        let proxy = textDocumentProxy as! UITextDocumentProxy
        
        if !proxy.hasText() {
            return
        }
        
        var context = proxy.documentContextBeforeInput
        
        println("context: \(context)")
        
        if let injectedLyric = currentlyInjectedLyric {
            // Whether the current context is the currently selected lyric on not
            lyricInserted = injectedLyric == context
        }
    }

    override func textDidChange(textInput: UITextInput) {
        var proxy = textDocumentProxy as! UITextDocumentProxy
        var analytics = SEGAnalytics.sharedAnalytics()
        // When the lyric is flushed and sent to the proper context
        if lyricInserted && !proxy.hasText() {
            if let lyric = currentlyInjectedLyric {
                analytics.track("Lyric_committed", properties: [
                    "lyric_id": lyric.id,
                    "lyric_text": lyric.text,
                ])
            } else {
                analytics.track("Lyric_committed")
            }
        }
    }
    
    func deleteLyricFromDocument(lyric: Lyric) {
        let proxy = textDocumentProxy as! UITextDocumentProxy
        proxy.adjustTextPositionByCharacterOffset(count(proxy.documentContextAfterInput.utf16))
        
        var range = proxy.documentContextBeforeInput.rangeOfString(lyric.text)
        
        if range != nil {
            
        }
    }
    
    func clearInput() {
        let proxy = textDocumentProxy as! UITextDocumentProxy

        if let afterInputText = proxy.documentContextAfterInput {
            proxy.adjustTextPositionByCharacterOffset(count(afterInputText.utf16))
        }
        
        if let beforeInputText = lastInsertedString {
            for var i = 0, len = count(beforeInputText.utf16); i < len; i++ {
                proxy.deleteBackward()
            }
        }

        if let beforeInputText = proxy.documentContextBeforeInput {
            for var i = 0, len = count(beforeInputText.utf16); i < len; i++ {
                proxy.deleteBackward()
            }
        }
    }
    
    func insertLyric(lyric: Lyric, selectedOptions: [ShareOption: NSURL]?) {
        let proxy = textDocumentProxy as! UIKeyInput
        var text = ""
        var optionKeys = [String]()
        
        if let options = selectedOptions {
            
            if (options.indexForKey(.Lyric) != nil) {
                text = lyric.text + "\n"
            }
            
            for (option, url) in options {
                optionKeys.append(option.description)
                if option == .Lyric {
                    continue
                }
                text = text + "\n" + shareStringForOption(option, url: url)
            }
        } else {
            text = lyric.text
        }
        
        SEGAnalytics.sharedAnalytics().track("Lyric_Inserted", properties: [
            "lyric_id": lyric.id,
            "lyric_text": lyric.text,
            "share_options": optionKeys
        ])
        
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
        
        return shareString + url.absoluteString!
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
        currentlyInjectedLyric = lyric
        insertLyric(lyric!, selectedOptions: nil)
    }
    
    // MARK: ShareViewControllerDelegate

    func shareViewControllerDidCancel(shareVC: ShareViewController) {
        let proxy = textDocumentProxy as! UIKeyInput
        
        for var i = 0, len = count(shareVC.lyric!.text.utf16); i < len; i++ {
            proxy.deleteBackward()
        }
        
        shareVC.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func shareViewControllerDidToggleShareOptions(shareViewController: ShareViewController, options: [ShareOption: NSURL]) {
        insertLyric(shareViewController.lyric!, selectedOptions:options)
    }
    
    // MARK: KeyboardViewModelDelegate
    
    func keyboardViewModelDidLoadData(keyboardViewModel: KeyboardViewModel, data: [Keyboard]) {
        self.artistPicker?.keyboards = self.viewModel.keyboards
    }

    func keyboardViewModelCurrentKeyboardDidChange(keyboardViewModel: KeyboardViewModel, keyboard: Keyboard) {
        categoryPicker.categories = keyboard.categoryList
        artistPicker?.scrollToCellAtIndex(keyboard.index)
        sectionPickerView.switchArtistButton.artistImageView.setImageWithURL(keyboard.artist?.imageURLSmall)
    }
    
    // MARK: ArtistPickerCollectionViewControllerDelegate
    
    func artistPickerCollectionViewControllerDidSelectKeyboard(artistPicker: ArtistPickerCollectionViewController, keyboard: Keyboard) {
        NSUserDefaults.standardUserDefaults().setValue(keyboard.id, forKey: "currentKeyboard")
        viewModel.currentKeyboard = keyboard
        didTapCloseButton()
    }
}
