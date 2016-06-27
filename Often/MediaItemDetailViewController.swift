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
        NotificationCenter.default().addObserver(self, selector: #selector(MediaItemDetailViewController.dismissView), name: "TextBufferDidClear", object: nil)

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
        NotificationCenter.default().removeObserver(self)
    }

    func dismissView() {
        dismiss(animated: true, completion: nil)
    }

    func insertText() {
        NotificationCenter.default().post(name: Foundation.Notification.Name(rawValue: "mediaItemInserted"), object: item)
        textProcessor?.insertText(item.getInsertableText())

        Analytics.shared().track(AnalyticsProperties(eventName: AnalyticsEvent.insertedLyric), additionalProperties: AnalyticsAdditonalProperties.mediaItem(item.toDictionary()))
    }

    func removeText() {
        NotificationCenter.default().post(name: Foundation.Notification.Name(rawValue: "mediaItemRemoved"), object: item)
        for _ in 0..<item.getInsertableText().utf16.count {
            textProcessor?.deleteBackward()
        }

        Analytics.shared().track(AnalyticsProperties(eventName: AnalyticsEvent.removedLyric), additionalProperties: AnalyticsAdditonalProperties.mediaItem(item.toDictionary()))
    }

    func insertButtonDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        if sender.isSelected {
            removeText()
        } else {
            insertText()
        }
    }
    
    func copyButtonDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            NotificationCenter.default().post(name: Foundation.Notification.Name(rawValue: "mediaItemInserted"), object: item)
            UIPasteboard.general().string = item.getInsertableText()
            
            Analytics.shared().track(AnalyticsProperties(eventName: AnalyticsEvent.insertedLyric), additionalProperties: AnalyticsAdditonalProperties.mediaItem(item.toDictionary()))
            
        #if !(KEYBOARD)
            let shareObjects = [item.getInsertableText()]
            
            let activityVC = UIActivityViewController(activityItems: shareObjects, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        #endif
        }
    }

    func favoriteButtonDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        dismiss(animated: true, completion: nil)
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
            mediaItemDetailView.mediaItemCategoryButton.setTitle(category.name.uppercased(), for: UIControlState())
        } else {
            mediaItemDetailView.mediaItemCategoryButton.setTitle(Category.all.name.uppercased(), for: UIControlState())
        }
        
        mediaItemDetailView.cancelButton.addTarget(self, action: #selector(MediaItemDetailViewController.dismissView), for: .touchUpInside)
        mediaItemDetailView.insertButton.addTarget(self, action: #selector(MediaItemDetailViewController.insertButtonDidTap(_:)), for: .touchUpInside)
        mediaItemDetailView.copyButton.addTarget(self, action: #selector(MediaItemDetailViewController.copyButtonDidTap(_:)), for: .touchUpInside)

        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(MediaItemDetailViewController.dismissView))

        dismissalView.addGestureRecognizer(tapRecognizer)
        dismissalView.isUserInteractionEnabled = true

        if let imageURL = item.smallImageURL {
            self.mediaItemDetailView.mediaItemImage.nk_setImageWith(imageURL)
        }
    }

}
