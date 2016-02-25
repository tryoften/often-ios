//
//  RecentlyAddedHorizontalViewController.swift
//  Often
//
//  Created by Katelyn Findlay on 2/23/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

private let TrendingLyricsCellReuseIdentifier = "TrendingLyricsCell"

class RecentlyAddedHorizontalCollectionViewController : TrendingLyricsHorizontalCollectionViewController {

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TrendingLyricsCellReuseIdentifier,
            forIndexPath: indexPath) as? MediaItemCollectionViewCell else {
                return UICollectionViewCell()
        }
        
        cell.reset()
        
        guard let lyric = group?.items[indexPath.row] as? LyricMediaItem else {
            return cell
        }
        
        if let url = lyric.smallImage, let imageURL = NSURL(string: url) {
            cell.avatarImageURL = imageURL
        }
        
        cell.leftHeaderLabel.text = lyric.artist_name
        cell.rightHeaderLabel.text = lyric.track_title
        cell.mainTextLabel.text = lyric.text
        cell.leftMetadataLabel.text = lyric.created?.timeAgoSinceNow()
        cell.mainTextLabel.textAlignment = .Center
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        cell.layer.shouldRasterize = true
        cell.showImageView = false
        cell.mediaLink = lyric
        cell.type = .Metadata
        cell.delegate = self
        
        #if !(KEYBOARD)
            cell.inMainApp = true
        #endif
        
        cell.itemFavorited = false
        
        return cell
        
    }
}
