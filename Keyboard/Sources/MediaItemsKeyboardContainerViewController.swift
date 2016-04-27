//  MediaItemsKeyboardContainerViewController.swift
//  Often
//
//  Created by Luc Succes on 12/7/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics

enum MediaItemsKeyboardSection: Int {
    case Keyboard
    case Favorites
    case Recents
    case Trending
    case Search
}

class MediaItemsKeyboardContainerViewController: BaseKeyboardContainerViewController,
    UIScrollViewDelegate,
    TextProcessingManagerDelegate {
    var viewModel: KeyboardViewModel?
    var mediaItem: MediaItem?
    var orientationChangeListener: Listener?
    var viewModelsLoaded: dispatch_once_t = 0
    var packsVC: KeyboardBrowsePackItemViewController?

    override init(extraHeight: CGFloat) {

        // Packs
        var packId = ""

        if let lastPack = SessionManagerFlags.defaultManagerFlags.lastPack {
            packId = lastPack
        }

        super.init(extraHeight: extraHeight)
        
        // Only setup firebase once because this view controller gets instantiated
        // everytime the keyboard is spawned
        #if !(KEYBOARD_DEBUG)
        dispatch_once(&MediaItemsKeyboardContainerViewController.oncePredicate) {
            Fabric.sharedSDK().debug = true
            Fabric.with([Crashlytics.startWithAPIKey(FabricAPIKey)])
            Flurry.startSession(FlurryClientKey)
            Firebase.defaultConfig().persistenceEnabled = true
        }
        #endif

        viewModel = KeyboardViewModel()
        textProcessor = TextProcessingManager(textDocumentProxy: textDocumentProxy)
        textProcessor?.delegate = self

        packsVC = KeyboardBrowsePackItemViewController(viewModel: PackItemViewModel(packId: packId), textProcessor: textProcessor)
    
        view.backgroundColor = DefaultTheme.keyboardBackgroundColor

        if let packVC = packsVC {
            containerView.addSubview(packVC.view)

        }

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MediaItemsKeyboardContainerViewController.didInsertMediaItem(_:)), name: "mediaItemInserted", object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector:  #selector(MediaItemsKeyboardContainerViewController.switchKeyboard), name: SwitchKeyboardEvent, object: nil)
        center.addObserver(self, selector: #selector(MediaItemsKeyboardContainerViewController.didInsertMediaItem(_:)), name: SearchResultsInsertLinkEvent, object: nil)
        center.addObserver(self, selector: #selector(MediaItemsKeyboardContainerViewController.didTapEnterButton(_:)), name: KeyboardEnterKeyTappedEvent, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.bounds == CGRectZero {
            return
        }

        if let packVC = packsVC {
             packVC.view.frame = view.bounds

        }
    }

    func resizeKeyboard(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            _ = userInfo["height"] as? CGFloat else {
                return
        }
    }

    func didTapEnterButton(button: KeyboardKeyButton?) {
    }

    func didInsertMediaItem(notification: NSNotification) {
        if let item = notification.object as? MediaItem {
            mediaItem = item
        }
    }

    //MARK: TextProcessingManagerDelegate
    func textProcessingManagerDidChangeText(textProcessingManager: TextProcessingManager) {}
    func textProcessingManagerDidClearTextBuffer(textProcessingManager: TextProcessingManager, text: String) {
        if let item = mediaItem {
            viewModel?.logTextSendEvent(item)
            
            let count = SessionManagerFlags.defaultManagerFlags.userMessageCount
            SessionManagerFlags.defaultManagerFlags.userMessageCount = count + 1
        }
    }
}
