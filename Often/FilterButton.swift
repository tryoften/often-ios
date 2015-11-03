//
//  FilterButton.swift
//  Often
//
//  Created by Kervins Valcourt on 10/28/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class FilterButton: UIButton {
    var filterTypes: [MediaType]
    
    init(filters: [MediaType]) {
        filterTypes = filters
        
        super.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}