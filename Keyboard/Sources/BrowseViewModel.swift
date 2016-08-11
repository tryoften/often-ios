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
    
    init(userId: String? = nil, path: String = "trending") {
        super.init(userId: userId, baseRef: FIRDatabase.database().reference(), path: path)
    }

    func applyFilter(filter: Category) {
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