//
//  KeyboardMediaItemDetailViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 3/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation


class KeyboardMediaItemDetailViewController: UIViewController {
    private var keyboardMediaItemDetailView: KeyboardMediaItemDetailView
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

        UIView.animateWithDuration(0.15, delay: 0.05, options: .CurveEaseIn, animations: { () -> Void in
             self.view.layoutSubviews()
            }, completion: nil)
    }

    func cancelButtonDidTap(sender: UIButton) {
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

    func favoriteButtonDidTap(sender: UIButton) {
        sender.selected = !sender.selected
        FavoritesService.defaultInstance.toggleFavorite(sender.selected, result: lyric)

    }

    func populateDetailView() {
        keyboardMediaItemDetailView.mediaItemText.text = lyric.text
        keyboardMediaItemDetailView.mediaItemAuthor.text = lyric.artist_name
        keyboardMediaItemDetailView.mediaItemTitle.text = lyric.track_title
        keyboardMediaItemDetailView.cancelButton.addTarget(self, action: "cancelButtonDidTap:", forControlEvents: .TouchUpInside)
        keyboardMediaItemDetailView.insertButton.addTarget(self, action: "insertButtonDidTap:", forControlEvents: .TouchUpInside)
        keyboardMediaItemDetailView.favoriteButton.addTarget(self, action: "favoriteButtonDidTap:", forControlEvents: .TouchUpInside)
        keyboardMediaItemDetailView.favoriteButton.selected = FavoritesService.defaultInstance.checkFavorite(lyric)

        if  let image = lyric.smallImage,
            let imageURL = NSURL(string: image) {
                print("Loading image: \(imageURL)")
                keyboardMediaItemDetailView.mediaItemImage.setImageWithURLRequest(NSURLRequest(URL: imageURL), placeholderImage: nil, success: { (req, res, image) in
                    self.keyboardMediaItemDetailView.mediaItemImage.image = image

                    }, failure: { (req, res, error) in
                        print("Failed to load image: \(imageURL)")
                })
        }
    }

    
}