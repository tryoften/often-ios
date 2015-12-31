//
//  MainAppSearchBar.swift
//  Often
//
//  Created by Kervins Valcourt on 12/28/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class MainAppSearchBar: UISearchBar, SearchBar {
    var selected: Bool

    required override init(frame: CGRect) {
        selected = false
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setFilterButton(filter: Filter) {

    }

    func reset() {
        
    }

    func clear() {

    }

}