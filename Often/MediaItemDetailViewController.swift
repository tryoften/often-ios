//
//  MediaItemDetailViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 3/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation


class MediaItemDetailViewController: UIViewController {
    var mediaItemDetailView: MediaItemDetailView
    private var textProcessor: TextProcessingManager?
    private var dismissalView: UIView
    private var item: MediaItem

    init(mediaItem: MediaItem, textProcessor: TextProcessingManager?) {
        self.item = mediaItem
        self.textProcessor = textProcessor

        dismissalView = UIView()
        dismissalView.translatesAutoresizingMaskIntoConstraints = false
        dismissalView.backgroundColor = ClearColor

        mediaItemDetailView = MediaItemDetailView()
        mediaItemDetailView.translatesAutoresizingMaskIntoConstraints = false

        super.init(nibName: nil, bundle: nil)

        view.addSubview(dismissalView)
        view.addSubview(mediaItemDetailView)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MediaItemDetailViewController.dismissView), name: "TextBufferDidClear", object: nil)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        view.addConstraints([
            dismissalView.al_top == view.al_top,
            dismissalView.al_bottom == view.al_bottom,
            dismissalView.al_left == view.al_left,
            dismissalView.al_right == view.al_right,

            mediaItemDetailView.al_right == view.al_right,
            mediaItemDetailView.al_left == view.al_left,
            mediaItemDetailView.al_top == view.al_bottom - KeyboardMediaItemDetailViewHeight,
            mediaItemDetailView.al_height == KeyboardMediaItemDetailViewHeight
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetailView()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func dismissView() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func insertBitmap(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.bounds.width - 2, view.bounds.height - 2), true, 0.0)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: false)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        NSNotificationCenter.defaultCenter().postNotificationName("mediaItemInserted", object: item)
        UIPasteboard.generalPasteboard().image = image
        Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.insertedLyric), additionalProperties: AnalyticsAdditonalProperties.mediaItem(item.toDictionary()))
    }

    func insertText() {
        NSNotificationCenter.defaultCenter().postNotificationName("mediaItemInserted", object: item)
        textProcessor?.insertText(item.getInsertableText())

        Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.insertedLyric), additionalProperties: AnalyticsAdditonalProperties.mediaItem(item.toDictionary()))
    }

    func removeText() {
        NSNotificationCenter.defaultCenter().postNotificationName("mediaItemRemoved", object: item)
        for var i = 0, len = item.getInsertableText().utf16.count; i < len; i++ {
            textProcessor?.deleteBackward()
        }

        Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.removedLyric), additionalProperties: AnalyticsAdditonalProperties.mediaItem(item.toDictionary()))
    }

    func insertButtonDidTap(sender: UIButton) {
        sender.selected = !sender.selected

        if sender.selected {
            removeText()
        } else {
            insertText()
        }
    }
    
    func copyButtonDidTap(sender: UIButton) {
        sender.selected = !sender.selected
        
        if sender.selected {
            NSNotificationCenter.defaultCenter().postNotificationName("mediaItemInserted", object: item)
            UIPasteboard.generalPasteboard().string = item.getInsertableText()
            
            Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.insertedLyric), additionalProperties: AnalyticsAdditonalProperties.mediaItem(item.toDictionary()))
            
        #if !(KEYBOARD)
            let shareObjects = [item.getInsertableText()]
            
            let activityVC = UIActivityViewController(activityItems: shareObjects, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.presentViewController(activityVC, animated: true, completion: nil)
        #endif
        }
    }

    func favoriteButtonDidTap(sender: UIButton) {
        sender.selected = !sender.selected
        dismissViewControllerAnimated(true, completion: nil)
    }

    func setupDetailView() {
        switch item.type {
        case .Lyric:
            if let lyric = item as? LyricMediaItem {
            mediaItemDetailView.mediaItemText.text = lyric.text
            mediaItemDetailView.mediaItemAuthor.text = lyric.artist_name
            mediaItemDetailView.mediaItemTitle.text = lyric.track_title
            }
        case .Quote:
            if let quote = item as? QuoteMediaItem {
                mediaItemDetailView.mediaItemText.text = quote.text
                mediaItemDetailView.mediaItemAuthor.text = quote.owner_name
                mediaItemDetailView.mediaItemTitle.text = quote.origin_name
            }
        default: break
        }

        if let category = item.category {
            mediaItemDetailView.mediaItemCategoryButton.setTitle(category.name.uppercaseString, forState: .Normal)
        } else {
            mediaItemDetailView.mediaItemCategoryButton.setTitle(Category.all.name.uppercaseString, forState: .Normal)
        }
        
        mediaItemDetailView.cancelButton.addTarget(self, action: #selector(MediaItemDetailViewController.dismissView), forControlEvents: .TouchUpInside)
        mediaItemDetailView.insertButton.addTarget(self, action: #selector(MediaItemDetailViewController.insertButtonDidTap(_:)), forControlEvents: .TouchUpInside)
        mediaItemDetailView.copyButton.addTarget(self, action: #selector(MediaItemDetailViewController.copyButtonDidTap(_:)), forControlEvents: .TouchUpInside)

        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(MediaItemDetailViewController.dismissView))

        dismissalView.addGestureRecognizer(tapRecognizer)
        dismissalView.userInteractionEnabled = true

        if let imageURL = item.smallImageURL {
            self.mediaItemDetailView.mediaItemImage.nk_setImageWith(imageURL)
        }
    }

}