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
    private var lyric: LyricMediaItem

    init(mediaItem: LyricMediaItem, textProcessor: TextProcessingManager?) {
        self.lyric = mediaItem
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

        populateDetailView()

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
        NSNotificationCenter.defaultCenter().postNotificationName("mediaItemInserted", object: lyric)
        sender.selected = !sender.selected

        if sender.selected {
            textProcessor?.defaultProxy.insertText(lyric.getInsertableText())

            Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.insertedLyric), additionalProperties: AnalyticsAdditonalProperties.mediaItem(lyric.toDictionary()))

        } else {
            for var i = 0, len = lyric.getInsertableText().utf16.count; i < len; i++ {
                textProcessor?.defaultProxy.deleteBackward()
            }

            Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.removedLyric), additionalProperties: AnalyticsAdditonalProperties.mediaItem(lyric.toDictionary()))
        }
    }
    
    func copyButtonDidTap(sender: UIButton) {
        sender.selected = !sender.selected
        
        if sender.selected {
            UIPasteboard.generalPasteboard().string = lyric.getInsertableText()
            
            Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.insertedLyric), additionalProperties: AnalyticsAdditonalProperties.mediaItem(lyric.toDictionary()))
            
            #if !(KEYBOARD)
            DropDownErrorMessage().setMessage("Copied link!".uppercaseString,
                                                  subtitle: lyric.getInsertableText(), duration: 2.0, errorBackgroundColor: UIColor(fromHexString: "#152036"))
            #endif
        }
        
    }

    func favoriteButtonDidTap(sender: UIButton) {
        sender.selected = !sender.selected
        FavoritesService.defaultInstance.toggleFavorite(sender.selected, result: lyric)
        dismissViewControllerAnimated(true, completion: nil)
    }

    func snapchatButtonDidTap(sender: UIButton) {
        sender.selected = !sender.selected
    }

    func populateDetailView() {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "dismissView")

        tintView.addGestureRecognizer(tapRecognizer)
        tintView.userInteractionEnabled = true
        keyboardMediaItemDetailView.mediaItemText.text = lyric.text
        keyboardMediaItemDetailView.mediaItemAuthor.text = lyric.artist_name
        keyboardMediaItemDetailView.mediaItemTitle.text = lyric.track_title
        keyboardMediaItemDetailView.cancelButton.addTarget(self, action: #selector(KeyboardMediaItemDetailViewController.dismissView), forControlEvents: .TouchUpInside)
        keyboardMediaItemDetailView.insertButton.addTarget(self, action: "insertButtonDidTap:", forControlEvents: .TouchUpInside)
        keyboardMediaItemDetailView.copyButton.addTarget(self, action: "copyButtonDidTap:", forControlEvents: .TouchUpInside)
        keyboardMediaItemDetailView.snapchatButton.addTarget(self, action: "snapchatButtonDidTap:", forControlEvents: .TouchUpInside)
        keyboardMediaItemDetailView.favoriteButton.addTarget(self, action: "favoriteButtonDidTap:", forControlEvents: .TouchUpInside)
        keyboardMediaItemDetailView.favoriteButton.selected = FavoritesService.defaultInstance.checkFavorite(lyric)

        if let imageURL = lyric.smallImageURL {
                print("Loading image: \(imageURL)")
                keyboardMediaItemDetailView.mediaItemImage.setImageWithURLRequest(NSURLRequest(URL: imageURL), placeholderImage: nil, success: { (req, res, image) in
                    self.keyboardMediaItemDetailView.mediaItemImage.image = image

                    }, failure: { (req, res, error) in
                        print("Failed to load image: \(imageURL)")
                })
        }
    }

    
}