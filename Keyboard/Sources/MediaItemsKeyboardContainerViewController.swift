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
    var viewModelsLoaded: Int = 0
    var packsVC: KeyboardBrowsePackItemViewController?

    override init(extraHeight: CGFloat) {

        super.init(extraHeight: extraHeight)
        
        // Only setup firebase once because this view controller gets instantiated
        // everytime the keyboard is spawned

        self.view.backgroundColor =  UIColor(fromHexString: "#E9E9E9")

        #if !(KEYBOARD_DEBUG)
            FIRApp.configure()
            FIRDatabase.database().persistenceEnabled = true
        #endif
        delay(0.5) {
            #if !(KEYBOARD_DEBUG)
                Fabric.sharedSDK().debug = true
                Fabric.with([Crashlytics.start(withAPIKey: FabricAPIKey)])
                Flurry.startSession(FlurryClientKey)
            #endif
            self.setupImageManager()
            self.viewModel = KeyboardViewModel()
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
    }

    func setupImageManager() {
        let decoder = ImageDecoderComposition(decoders: [AnimatedImageDecoder(), ImageDecoder()])
        let loader = ImageLoader(configuration: ImageLoaderConfiguration(dataLoader: ImageDataLoader(), decoder: decoder), delegate: AnimatedImageLoaderDelegate())
        let cache = AnimatedImageMemoryCache()
        ImageManager.shared = ImageManager(configuration: ImageManagerConfiguration(loader: loader, cache: cache))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let center = NotificationCenter.default()
        center.addObserver(self, selector:  #selector(MediaItemsKeyboardContainerViewController.switchKeyboard), name: SwitchKeyboardEvent, object: nil)

        NotificationCenter.default().addObserver(self, selector: #selector(MediaItemsKeyboardContainerViewController.didInsertMediaItem(_:)), name: "mediaItemInserted", object: nil)
        NotificationCenter.default().addObserver(self, selector: #selector(MediaItemsKeyboardContainerViewController.didRemoveMediaItem), name: "mediaItemRemoved", object: nil)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.bounds == CGRect.zero {
            return
        }

        if let packVC = packsVC {
             packVC.view.frame = view.bounds
        }
    }

    func resizeKeyboard(_ notification: Foundation.Notification) {
        guard let userInfo = (notification as NSNotification).userInfo,
            _ = userInfo["height"] as? CGFloat else {
                return
        }
    }
    
    func didInsertMediaItem(_ notification: Foundation.Notification) {
        if let item = notification.object as? MediaItem {
            mediaItem = item
        }
    }

    func didRemoveMediaItem() {
        mediaItem = nil
    }

    //MARK: TextProcessingManagerDelegate
    func textProcessingManagerDidChangeText(_ textProcessingManager: TextProcessingManager) {}
    func textProcessingManagerDidClearTextBuffer(_ textProcessingManager: TextProcessingManager, text: String) {
        if let item = mediaItem {
            viewModel?.logTextSendEvent(item)
            mediaItem = nil
        }
        NotificationCenter.default().post(name: Foundation.Notification.Name(rawValue: "TextBufferDidClear"), object: nil, userInfo: nil)
    }
}
