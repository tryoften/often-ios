//
//  MediaItemGroupViewModel.swift
//  Often
//
//  Created by Luc Succes on 1/7/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Firebase

class MediaItemGroupViewModel: BaseViewModel {
    weak var delegate: MediaItemGroupViewModelDelegate?
    var mediaItemGroups: [MediaItemGroup]

    override init(baseRef: FIRDatabaseReference?, path: String?) {
        mediaItemGroups = []
        
        super.init(baseRef: baseRef, path: path)
    }

    override func fetchData(_ completion: ((Bool) -> Void)? = nil) {
//        ref.observe(.value, with: { snapshot in
//            if let data = snapshot.value as? NSArray {
//                self.mediaItemGroups = MediaItemGroup.modelsFromDictionaryArray(data)
//                self.delegate?.mediaItemGroupViewModelDataDidLoad(self, groups: self.mediaItemGroups)
//                completion?(true)
//            }
//        })
    }

    func groupAtIndex(_ index: Int) -> MediaItemGroup? {
        if index < mediaItemGroups.count {
            return mediaItemGroups[index]
        }
        return nil
    }

}

protocol MediaItemGroupViewModelDelegate: class {
    func mediaItemGroupViewModelDataDidLoad(_ viewModel: MediaItemGroupViewModel, groups: [MediaItemGroup])
}
