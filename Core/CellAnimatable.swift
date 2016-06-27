//
//  CellAnimatable.swift
//  Often
//
//  Created by Luc Succes on 1/8/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

/**
 *  Protocol that define an event to animate UICollectionViewCell
 */

protocol CellAnimatable {
    func animateCell(_ cell: UICollectionViewCell, indexPath: IndexPath)
}

extension CellAnimatable where Self: UICollectionViewController {
    func animateCell(_ cell: UICollectionViewCell, indexPath: IndexPath) {
        cell.alpha = 0.0

        let finalFrame = cell.frame
        cell.frame = CGRect(x: finalFrame.origin.x, y: finalFrame.origin.y + 1000.0, width: finalFrame.size.width, height: finalFrame.size.height)

        UIView.animate(withDuration: 0.3, delay: 0.03 * Double((indexPath as NSIndexPath).row), usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            cell.alpha = 1.0
            cell.frame = finalFrame
            }, completion: nil)
    }
}
