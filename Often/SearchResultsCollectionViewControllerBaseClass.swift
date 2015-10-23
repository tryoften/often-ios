//
//  SearchResultsCollectionViewControllerBaseClass.swift
//  Often
//
//  Created by Kervins Valcourt on 10/23/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class SearchResultsCollectionViewControllerBaseClass: UICollectionViewController {
   var cellsAnimated: [NSIndexPath: Bool]
   
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        cellsAnimated = [:]

        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func parseSearchResultsData(searchResultsData:[SearchResult]?, indexPath:NSIndexPath, collectionView: UICollectionView) -> SearchResultsCollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("serviceCell", forIndexPath: indexPath) as! SearchResultsCollectionViewCell
        
        
        if indexPath.row >= searchResultsData?.count {
            return cell
        }
        
        guard let result = searchResultsData?[indexPath.row] else {
            return cell
        }
        
        cell.reset()
        
        switch(result.type) {
        case .Article:
            let article = (result as! ArticleSearchResult)
            cell.mainTextLabel.text = article.title
            cell.leftSupplementLabel.text = article.author
            cell.headerLabel.text = article.sourceName
            cell.rightSupplementLabel.text = article.date?.timeAgoSinceNow()
            cell.centerSupplementLabel.text = nil
        case .Track:
            let track = (result as! TrackSearchResult)
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
            let video = (result as! VideoSearchResult)
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
        cell.searchResult = result
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
    
    func animateCell(cell:SearchResultsCollectionViewCell, indexPath:NSIndexPath) {
        
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

}