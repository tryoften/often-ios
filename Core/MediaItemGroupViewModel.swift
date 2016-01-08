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
    var groups: [MediaItemGroup]

    override init(baseRef: Firebase = Firebase(url: BaseURL), path: String?) {
        groups = []
        
        super.init(baseRef: baseRef, path: path)
    }

    override func fetchData() throws {
        ref.observeEventType(.Value, withBlock: { snapshot in
            if let data = snapshot.value as? NSArray {
                self.groups = MediaItemGroup.modelsFromDictionaryArray(data)
                self.delegate?.mediaItemGroupViewModelDataDidLoad(self, groups: self.groups)
            }
        })
    }

    func groupAtIndex(index: Int) -> MediaItemGroup? {
        if index < groups.count {
            return groups[index]
        }
        return nil
    }
}

protocol MediaItemGroupViewModelDelegate: class {
    func mediaItemGroupViewModelDataDidLoad(viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup])
}