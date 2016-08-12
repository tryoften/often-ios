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
    var selectedCategory: Category?

     init(mediaItem: MediaItem) {
        self.mediaItem = mediaItem
        categories = []
        super.init(baseRef: FIRDatabase.database().reference(), path: "categories")
    }

    override func fetchData(completion: ((Bool) -> Void)?) {
        categories = []
        ref.observeEventType(.Value, withBlock: { snapshot in
            if let data = snapshot.value as? NSDictionary {
                let unsortedCategries = Category.modelsFromDictionary(data)
                self.categories = unsortedCategries.sort{$0.name < $1.name}
                self.delegate?.assignCategoryViewModelDelegateDataDidLoad(self, categories: self.categories)
                completion?(true)
            }
        })
    }

    func updateMediaItemCategory(index: Int) {
        if index < categories.count {
            selectedCategory = categories[index]
            mediaItem.category = categories[index]
        }
    }

    func submitNewMediaItem() {
        UserPackService.defaultInstance.addItem(mediaItem)
    }

    func updateMediaItem(item: MediaItem) {
        mediaItem = item
        mediaItem.category = selectedCategory
    }
}

protocol AssignCategoryViewModelDelegate: class {
    func assignCategoryViewModelDelegateDataDidLoad(viewModel: AssignCategoryViewModel, categories: [Category]?)
}