//
//  KeyboardMediaItemDetailViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 3/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation


class KeyboardMediaItemDetailViewController: UIViewController {
    var keyboardMediaItemDetailView: KeyboardMediaItemDetailView
    private var textProcessor: TextProcessingManager?
    private var keyboardMediaItemDetailViewTopConstraint: NSLayoutConstraint?
    private var tintView: UIView
    private var item: MediaItem

    init(mediaItem: MediaItem, textProcessor: TextProcessingManager?) {
        self.item = mediaItem
        self.textProcessor = textProcessor

        tintView = UIImageView()
        tintView.translatesAutoresizingMaskIntoConstraints = false
        tintView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)

        keyboardMediaItemDetailView = KeyboardMediaItemDetailView()
        keyboardMediaItemDetailView.translatesAutoresizingMaskIntoConstraints = false

        super.init(nibName: nil, bundle: nil)

        view.addSubview(tintView)
        view.addSubview(keyboardMediaItemDetailView)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        keyboardMediaItemDetailViewTopConstraint = keyboardMediaItemDetailView.al_top == view.al_bottom + 0
        view.addConstraints([
            tintView.al_top == view.al_top,
            tintView.al_bottom == view.al_bottom,
            tintView.al_left == view.al_left,
            tintView.al_right == view.al_right,

            keyboardMediaItemDetailView.al_right == view.al_right,
            keyboardMediaItemDetailView.al_left == view.al_left,
            keyboardMediaItemDetailViewTopConstraint!,
            keyboardMediaItemDetailView.al_height == KeyboardMediaItemDetailViewHeight
            ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDetailView()

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        keyboardMediaItemDetailViewTopConstraint?.constant = -KeyboardMediaItemDetailViewHeight

        UIView.animateWithDuration(0.10, delay: 0.02, options: .CurveLinear, animations: { () -> Void in
             self.view.layoutSubviews()
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
            let lyric = (item as! LyricMediaItem)
            keyboardMediaItemDetailView.mediaItemText.text = lyric.text
            keyboardMediaItemDetailView.mediaItemAuthor.text = lyric.artist_name
            keyboardMediaItemDetailView.mediaItemTitle.text = lyric.track_title
        case .Quote:
            let quote = (item as! QuoteMediaItem)
            keyboardMediaItemDetailView.mediaItemText.text = quote.text
            keyboardMediaItemDetailView.mediaItemAuthor.text = quote.owner_name
            keyboardMediaItemDetailView.mediaItemTitle.text = quote.origin_name
        default: break
        }

        if let category = item.category {
            keyboardMediaItemDetailView.mediaItemCategoryButton.setTitle(category.name.uppercaseString, forState: .Normal)
        } else {
            keyboardMediaItemDetailView.mediaItemCategoryButton.setTitle(Category.all.name.uppercaseString, forState: .Normal)
        }
        
        keyboardMediaItemDetailView.cancelButton.addTarget(self, action: "dismissView", forControlEvents: .TouchUpInside)
        keyboardMediaItemDetailView.insertButton.addTarget(self, action: "insertButtonDidTap:", forControlEvents: .TouchUpInside)
        keyboardMediaItemDetailView.copyButton.addTarget(self, action: "copyButtonDidTap:", forControlEvents: .TouchUpInside)
        keyboardMediaItemDetailView.snapchatButton.addTarget(self, action: "snapchatButtonDidTap:", forControlEvents: .TouchUpInside)
        keyboardMediaItemDetailView.favoriteButton.addTarget(self, action: "favoriteButtonDidTap:", forControlEvents: .TouchUpInside)
        keyboardMediaItemDetailView.favoriteButton.selected = FavoritesService.defaultInstance.checkFavorite(item)

        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "dismissView")

        tintView.addGestureRecognizer(tapRecognizer)
        tintView.userInteractionEnabled = true

        if let imageURL = item.smallImageURL {
                print("Loading image: \(imageURL)")
                keyboardMediaItemDetailView.mediaItemImage.setImageWithURLRequest(NSURLRequest(URL: imageURL), placeholderImage: nil, success: { (req, res, image) in
                    self.keyboardMediaItemDetailView.mediaItemImage.image = image

                    }, failure: { (req, res, error) in
                        print("Failed to load image: \(imageURL)")
                })
        }
    }

    
}