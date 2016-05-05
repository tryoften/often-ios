//
//  BaseMediaItemCollectionViewCell.swift
//  Often
//
//  Created by Katelyn Findlay on 4/15/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation


class BaseMediaItemCollectionViewCell: UICollectionViewCell {
    weak var delegate: MediaItemsCollectionViewCellDelegate?
    weak var mediaLink: MediaItem?
    var overlayVisible: Bool
    var itemFavorited: Bool
    
    override init(frame: CGRect) {
        overlayVisible = false
        itemFavorited = false
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

protocol MediaItemsCollectionViewCellDelegate: class {
    func mediaLinkCollectionViewCellDidToggleFavoriteButton(cell: BaseMediaItemCollectionViewCell, selected: Bool)
    func mediaLinkCollectionViewCellDidToggleCancelButton(cell: BaseMediaItemCollectionViewCell, selected: Bool)
    func mediaLinkCollectionViewCellDidToggleCopyButton(cell: BaseMediaItemCollectionViewCell, selected: Bool)
    func mediaLinkCollectionViewCellDidToggleInsertButton(cell: BaseMediaItemCollectionViewCell, selected: Bool)
}