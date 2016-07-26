//
//  AssignCategoryViewModel.swift
//  Often
//
//  Created by Kervins Valcourt on 7/21/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Firebase

class AssignCategoryViewModel: BaseViewModel {
    weak var delegate: AssignCategoryViewModelDelegate?
    var categories: [Category]
    var mediaItem: MediaItem

     init(mediaItem: MediaItem) {
        self.mediaItem = mediaItem
        categories = []
        super.init(baseRef: FIRDatabase.database().reference(), path: "categories")
    }

    override func fetchData(completion: ((Bool) -> Void)?) {
        categories = []
        ref.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            if let data = snapshot.value as? NSDictionary {
                self.categories = Category.modelsFromDictionary(data)
                self.delegate?.assignCategoryViewModelDelegateDataDidLoad(self, categories: self.categories)
                completion?(true)
            }
        })
    }

    func updateMediaItemCategory(index: Int) {
        if categories.count < index {
            mediaItem.category = categories[index]
        }
    }

    func submitNewMediaItem() {
        UserPackService.defaultInstance.addItem(mediaItem)
    }


}

protocol AssignCategoryViewModelDelegate: class {
    func assignCategoryViewModelDelegateDataDidLoad(viewModel: AssignCategoryViewModel, categories: [Category]?)
}