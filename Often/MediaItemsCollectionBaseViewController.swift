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
    var cellsAnimated: [NSIndexPath: Bool]
    var favoritesCollectionListener: Listener? = nil

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        cellsAnimated = [:]

        super.init(collectionViewLayout: layout)
        collectionView?.registerClass(MediaItemCollectionViewCell.self, forCellWithReuseIdentifier: MediaItemCollectionViewCellReuseIdentifier)

        favoritesCollectionListener = FavoritesService.defaultInstance.didChangeFavorites.on { items in
            self.collectionView?.reloadData()
        }
    }

    deinit {
        favoritesCollectionListener = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            cell.mainTextLabel.textAlignment = .Center
            cell.showImageView = false
            
        default:
            break
        }
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        cell.mediaLink = result
        cell.overlayVisible = false
        cell.contentImageView.image = nil
        if  let image = result.image,
            let imageURL = NSURL(string: image) {
                print("Loading image: \(imageURL)")
                cell.contentImageView.setImageWithURLRequest(NSURLRequest(URL: imageURL), placeholderImage: nil, success: { (req, res, image)in
                    cell.contentImageView.image = image
                    }, failure: { (req, res, error) in
                        print("Failed to load image: \(imageURL)")
                })
        }
        
        cell.sourceLogoView.image = result.iconImageForSource()
        cell.delegate = self
        cell.itemFavorited = FavoritesService.defaultInstance.checkFavorite(result)
        
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MediaItemCollectionViewCell,
            let cells = collectionView.visibleCells() as? [MediaItemCollectionViewCell],
            let result = cell.mediaLink else {
                return
        }

        for cell in cells {
            cell.overlayVisible = false
            cell.layer.shouldRasterize = false
        }

        cell.prepareOverlayView()
        cell.overlayVisible = true
        cell.itemFavorited = FavoritesService.defaultInstance.checkFavorite(result)
    }

    func animateCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {
        if (cellsAnimated[indexPath] != true) {
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

        FavoritesService.defaultInstance.toggleFavorite(selected, result: result)
    }
    
    func mediaLinkCollectionViewCellDidToggleCancelButton(cell: MediaItemCollectionViewCell, selected: Bool) {
        cell.overlayVisible = false
    }
    
    func mediaLinkCollectionViewCellDidToggleInsertButton(cell: MediaItemCollectionViewCell, selected: Bool) {
        
    }
    
    func mediaLinkCollectionViewCellDidToggleCopyButton(cell: MediaItemCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }
        
        if selected {
            UIPasteboard.generalPasteboard().string = result.getInsertableText()
        }
    }

}