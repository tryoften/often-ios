//
//  CellAnimatable.swift
//  Often
//
//  Created by Luc Succes on 1/8/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

protocol CellAnimatable {
    func animateCell(cell: UICollectionViewCell, indexPath: NSIndexPath)
}

extension CellAnimatable where Self: UICollectionViewController {
    func animateCell(cell: UICollectionViewCell, indexPath: NSIndexPath) {
        cell.alpha = 0.0

        let finalFrame = cell.frame
        cell.frame = CGRectMake(finalFrame.origin.x, finalFrame.origin.y + 1000.0, finalFrame.size.width, finalFrame.size.height)

        UIView.animateWithDuration(0.3, delay: 0.03 * Double(indexPath.row), usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            cell.alpha = 1.0
            cell.frame = finalFrame
            }, completion: nil)
    }
}