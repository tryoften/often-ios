//
//  KeyboardViewController.swift
//  CustomKeyboard
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit
import Realm

let EnableFullAccessMessage = "Ayo! enable \"Full Access\" in Settings\nfor Drizzy to do his thing"

class KeyboardViewController: UIInputViewController, LyricPickerDelegate, ShareViewControllerDelegate, KeyboardViewModelDelegate,
    ArtistPickerCollectionViewControllerDelegate, ToolTipCloseButtonDelegate {

    var lyricPicker: LyricPickerTableViewController?
    var categoryPicker: CategoryCollectionViewController!
    var artistPicker: ArtistPickerCollectionViewController?
    var toolTipViewController: ToolTipViewController?
    var heightConstraint: NSLayoutConstraint!
    var viewModel: KeyboardViewModel
    var lyricPickerViewModel: LyricPickerViewModel!
    var sectionPickerView: CategoriesPanelView!
    var seperatorView: UIView!
    var lastInsertedString: String?
    var fixedFilterBarView: UIView!
    var allowFullAccessMessage: UILabel!
    var currentlyInjectedLyric: Lyric?
    var lyricInserted = false
    static var debugKeyboard = false
    static var onceToken: dispatch_once_t = 0
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        viewModel = KeyboardViewModel()
        var firebaseRoot = Firebase(url: BaseURL)
        lyricPickerViewModel = LyricPickerViewModel(trackService: TrackService(root: firebaseRoot, realm: viewModel.realm))
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        viewModel.delegate = self
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(debug: Bool = false) {
        KeyboardViewController.debugKeyboard = debug
        self.init(nibName: nil, bundle: nil)
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        lyricPicker = LyricPickerTableViewController()
        lyricPicker!.delegate = self
        lyricPicker!.viewModel = lyricPickerViewModel
        lyricPicker!.keyboardViewController = self
        lyricPicker!.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        if !viewModel.hasSeenTooltip {
            toolTipViewController = ToolTipViewController(viewModel: viewModel)
            toolTipViewController?.closeButtonDelegate = self
            toolTipViewController!.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        }
        
        seperatorView = UIView(frame: CGRectZero)
        seperatorView.backgroundColor = KeyboardTableSeperatorColor
        seperatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        categoryPicker = CategoryCollectionViewController()
        categoryPicker.keyboardViewController = self
        
        sectionPickerView = categoryPicker.view as! CategoriesPanelView
        sectionPickerView.delegate = lyricPicker
        sectionPickerView.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        sectionPickerView.switchArtistButton.addTarget(self, action: "didTapSwitchArtistButton", forControlEvents: .TouchUpInside)
    
        view.addSubview(lyricPicker!.view)
        
        if !viewModel.hasSeenTooltip {
            view.addSubview(toolTipViewController!.view)
        }
        
        view.addSubview(sectionPickerView!)
        view.addSubview(seperatorView)
        
        bootstrap()

        setupLayout()
        setupAppearance()
        layoutArtistPickerView()
        layoutSectionPickerView()
    }
    
    override func viewWillAppear(animated: Bool) {
        heightConstraint = view.al_height == KeyboardHeight
        heightConstraint.priority = 1000
        
        view.addConstraint(heightConstraint)
        var viewFrame = view.frame
        viewFrame.size.height = KeyboardHeight
        view.frame = viewFrame
        
        if !viewModel.isFullAccessEnabled {
            sectionPickerView.showMessageBar()
        } else {
            sectionPickerView.hideMessageBar()
        }
    }
    
    func bootstrap() {
        var configuration = SEGAnalyticsConfiguration(writeKey: AnalyticsWriteKey)
        SEGAnalytics.setupWithConfiguration(configuration)
        SEGAnalytics.sharedAnalytics().screen("Keyboard_Loaded")
        AFNetworkReachabilityManager.sharedManager().startMonitoring()

        Flurry.startSession(FlurryClientKey)

        self.viewModel.requestData()
    }

    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        layoutSectionPickerView()
    }
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        layoutSectionPickerView()
    }
    
    func setupAppearance() {
        var textAttributes = [
            NSFontAttributeName: UIFont(name: "OpenSans", size: 15)!
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes(textAttributes, forState: .Normal)
        UITextField.appearance().tintColor = UIColor.blackColor()
        UITextField.appearance().font = UIFont(name: "OpenSans", size: 13)!
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
    
    /**
        Depending on whether or not the user has seen the tool tips
    */
    func setupLayout() {
        if let viewController = self.lyricPicker?.view {
            var constraints: [NSLayoutConstraint] = [
                
                seperatorView.al_height == 1.0,
                seperatorView.al_width == view.al_width,
                seperatorView.al_top == view.al_top,
                seperatorView.al_left == view.al_left,
                
                // Lyric Picker
                viewController.al_top == view.al_top,
                viewController.al_left == view.al_left,
                viewController.al_right == view.al_right,
                viewController.al_bottom == view.al_bottom
            ]
            view.addConstraints(constraints)
        }

        if !viewModel.hasSeenTooltip {
            if let viewController = self.toolTipViewController?.view {
                var constraints: [NSLayoutConstraint] = [
                    // Tool Tips
                    viewController.al_top == view.al_top,
                    viewController.al_left == view.al_left,
                    viewController.al_right == view.al_right,
                    viewController.al_bottom == view.al_bottom
                ]
                view.addConstraints(constraints)
            }
        }
    }
    
    func didTapSwitchArtistButton() {
        openPanel()
    }
    
    func openPanel() {
        if artistPicker == nil {
            artistPicker = ArtistPickerCollectionViewController(edgeInsets: UIEdgeInsets(top: 5.0, left: 35.0, bottom: 5.0, right: 5.0))
            artistPicker!.delegate = self
            artistPicker!.dataSource = viewModel

            view.addSubview(artistPicker!.view)
            layoutArtistPickerView(hidden: true)
            
            if let keyboard = viewModel.currentKeyboard,
                artistPicker = artistPicker,
                collectionView = artistPicker.collectionView,
                indexPath = NSIndexPath(forItem: keyboard.index, inSection: 0) {

                artistPicker.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
            }
        }
        categoryPicker.drawerOpened = false
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
        SEGAnalytics.sharedAnalytics().track("keyboard:categoryPanelOpened")
    }
    
    func closePanel() {
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
        SEGAnalytics.sharedAnalytics().track("keyboard:categoryPanelClosed")
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
                viewModel.logLyricInsertedEvent(lyric)
            } else {
                analytics.track("Lyric_Inserted")
            }
        }
    }

    func clearInput() {
        let proxy = textDocumentProxy as! UITextDocumentProxy
        
        //move cursor to end of text
        if let afterInputText = proxy.documentContextAfterInput {
            proxy.adjustTextPositionByCharacterOffset(count(afterInputText.utf16))
        }
        
        if let beforeInputText = lastInsertedString {
            for var i = 0, len = count(beforeInputText.utf16); i < len; i++ {
                proxy.deleteBackward()
            }
        }
    }
    
    func insertLyric(lyric: Lyric, selectedOptions: [ShareOption: NSURL]?) {
        let proxy = textDocumentProxy as! UIKeyInput
        var text = ""
        var optionKeys = [String]()
        
        if var options = selectedOptions {
            
            if (options.indexForKey(.Lyric) != nil) {
                text = lyric.text
                options.removeValueForKey(.Lyric)
            }
            
            if (!text.isEmpty && !options.isEmpty) {
                text += "\n"
            }
            
            for (option, url) in options {
                optionKeys.append(option.description)
                if (!text.isEmpty) {
                    text += "\n"
                }
                text = shareStringForOption(option, url: url)
            }
        } else {
            text = lyric.text
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
    func didPickLyric(lyricPicker: LyricPickerTableViewController, shareVC: ShareViewController, lyric: Lyric?) {
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
        clearInput()
        insertLyric(shareViewController.lyric!, selectedOptions:options)
    }
    
    // MARK: KeyboardViewModelDelegate
    
    func keyboardViewModelDidLoadData(keyboardViewModel: KeyboardViewModel, data: [Keyboard]) {
        self.artistPicker?.collectionView?.reloadData()
    }

    func keyboardViewModelCurrentKeyboardDidChange(keyboardViewModel: KeyboardViewModel, keyboard: Keyboard) {
        categoryPicker.categories = keyboard.categoryList
        artistPicker?.scrollToCellAtIndex(keyboard.index)
        if let imageURLSmall = keyboard.artist?.imageURLSmall {
            sectionPickerView.switchArtistButton.artistImageView.setImageWithURL(NSURL(string: imageURLSmall))
        }
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        var data = [
            "keyboard_id": keyboard.id,
            "owner_name": keyboard.artistName,
            "timestamp": dateFormatter.stringFromDate(NSDate.new())
        ]
        
        if let artist = keyboard.artist {
            data["owner_id"] = artist.id
        }

        SEGAnalytics.sharedAnalytics().track("keyboard:cardChanged", properties: data)
    }
    
    // MARK: ArtistPickerCollectionViewControllerDelegate
    
    func artistPickerCollectionViewControllerDidSelectKeyboard(artistPicker: ArtistPickerCollectionViewController, keyboard: Keyboard) {
        NSUserDefaults.standardUserDefaults().setValue(keyboard.id, forKey: "currentKeyboard")
        viewModel.currentKeyboard = keyboard
        closePanel()
    }
    
    func artistPickerCollectionViewDidClosePanel(artistPicker: ArtistPickerCollectionViewController) {
        closePanel()
    }
    
    // MARK: ToolTipCloseButtonDelegate
    
    func toolTipCloseButtonDidTap() {
        println("Close Button Tapped")
        viewModel.hasSeenTooltip = true
        
        UIView.animateWithDuration(0.3, animations: {
            self.toolTipViewController!.view.alpha = 0.0
        }, completion: { done in
            self.toolTipViewController!.view.removeFromSuperview()
        })
        
        
    }
}


