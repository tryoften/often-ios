//
//  KeyboardViewController.swift
//  CustomKeyboard
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit
import AFNetworking
import FlurrySDK
import Analytics

let EnableFullAccessMessage = "Ayo! enable \"Full Access\" in Settings\nfor Drizzy to do his thing"

class KeyboardViewController: UIInputViewController, LyricPickerDelegate, ShareViewControllerDelegate, CategoryServiceDelegate {

    var nextKeyboardButton: UIButton!
    var lyricPicker: LyricPickerTableViewController!
    var sectionPicker: SectionPickerViewController!
//    var standardKeyboard: StandardKeyboardViewController!
    var heightConstraint: NSLayoutConstraint!
    var categoryService: CategoryService?
    var trackService: TrackService?
    var viewModel: KeyboardViewModel!
    var sectionPickerView: SectionPickerView?
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
        viewModel.requestData({ data in
            
        })
        
        lyricPicker = LyricPickerTableViewController()
        lyricPicker.delegate = self
        lyricPicker.keyboardViewController = self
        lyricPicker.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        seperatorView = UIView(frame: CGRectZero)
        seperatorView.backgroundColor = KeyboardTableSeperatorColor
        seperatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        sectionPicker = SectionPickerViewController()
        sectionPicker.keyboardViewController = self
        
        sectionPickerView = (sectionPicker.view as! SectionPickerView)
        sectionPickerView?.delegate = lyricPicker
        sectionPickerView?.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
    
        view.addSubview(lyricPicker.view)
        view.addSubview(sectionPickerView!)
        view.addSubview(seperatorView)
        
        heightConstraint = view.al_height == 230
        
        setupLayout()
        setupAppearance()
        layoutSectionPickerView()

        bootstrap()
    }
    
    func bootstrap() {
        var configuration = SEGAnalyticsConfiguration(writeKey: AnalyticsWriteKey)
        SEGAnalytics.setupWithConfiguration(configuration)
        SEGAnalytics.sharedAnalytics().screen("Keyboard_Loaded")
        
        ParseCrashReporting.enable()
        Parse.setApplicationId(ParseAppID, clientKey: ParseClientKey)
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
        Flurry.startSession(FlurryClientKey)
        Firebase.setOption("persistence", to: true)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            self.getCurrentUser()
            
            var firebaseRoot = Firebase(url: CategoryServiceEndpoint)
            self.categoryService = CategoryService(artistId: "drake", root: firebaseRoot)
            self.categoryService!.delegate = self
            self.sectionPicker.categories = self.categoryService?.categoryArray
            
            self.trackService = TrackService(root: firebaseRoot)
            self.trackService?.requestData({ data in
                
            })
            
            self.lyricPicker.trackService = self.trackService
            self.sectionPicker.categoryService = self.categoryService
            
            self.categoryService?.requestData { categories in
                dispatch_async(dispatch_get_main_queue(), {
                    self.sectionPicker.categories = self.categoryService?.categoryArray
                    return
                })
                return
            }
        })
    }
    
    func getCurrentUser() {
        var currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            SEGAnalytics.sharedAnalytics().identify(currentUser.objectId, traits: [
                "email": currentUser["email"]
            ])
            Flurry.setUserID(currentUser.objectId)
        }
    }
    
    override func viewWillLayoutSubviews() {
        if !sectionPickerView!.drawerOpened {
            layoutSectionPickerView()
        }
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
    
    func layoutSectionPickerView() {
        let superviewHeight = CGRectGetHeight(view.frame)
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
        view.addConstraints([
            heightConstraint,

            seperatorView.al_height == 1.0,
            seperatorView.al_width == view.al_width,
            seperatorView.al_top == view.al_top,
            seperatorView.al_left == view.al_left
        ])
        
        //lyric Picker
        view.addConstraints([
            lyricPicker.al_top == view.al_top,
            lyricPicker.al_left == view.al_left,
            lyricPicker.al_right == view.al_right,
            lyricPicker.al_bottom == view.al_bottom,
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
    
    // MARK: CategoryServiceDelegate
    
    func categoryServiceDidLoad(service: CategoryService) {
        self.sectionPicker.categories = self.categoryService?.categoryArray
    }
    
    func categoryServiceDidLoadCategory(service: CategoryService, category: Category) {
        
    }
    
    func categoryServiceDidAddLyric(service: CategoryService, lyric: Lyric) {
        
    }
    
    func categoryServiceLoadFailed(service: CategoryService) {
        
    }
}
