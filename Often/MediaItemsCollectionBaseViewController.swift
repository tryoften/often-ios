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
import EmitterKit

let MediaItemCollectionViewCellReuseIdentifier = "MediaItemsCollectionViewCell"

class MediaItemsCollectionBaseViewController: FullScreenCollectionViewController, MediaItemsCollectionViewCellDelegate {

    var favoritesCollectionListener: Listener? = nil
    var favoriteSelected: Bool = false
    var textProcessor: TextProcessingManager?
    var emptyStateView: EmptyStateView?
    var loaderView: AnimatedLoaderView?
    var isDataLoaded: Bool {
        return false
    }

    internal var cellsAnimated: [NSIndexPath: Bool]
    internal var loaderTimeoutTimer: NSTimer?

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        cellsAnimated = [:]

        super.init(collectionViewLayout: layout)
        collectionView?.registerClass(MediaItemCollectionViewCell.self, forCellWithReuseIdentifier: MediaItemCollectionViewCellReuseIdentifier)

        favoritesCollectionListener = FavoritesService.defaultInstance.didChangeFavorites.on { items in

            if self.favoriteSelected {
                self.favoriteSelected = false
                return
            }

            self.collectionView?.reloadData()
        }
    }

    deinit {
        favoritesCollectionListener = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emptyStateView?.frame = view.bounds
        loaderView?.frame = view.bounds
    }

    func requestData(animated: Bool = false) {
        delay(0.5) {
            self.showLoaderIfNeeded()
        }
    }

    func showLoaderIfNeeded() {
        if !isDataLoaded {
            showLoadingView()
        } else {
            collectionView?.hidden = false
        }
    }

    func showLoadingView() {
        if let loaderView = loaderView {
            loaderView.removeFromSuperview()
        }
        loaderView = AnimatedLoaderView(frame: view.bounds)
        view.addSubview(loaderView!)

        loaderTimeoutTimer = NSTimer.scheduledTimerWithTimeInterval(5.0,
            target: self,
            selector: "timeoutLoader",
            userInfo: nil,
            repeats: false)
    }

    func hideLoadingView() {
        guard let loaderView = loaderView else {
            return
        }

        UIView.animateWithDuration(0.3, delay: 1.0, options: [], animations: {
            loaderView.alpha = 0.0
        }, completion: { done in
            loaderView.hidden = true
            loaderView.removeFromSuperview()
            self.loaderView = nil
        })

        loaderTimeoutTimer?.invalidate()
    }

    func timeoutLoader() {
        hideLoadingView()
        hideEmptyStateView()
    }

    func showEmptyStateViewForState(state: UserState, animated: Bool = false, completion: ((EmptyStateView) -> Void)? = nil) {
        emptyStateView?.removeFromSuperview()

        guard state != .NonEmpty else {
            return
        }

        emptyStateView = EmptyStateView.emptyStateViewForUserState(state)
        emptyStateView?.closeButton.addTarget(self, action: "didTapEmptyStateViewCloseButton", forControlEvents: .TouchUpInside)

        if let emptyStateView = emptyStateView {
            emptyStateView.alpha = 0.0
            view.addSubview(emptyStateView)

            UIView.animateWithDuration(animated ? 0.3 : 0.0) {
                emptyStateView.alpha = 1.0
            }

            viewDidLayoutSubviews()
            completion?(emptyStateView)
        }
    }

    func didTapEmptyStateViewCloseButton() {
        UIView.animateWithDuration(0.4) {
            self.emptyStateView?.alpha = 0
        }

        emptyStateView?.removeFromSuperview()
        viewDidLoad()
    }

    func hideEmptyStateView(animated: Bool = false) {
        UIView.animateWithDuration(animated ? 0.3 : 0.0, animations: {
            self.emptyStateView?.alpha = 0.0
        }, completion: { done in
            self.emptyStateView?.removeFromSuperview()
            self.emptyStateView = nil
        })
    }

    func parseMediaItemData(searchResultsData: [MediaItem]?, indexPath: NSIndexPath, collectionView: UICollectionView) -> MediaItemCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MediaItemCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as? MediaItemCollectionViewCell else {
            return MediaItemCollectionViewCell()
        }

        if indexPath.row >= searchResultsData?.count {
            return cell
        }
        
        guard let result = searchResultsData?[indexPath.row] else {
            return cell
        }
        
        cell.reset()
        
        switch(result.type) {
        case .Article:
            let article = (result as! ArticleMediaItem)
            cell.mainTextLabel.text = article.title
            cell.leftMetadataLabel.text = article.author
            cell.leftHeaderLabel.text = article.sourceName
            cell.rightMetadataLabel.text = article.date?.timeAgoSinceNow()
            cell.centerMetadataLabel.text = nil
        case .Track:
            let track = (result as! TrackMediaItem)
            cell.mainTextLabel.text = track.name
            cell.rightMetadataLabel.text = track.formattedCreatedDate
            
            switch(result.source) {
            case .Spotify:
                cell.leftHeaderLabel.text = "Spotify"
                cell.mainTextLabel.text = "\(track.name)"
                cell.leftMetadataLabel.text = track.artist_name
                cell.rightMetadataLabel.text = track.album_name
            case .Soundcloud:
                cell.leftHeaderLabel.text = track.artist_name
                cell.leftMetadataLabel.text = track.formattedPlays()
            default:
                break
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
            
            cell.rightMetadataLabel.text = video.date?.timeAgoSinceNow()
        case .Lyric:
            let lyric = (result as! LyricMediaItem)
            cell.leftHeaderLabel.text = lyric.artist_name
            cell.rightHeaderLabel.text = lyric.track_title
            cell.mainTextLabel.text = lyric.text
            cell.leftMetadataLabel.text = lyric.created?.timeAgoSinceNow()
            cell.mainTextLabel.textAlignment = .Center
            cell.showImageView = false
            cell.avatarImage = UIImage(named: "placeholder")
        default:
            break
        }
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        cell.mediaLink = result
        cell.contentImageView.image = nil
        if  let image = result.smallImage,
            let imageURL = NSURL(string: image) {
                print("Loading image: \(imageURL)")
                cell.contentImageView.setImageWithURLRequest(NSURLRequest(URL: imageURL), placeholderImage: nil, success: { (req, res, image) in
                    if result.type == .Lyric {
                        cell.avatarImage = image
                    } else {
                        cell.contentImageView.image = image
                    }

                    }, failure: { (req, res, error) in
                        print("Failed to load image: \(imageURL)")
                })
        }
        
        cell.delegate = self
        cell.itemFavorited = FavoritesService.defaultInstance.checkFavorite(result)
        
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MediaItemCollectionViewCell else {
                return
        }

        cell.overlayVisible = false
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MediaItemCollectionViewCell,
            let result = cell.mediaLink else {
                return
        }

        cell.prepareOverlayView()
        cell.itemFavorited = FavoritesService.defaultInstance.checkFavorite(result)
        cell.overlayVisible = true
    }

    func animateCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {
        if cellsAnimated[indexPath] != true {
            cell.alpha = 0.0

            let finalFrame = cell.frame
            cell.frame = CGRectMake(finalFrame.origin.x, finalFrame.origin.y + 1000.0, finalFrame.size.width, finalFrame.size.height)

            UIView.animateWithDuration(0.3, delay: 0.03 * Double(indexPath.row), usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                cell.alpha = 1.0
                cell.frame = finalFrame
            }, completion: nil)
        }

        cellsAnimated[indexPath] = true
    }
    
    // MediaItemCollectionViewCellDelegate
    func mediaLinkCollectionViewCellDidToggleFavoriteButton(cell: MediaItemCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }

        favoriteSelected = true
        FavoritesService.defaultInstance.toggleFavorite(selected, result: result)
    }
    
    func mediaLinkCollectionViewCellDidToggleCancelButton(cell: MediaItemCollectionViewCell, selected: Bool) {
        cell.overlayVisible = false
        
    }
    
    func mediaLinkCollectionViewCellDidToggleInsertButton(cell: MediaItemCollectionViewCell, selected: Bool) {
        NSNotificationCenter.defaultCenter().postNotificationName("mediaItemInserted", object: cell.mediaLink)

        guard let result = cell.mediaLink else {
            return
        }

        if selected {
            self.textProcessor?.defaultProxy.insertText(result.getInsertableText())
        } else {
            for var i = 0, len = result.getInsertableText().utf16.count; i < len; i++ {
                textProcessor?.defaultProxy.deleteBackward()
            }
        }
    }
    
    func mediaLinkCollectionViewCellDidToggleCopyButton(cell: MediaItemCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }
        
        if selected {
            UIPasteboard.generalPasteboard().string = result.getInsertableText()

        #if !(KEYBOARD)
            DropDownErrorMessage().setMessage("Copied link!".uppercaseString,
                subtitle: cell.mainTextLabel.text!, duration: 2.0, errorBackgroundColor: UIColor(fromHexString: "#152036"))
        #endif
        }
    }

}