//
//  KeyboardViewController.swift
//  CustomKeyboard
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit
import Realm
import Fabric
import Crashlytics

let EnableFullAccessMessage = "Ayo! enable \"Full Access\" in Settings\nfor Drizzy to do his thing"

class KeyboardViewController: UIInputViewController,
    KeyboardViewModelDelegate,
    TextProcessingManagerDelegate,
    ArtistPickerCollectionViewControllerDelegate,
    ToolTipCloseButtonDelegate {

    var lyricPicker: LyricPickerTableViewController?
    var categoryPicker: CategoryCollectionViewController!
    var artistPicker: ArtistPickerCollectionViewController?
    var toolTipViewController: ToolTipViewController?
    var heightConstraint: NSLayoutConstraint!
    var viewModel: KeyboardViewModel
    var lyricPickerViewModel: LyricPickerViewModel!
    var sectionPickerView: CategoriesPanelView!
    var seperatorView: UIView!
    var textProcessor: TextProcessingManager!
    static var debugKeyboard = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        viewModel = KeyboardViewModel.sharedInstance
        lyricPickerViewModel = LyricPickerViewModel(trackService: viewModel.keyboardService.trackService)
    
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        textProcessor = TextProcessingManager(textDocumentProxy: textDocumentProxy as! UITextDocumentProxy)
        viewModel.delegate = self
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(debug: Bool = false) {
        KeyboardViewController.debugKeyboard = debug
        self.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        viewModel.delegate = nil
        lyricPicker = nil
        artistPicker = nil
        categoryPicker = nil
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
    
        lyricPicker = LyricPickerTableViewController(viewModel: lyricPickerViewModel)
        lyricPicker!.delegate = textProcessor
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
        
        setupLayout()
        setupAppearance()
        layoutArtistPickerView()
        layoutSectionPickerView()
        bootstrap()
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
        layoutSectionPickerView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        layoutSectionPickerView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        artistPicker = nil
        lyricPicker = nil
    }
    
    func bootstrap() {
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
        Flurry.startSession(FlurryClientKey)

        viewModel.requestData()
    }

    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        layoutSectionPickerView()
        layoutArtistPickerView()
    }
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        layoutSectionPickerView()
        layoutArtistPickerView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("received memory warning")
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
        UIView.animateWithDuration(0.3) {
            self.layoutArtistPickerView(hidden: false)
            var sectionPickerViewFrame = self.sectionPickerView.frame
            sectionPickerViewFrame.origin.y = CGRectGetHeight(self.view.frame)
            self.sectionPickerView.frame = sectionPickerViewFrame
        }
        SEGAnalytics.sharedAnalytics().track("keyboard:categoryPanelOpened")
    }
    
    func closePanel() {
        UIView.animateWithDuration(0.4) {
            self.layoutArtistPickerView()
            self.layoutSectionPickerView()
        }
        SEGAnalytics.sharedAnalytics().track("keyboard:categoryPanelClosed")
    }
    
    override func textWillChange(textInput: UITextInput) {
        textProcessor.textWillChange(textInput)
    }
    
    override func textDidChange(textInput: UITextInput) {
        textProcessor.textDidChange(textInput)
    }

    override func selectionWillChange(textInput: UITextInput) {
        textProcessor.selectionWillChange(textInput)
    }
    
    override func selectionDidChange(textInput: UITextInput) {
        textProcessor.selectionDidChange(textInput)
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
    
    // MARK: KeyboardViewModelDelegate
    func keyboardViewModelDidLoadData(keyboardViewModel: KeyboardViewModel, data: [Keyboard]) {
        self.artistPicker?.collectionView?.reloadData()
    }

    func keyboardViewModelCurrentKeyboardDidChange(keyboardViewModel: KeyboardViewModel, keyboard: Keyboard) {
        categoryPicker.categories = keyboard.categoryList
        lyricPickerViewModel.categories = keyboard.categoryList
        categoryPicker.pickerView.currentCategoryLabel.text = keyboard.artistName

        artistPicker?.scrollToCellAtIndex(keyboard.index)
        if let imageURLSmall = keyboard.artist?.imageURLSmall {
            sectionPickerView.switchArtistButton.artistImageView.setImageWithURL(NSURL(string: imageURLSmall))
        }
        
        if let lyricPicker = self.lyricPicker {
            lyricPicker.tableView.alpha = 0.0
            lyricPicker.tableView.layer.transform = CATransform3DMakeScale(0.90, 0.90, 0.90)
            
            lyricPicker.tableView.reloadData()
            
            UIView.animateWithDuration(0.3, animations: {
                lyricPicker.tableView.alpha = 1.0
                lyricPicker.tableView.layer.transform = CATransform3DIdentity
            })
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
    
    
    // MARK: TextProcessingManagerDelegate
    func textProcessingManagerDidChangeText(textProcessingManager: TextProcessingManager) {
        if let lyric = textProcessingManager.currentlyInjectedLyric {
            viewModel.logLyricInsertedEvent(lyric)
        }
    }
}


