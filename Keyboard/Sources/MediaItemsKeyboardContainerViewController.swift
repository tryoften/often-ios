//  MediaItemsKeyboardContainerViewController.swift
//  Often
//
//  Created by Luc Succes on 12/7/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics
import Nuke
import NukeAnimatedImagePlugin
import Firebase

class MediaItemsKeyboardContainerViewController: BaseKeyboardContainerViewController,
    UIScrollViewDelegate,
    TextProcessingManagerDelegate {
    var viewModel: KeyboardViewModel?
    var mediaItem: MediaItem?
    var orientationChangeListener: Listener?
    var viewModelsLoaded: dispatch_once_t = 0
    var packsVC: KeyboardBrowsePackItemViewController?

    override init(extraHeight: CGFloat) {

        super.init(extraHeight: extraHeight)
        
        // Only setup firebase once because this view controller gets instantiated
        // everytime the keyboard is spawned

        self.view.backgroundColor =  UIColor(fromHexString: "#E9E9E9")

        dispatch_once(&MediaItemsKeyboardContainerViewController.oncePredicate) {
            
        #if !(KEYBOARD_DEBUG)
            FIRApp.configure()
            FIRDatabase.database().persistenceEnabled = true
        #endif
            delay(0.5) {
            #if !(KEYBOARD_DEBUG)
                Fabric.sharedSDK().debug = true
                Fabric.with([Crashlytics.startWithAPIKey(FabricAPIKey)])
                Flurry.startSession(FlurryClientKey)
                ImageManager.shared.setupImageManager()
            #endif
                self.viewModel = KeyboardViewModel()
            }
        }

        self.textProcessor = TextProcessingManager(textDocumentProxy: self.textDocumentProxy)
        self.textProcessor?.delegate = self
        self.packsVC = KeyboardBrowsePackItemViewController(viewModel: PacksService.defaultInstance, textProcessor: self.textProcessor)

        if let packVC = self.packsVC {
            self.containerView.addSubview(packVC.view)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.viewModel = nil
        self.textProcessor = nil
        self.packsVC = nil
        PacksService.defaultInstance
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector:  #selector(MediaItemsKeyboardContainerViewController.switchKeyboard), name: SwitchKeyboardEvent, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MediaItemsKeyboardContainerViewController.didInsertMediaItem(_:)), name: "mediaItemInserted", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MediaItemsKeyboardContainerViewController.didRemoveMediaItem), name: "mediaItemRemoved", object: nil)

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
    
    func didInsertMediaItem(notification: NSNotification) {
        if let item = notification.object as? MediaItem {
            mediaItem = item
        }
    }

    func didRemoveMediaItem() {
        mediaItem = nil
    }

    //MARK: TextProcessingManagerDelegate
    func textProcessingManagerDidChangeText(textProcessingManager: TextProcessingManager) {}
    func textProcessingManagerDidClearTextBuffer(textProcessingManager: TextProcessingManager, text: String) {
        if let item = mediaItem {
            viewModel?.logTextSendEvent(item)
            mediaItem = nil
        }
        NSNotificationCenter.defaultCenter().postNotificationName("TextBufferDidClear", object: nil, userInfo: nil)
    }
}
