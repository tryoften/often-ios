//
//  MediaItemsCollectionBaseViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 10/23/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//
//  swiftlint:disable force_cast
//  swiftlint:disable function_body_length

import UIKit
import Nuke
import NukeAnimatedImagePlugin
import FLAnimatedImage

let MediaItemCollectionViewCellReuseIdentifier = "MediaItemCollectionViewCell"
let BrowseMediaItemCollectionViewCellReuseIdentifier = "BrowseMediaItemCollectionViewCell"

class MediaItemsCollectionBaseViewController: FullScreenCollectionViewController, MediaItemsCollectionViewCellDelegate, UIViewControllerTransitioningDelegate {
    weak var textProcessor: TextProcessingManager?
    var favoritesCollectionListener: Listener? = nil
    var favoriteSelected: Bool = false
    var emptyStateView: EmptyStateView?
    var transitionAnimator: FadeInTransitionAnimator?
    var loaderView: AnimatedLoaderView?
    var isDataLoaded: Bool {
        return false
    }

    internal var cellsAnimated: [IndexPath: Bool]
    internal var loaderTimeoutTimer: Timer?

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        cellsAnimated = [:]

        super.init(collectionViewLayout: layout)
        collectionView?.register(MediaItemCollectionViewCell.self, forCellWithReuseIdentifier: MediaItemCollectionViewCellReuseIdentifier)
        collectionView?.register(BrowseMediaItemCollectionViewCell.self, forCellWithReuseIdentifier: BrowseMediaItemCollectionViewCellReuseIdentifier)
    }

    deinit {
        favoritesCollectionListener = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emptyStateView?.frame = view.bounds
        loaderView?.frame = view.bounds
    }

    func requestData(_ animated: Bool = false) {
        showLoaderIfNeeded()
    }

    func showLoaderIfNeeded() {
        if !isDataLoaded {
            showLoadingView()
        } else {
            collectionView?.isHidden = false
        }
    }

    func showLoadingView() {
        if let loaderView = loaderView {
            loaderView.removeFromSuperview()
        }

        loaderView = AnimatedLoaderView(frame: view.bounds)
        view.addSubview(loaderView!)

        loaderTimeoutTimer = Timer.scheduledTimer(timeInterval: 5.0,
            target: self,
            selector: #selector(MediaItemsCollectionBaseViewController.timeoutLoader),
            userInfo: nil,
            repeats: false)
    }

    func hideLoadingView() {
        guard let loaderView = loaderView else {
            return
        }

        UIView.animate(withDuration: 0.3, delay: 1.0, options: [], animations: {
            loaderView.alpha = 0.0
        }, completion: { done in
            loaderView.isHidden = true
            loaderView.removeFromSuperview()
            self.loaderView = nil
        })

        loaderTimeoutTimer?.invalidate()
    }

    func timeoutLoader() {
        hideLoadingView()
    }

    func showEmptyStateViewForState(_ state: UserState, animated: Bool = false, completion: ((EmptyStateView) -> Void)? = nil) {
        if let oldStateView = emptyStateView where oldStateView.state == state {
            return
        }

        collectionView?.isScrollEnabled = false
        emptyStateView?.removeFromSuperview()
        emptyStateView = EmptyStateView.emptyStateViewForUserState(state)
        emptyStateView?.closeButton.addTarget(self, action: #selector(MediaItemsCollectionBaseViewController.didTapEmptyStateViewCloseButton), for: .touchUpInside)
        

        if let emptyStateView = emptyStateView {
            emptyStateView.alpha = 0.0
            view.addSubview(emptyStateView)

            UIView.animate(withDuration: animated ? 0.3 : 0.0) {
                emptyStateView.alpha = 1.0
            }

            viewDidLayoutSubviews()
            completion?(emptyStateView)
        }
    }

    func didTapEmptyStateViewCloseButton() {
        UIView.animate(withDuration: 0.4) {
            self.emptyStateView?.alpha = 0
        }

        hideEmptyStateView()
    }

    func hideEmptyStateView(_ animated: Bool = false) {
        collectionView?.isScrollEnabled = true

        UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
            self.emptyStateView?.alpha = 0.0
        }, completion: { done in
            self.emptyStateView?.removeFromSuperview()
            self.emptyStateView = nil
        })
    }

    func parsePackItemData(_ items: [MediaItem]?, indexPath: IndexPath, collectionView: UICollectionView, animated: Bool = false) -> BrowseMediaItemCollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrowseMediaItemCollectionViewCellReuseIdentifier, for: indexPath) as? BrowseMediaItemCollectionViewCell else {
            return BrowseMediaItemCollectionViewCell()
        }
        
        if (indexPath as NSIndexPath).row >= items?.count {
            return cell
        }

        guard let result = items?[(indexPath as NSIndexPath).row], pack = result as? PackMediaItem else {
            return cell
        }
        
        if let imageURL = pack.smallImageURL {
            cell.imageView.nk_setImageWith(imageURL)
        }
        
        cell.style = .mainApp
        cell.titleLabel.text = pack.name
        cell.itemCount = pack.items_count
        cell.addedBadgeView.isHidden = !PacksService.defaultInstance.checkPack(pack)
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main().scale

        return cell
        
    }
    
    func parseMediaItemData(_ items: [MediaItem]?, indexPath: IndexPath, collectionView: UICollectionView) -> MediaItemCollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaItemCollectionViewCellReuseIdentifier, for: indexPath) as? MediaItemCollectionViewCell else {
            return MediaItemCollectionViewCell()
        }

        if (indexPath as NSIndexPath).row >= items?.count {
            return cell
        }
        
        guard let result = items?[(indexPath as NSIndexPath).row] else {
            return cell
        }
        
        cell.reset()
        
        switch result.type {
        case .Track:
            let track = (result as! TrackMediaItem)
            cell.mainTextLabel.text = track.name
            cell.rightMetadataLabel.text = track.formattedCreatedDate

            if let imageURL = track.squareImageURL {
                cell.contentImageView.nk_setImageWith(imageURL)
            }
            
        case .Video:
            let video = (result as! VideoMediaItem)
            cell.mainTextLabel.text = video.title
            cell.leftHeaderLabel.text = video.owner
            
            if let viewCount = video.viewCount {
                cell.leftMetadataLabel.text = "\(Double(viewCount).suffixNumber) views"
            }
            
            if let likeCount = video.likeCount {
                cell.centerMetadataLabel.text = "\(Double(likeCount).suffixNumber) likes"
            }
        case .Lyric:
            let lyric = (result as! LyricMediaItem)
            cell.leftHeaderLabel.text = lyric.artist_name
            cell.rightHeaderLabel.text = lyric.track_title
            cell.mainTextLabel.text = lyric.text
            cell.mainTextLabel.textAlignment = .center
            cell.showImageView = false
            cell.avatarImageURL =  lyric.smallImageURL
        case .Quote:
            let quote = (result as! QuoteMediaItem)
            cell.leftHeaderLabel.text = quote.owner_name
            cell.rightHeaderLabel.text = quote.origin_name
            cell.mainTextLabel.text = quote.text
            cell.mainTextLabel.textAlignment = .center
            cell.showImageView = false
            cell.avatarImageURL =  quote.smallImageURL
        default:
            break
        }


        cell.bottomSeperator.isHidden = false
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main().scale
        cell.mediaLink = result
        cell.contentImageView.image = nil
        cell.delegate = self

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MediaItemCollectionViewCell else {
                return
        }

    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MediaItemCollectionViewCell,
            let result = cell.mediaLink  else {
                return
        }

        let vc = MediaItemDetailViewController(mediaItem: result, textProcessor: textProcessor)
        #if !(KEYBOARD)
            vc.mediaItemDetailView.style = .copy
        #endif
        vc.insertText()

        presentViewControllerWithCustomTransitionAnimator(vc)
    }

    func animateCell(_ cell: UICollectionViewCell, indexPath: IndexPath) {
        if cellsAnimated[indexPath] != true {
            cell.alpha = 0.0

            let finalFrame = cell.frame
            cell.frame = CGRect(x: finalFrame.origin.x, y: finalFrame.origin.y + 1000.0, width: finalFrame.size.width, height: finalFrame.size.height)

            UIView.animate(withDuration: 0.3, delay: 0.02 * Double((indexPath as NSIndexPath).row), usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                cell.alpha = 1.0
                cell.frame = finalFrame
            }, completion: nil)
        }

        cellsAnimated[indexPath] = true
    }
    
    // MediaItemCollectionViewCellDelegate
    func mediaLinkCollectionViewCellDidToggleFavoriteButton(_ cell: BaseMediaItemCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }
        
        favoriteSelected = true
        cell.overlayVisible = false
    }
    
    func mediaLinkCollectionViewCellDidToggleCancelButton(_ cell: BaseMediaItemCollectionViewCell, selected: Bool) {
        cell.overlayVisible = false
    }
    
    func mediaLinkCollectionViewCellDidToggleInsertButton(_ cell: BaseMediaItemCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }

        if selected {
            NotificationCenter.default().post(name: Foundation.Notification.Name(rawValue: "mediaItemInserted"), object: cell.mediaLink)
            self.textProcessor?.insertText(result.getInsertableText())

            Analytics.shared().track(AnalyticsProperties(eventName: AnalyticsEvent.insertedLyric), additionalProperties: AnalyticsAdditonalProperties.mediaItem(result.toDictionary()))

        } else {
            NotificationCenter.default().post(name: Foundation.Notification.Name(rawValue: "mediaItemRemoved"), object: cell.mediaLink)
            for _ in 0..<result.getInsertableText().utf16.count {
                textProcessor?.deleteBackward()
            }

            Analytics.shared().track(AnalyticsProperties(eventName: AnalyticsEvent.removedLyric), additionalProperties: AnalyticsAdditonalProperties.mediaItem(result.toDictionary()))
        }
    }
    
    func mediaLinkCollectionViewCellDidToggleCopyButton(_ cell: BaseMediaItemCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }
        
        if selected {
            NotificationCenter.default().post(name: Foundation.Notification.Name(rawValue: "mediaItemInserted"), object: cell.mediaLink)
            if let gifCell = cell as? GifCollectionViewCell, let url = result.mediumImageURL {
                // Copy this data to pasteboard
                Nuke.taskWith(url) {
                    if let image = $0.image as? AnimatedImage, let data = image.data {
                        UIPasteboard.general().setData(data, forPasteboardType: "com.compuserve.gif")
                        gifCell.showDoneMessage()
                    }
                }.resume()
                
            } else {
                UIPasteboard.general().string = result.getInsertableText()
            }

            Analytics.shared().track(AnalyticsProperties(eventName: AnalyticsEvent.insertedLyric), additionalProperties: AnalyticsAdditonalProperties.mediaItem(result.toDictionary()))

        #if !(KEYBOARD)
            if let gifCell = cell as? GifCollectionViewCell, let url = result.mediumImageURL {
                Nuke.taskWith(url) {
                    if let image = $0.image as? AnimatedImage, let data = image.data {
                        UIPasteboard.general().setData(data, forPasteboardType: "com.compuserve.gif")
                        let shareObjects = [data]
                        
                        let activityVC = UIActivityViewController(activityItems: shareObjects, applicationActivities: nil)
                        activityVC.excludedActivityTypes = [UIActivityTypeAddToReadingList]
                        
                        activityVC.popoverPresentationController?.sourceView = self.view
                        self.present(activityVC, animated: true, completion: nil)
                    }
                    }.resume()
                
            } else {
                UIPasteboard.general().string = result.getInsertableText()
            }
            
        #endif
        }
    }

    func presentViewControllerWithCustomTransitionAnimator(_ presentingController: UIViewController, direction: FadeInTransitionDirection = .none, duration: TimeInterval = 0.15) {
        transitionAnimator = FadeInTransitionAnimator(presenting: true, direction: direction, duration: duration)
        presentingController.transitioningDelegate = self
        presentingController.modalPresentationStyle = .custom
        present(presentingController, animated: true, completion: nil)
    }

    func animationController(forPresentedController presented: UIViewController, presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let animator = transitionAnimator {
            return animator
        } else {
            return FadeInTransitionAnimator(presenting: true)
        }
    }

    func animationController(forDismissedController dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = FadeInTransitionAnimator(presenting: false)

        return animator
    }

}
