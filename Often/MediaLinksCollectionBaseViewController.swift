//
//  SearchResultsCollectionViewBaseController.swift
//  Often
//
//  Created by Kervins Valcourt on 10/23/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

let MediaLinkCollectionViewCellReuseIdentifier = "MediaLinksCollectionViewCell"

class MediaLinksCollectionBaseViewController: UICollectionViewController, MediaLinksCollectionViewCellDelegate {
   var cellsAnimated: [NSIndexPath: Bool]
   
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        cellsAnimated = [:]

        super.init(collectionViewLayout: layout)
        
        collectionView?.registerClass(MediaLinkCollectionViewCell.self, forCellWithReuseIdentifier: MediaLinkCollectionViewCellReuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func parseMediaLinkData(searchResultsData: [MediaLink]?, indexPath: NSIndexPath, collectionView: UICollectionView) -> MediaLinkCollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MediaLinkCollectionViewCellReuseIdentifier, forIndexPath: indexPath) as! MediaLinkCollectionViewCell

        if indexPath.row >= searchResultsData?.count {
            return cell
        }
        
        guard let result = searchResultsData?[indexPath.row] else {
            return cell
        }
        
        cell.reset()
        
        switch(result.type) {
        case .Article:
            let article = (result as! ArticleMediaLink)
            cell.mainTextLabel.text = article.title
            cell.leftSupplementLabel.text = article.author
            cell.headerLabel.text = article.sourceName
            cell.rightSupplementLabel.text = article.date?.timeAgoSinceNow()
            cell.centerSupplementLabel.text = nil
        case .Track:
            let track = (result as! TrackMediaLink)
            cell.mainTextLabel.text = track.name
            cell.rightSupplementLabel.text = track.formattedCreatedDate
            
            switch(result.source) {
            case .Spotify:
                cell.headerLabel.text = "Spotify"
                cell.mainTextLabel.text = "\(track.name)"
                cell.leftSupplementLabel.text = track.artistName
                cell.rightSupplementLabel.text = track.albumName
            case .Soundcloud:
                cell.headerLabel.text = track.artistName
                cell.leftSupplementLabel.text = track.formattedPlays()
            default:
                break
            }
        case .Video:
            let video = (result as! VideoMediaLink)
            cell.mainTextLabel.text = video.title
            cell.headerLabel.text = video.owner
            
            if let viewCount = video.viewCount {
                cell.leftSupplementLabel.text = "\(Double(viewCount).suffixNumber) views"
            }
            
            if let likeCount = video.likeCount {
                cell.centerSupplementLabel.text = "\(Double(likeCount).suffixNumber) likes"
            }
            
            cell.rightSupplementLabel.text = video.date?.timeAgoSinceNow()
            
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
        
        
        
        return cell
    }
    
    func animateCell(cell:MediaLinkCollectionViewCell, indexPath:NSIndexPath) {
        
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
    
    // MediaLinkCollectionViewCellDelegate
    func mediaLinkCollectionViewCellDidToggleFavoriteButton(cell: MediaLinkCollectionViewCell, selected: Bool) {
        
    }
    
    func mediaLinkCollectionViewCellDidToggleCancelButton(cell: MediaLinkCollectionViewCell, selected: Bool) {
        cell.overlayVisible = false
    }
    
    func mediaLinkCollectionViewCellDidToggleInsertButton(cell: MediaLinkCollectionViewCell, selected: Bool) {
        
    }
    
    
    func mediaLinkCollectionViewCellDidToggleCopyButton(cell: MediaLinkCollectionViewCell, selected: Bool) {
        guard let result = cell.mediaLink else {
            return
        }
        
        if selected {
            UIPasteboard.generalPasteboard().string = result.getInsertableText()
        }
    }

}