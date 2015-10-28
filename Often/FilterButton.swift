//
//  FilterButton.swift
//  Often
//
//  Created by Kervins Valcourt on 10/28/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class FilterButton: UIButton {
    var filterType: [MediaType] = DefaultFilterMode
    weak var delegate: FilterMapProtocol?
    override var selected: Bool { didSet { if selected { delegate?.currentFilterSet(filterType)} } }
}