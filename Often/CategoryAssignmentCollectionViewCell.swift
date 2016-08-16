//
//  CategoryAssignmentCollectionViewCell.swift
//  Often
//
//  Created by Kervins Valcourt on 8/16/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class CategoryAssignmentCollectionViewCell: CategoryCollectionViewCell {
    override var selected: Bool {
        didSet {
            if selected {
                searchOverlayView.hidden = false
            } else {
                searchOverlayView.hidden = true
            }
        }
    }
}