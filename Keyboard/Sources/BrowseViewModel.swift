//
//  BrowseViewModel.swift
//  Often
//
//  Created by Luc Succes on 1/10/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Firebase

class BrowseViewModel: MediaItemGroupViewModel {
    let didUpdateCurrentMediaItem = Event<[MediaItemGroup]>()
    var currentCategory: Category?
    
    init(path: String = "trending") {
        super.init(baseRef: nil, path: path)
    }

    func applyFilter(_ filter: Category) {
        currentCategory = filter
        
        for group in mediaItemGroups {
            group.filterMediaItems(filter)
        }
        
        didUpdateCurrentMediaItem.emit(mediaItemGroups)
    }
    
    func getItemCount() -> Int {
        var count = 0
        for group in mediaItemGroups {
            count += group.items.count
        }
        return count
    }

}
