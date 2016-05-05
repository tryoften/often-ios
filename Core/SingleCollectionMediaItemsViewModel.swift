//
//  SingleMediaItemViewModel.swift
//  Often
//
//  Created by Luc Succes on 1/17/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class SingleMediaItemViewModel: BaseViewModel {
    var delegate: SingleMediaItemViewModelDelegate?
    var mediaItem: MediaItem?

    init(itemType: MediaType, id: String) {
        super.init(path: "\(itemType.rawValue)s/\(id)")
    }

    override func fetchData(completion: ((Bool) -> Void)? = nil) {
        ref.observeEventType(.Value, withBlock: { snapshot in
            if let data = snapshot.value as? NSDictionary {
                self.mediaItem = MediaItem.mediaItemFromType(data)
                self.delegate?.singleMediaItemViewModelDidLoadMediaItem(self, mediaItem: self.mediaItem!)
            }
        })
    }
}


protocol SingleMediaItemViewModelDelegate: class {
    func singleMediaItemViewModelDidLoadMediaItem(viewModel: SingleMediaItemViewModel, mediaItem: MediaItem)
}