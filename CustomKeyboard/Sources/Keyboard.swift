//
//  Keyboard.swift
//  Drizzy
//
//  Created by Luc Success on 4/23/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class Keyboard: NSObject {
    var id: String = ""
    var index: Int = -1
    var artist: Artist?
    var currentCategoryId: String?
    
    var categories: [String: Category] = [String: Category]() {
        didSet {
            var array = [Category]()
            
            var sortedCategories = (categories as NSDictionary
                ).keysSortedByValueUsingComparator({ (val1, val2) in
                let string1 = (val1 as! Category).name as String
                let string2 = (val2 as! Category).name as String
                return string1.compare(string2)
            })
            
            var i = 0
            for key in sortedCategories {
                if let category = categories[key as! String] {
                    category.highlightColor = UIColor(fromHexString: CategoryCollectionViewCellHighlightColors[i++ % CategoryCollectionViewCellHighlightColors.count])
                    array.append(category)
                }
            }

            categoryList = array
        }
    }
    var categoryList: [Category] = []
}
