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
    private var tintView: UIView
    private var item: MediaItem

    init(mediaItem: MediaItem, textProcessor: TextProcessingManager?) {
        self.item = mediaItem
        self.textProcessor = textProcessor

        tintView = UIView()
        tintView.translatesAutoresizingMaskIntoConstraints = false
        tintView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)

        mediaItemDetailView = MediaItemDetailView()
        mediaItemDetailView.alpha = 0.0
        mediaItemDetailView.translatesAutoresizingMaskIntoConstraints = false

        super.init(nibName: nil, bundle: nil)

        view.addSubview(tintView)
        view.addSubview(mediaItemDetailView)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        view.addConstraints([
            tintView.al_top == view.al_top,
            tintView.al_bottom == view.al_bottom,
            tintView.al_left == view.al_left,
            tintView.al_right == view.al_right,

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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
             self.mediaItemDetailView.alpha = 1.0
            }, completion: nil)
    }

    func dismissView() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func insertButtonDidTap(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName("mediaItemInserted", object: item)
        sender.selected = !sender.selected

        if sender.selected {
            textProcessor?.defaultProxy.insertText(item.getInsertableText())

            Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.insertedLyric), additionalProperties: AnalyticsAdditonalProperties.mediaItem(item.toDictionary()))

        } else {
            for var i = 0, len = item.getInsertableText().utf16.count; i < len; i++ {
                textProcessor?.defaultProxy.deleteBackward()
            }

            Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.removedLyric), additionalProperties: AnalyticsAdditonalProperties.mediaItem(item.toDictionary()))
        }
    }
    
    func copyButtonDidTap(sender: UIButton) {
        sender.selected = !sender.selected
        
        if sender.selected {
            UIPasteboard.generalPasteboard().string = item.getInsertableText()
            
            Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.insertedLyric), additionalProperties: AnalyticsAdditonalProperties.mediaItem(item.toDictionary()))
            
        #if !(KEYBOARD)
            DropDownErrorMessage().setMessage("Copied link!".uppercaseString,
                                                  subtitle: item.getInsertableText(), duration: 2.0, errorBackgroundColor: UIColor(fromHexString: "#152036"))
        #endif
        }
    }

    func favoriteButtonDidTap(sender: UIButton) {
        sender.selected = !sender.selected
        FavoritesService.defaultInstance.toggleFavorite(sender.selected, result: item)
        dismissViewControllerAnimated(true, completion: nil)
    }

    func snapchatButtonDidTap(sender: UIButton) {
        sender.selected = !sender.selected
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
        
        mediaItemDetailView.cancelButton.addTarget(self, action: "dismissView", forControlEvents: .TouchUpInside)
        mediaItemDetailView.insertButton.addTarget(self, action: "insertButtonDidTap:", forControlEvents: .TouchUpInside)
        mediaItemDetailView.copyButton.addTarget(self, action: "copyButtonDidTap:", forControlEvents: .TouchUpInside)
        mediaItemDetailView.snapchatButton.addTarget(self, action: "snapchatButtonDidTap:", forControlEvents: .TouchUpInside)
        mediaItemDetailView.favoriteButton.addTarget(self, action: "favoriteButtonDidTap:", forControlEvents: .TouchUpInside)
        mediaItemDetailView.favoriteButton.selected = FavoritesService.defaultInstance.checkFavorite(item)

        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "dismissView")

        tintView.addGestureRecognizer(tapRecognizer)
        tintView.userInteractionEnabled = true

        if let imageURL = item.smallImageURL {
                print("Loading image: \(imageURL)")
                mediaItemDetailView.mediaItemImage.setImageWithURLRequest(NSURLRequest(URL: imageURL), placeholderImage: nil, success: { (req, res, image) in
                    self.mediaItemDetailView.mediaItemImage.image = image

                    }, failure: { (req, res, error) in
                        print("Failed to load image: \(imageURL)")
                })
        }
    }

}