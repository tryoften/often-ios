//
//  MediaItemGroupViewModel.swift
//  Often
//
//  Created by Luc Succes on 1/7/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class MediaItemGroupViewModel: BaseViewModel {
    weak var delegate: MediaItemGroupViewModelDelegate?
    var mediaItemGroups: [MediaItemGroup]

    override init(baseRef: Firebase = Firebase(url: BaseURL), path: String?) {
        mediaItemGroups = []
        
        super.init(baseRef: baseRef, path: path)
    }

    override func fetchData() throws {
        ref.observeEventType(.Value, withBlock: { snapshot in
            if let data = snapshot.value as? NSArray {
                self.mediaItemGroups = MediaItemGroup.modelsFromDictionaryArray(data)
                self.delegate?.mediaItemGroupViewModelDataDidLoad(self, groups: self.mediaItemGroups)
            }
        })
    }

    func groupAtIndex(index: Int) -> MediaItemGroup? {
        if index < mediaItemGroups.count {
            return mediaItemGroups[index]
        }
        return nil
    }

}

protocol MediaItemGroupViewModelDelegate: class {
    func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup])
}