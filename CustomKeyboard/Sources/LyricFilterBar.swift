//
//  LyricFilterBar.swift
//  Drizzy
//
//  Created by Luc Success on 1/6/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

let LyricFilterBarHeight: CGFloat = 50.0

class LyricFilterBar: UIView {
    
    var tableView: UITableView
    var searchBar: UISearchBar!
    var pulledDown: Bool
    var pullingDown: Bool
    
    init(tableView: UITableView, targetViewController: UIViewController) {
        self.tableView = tableView
        self.pulledDown = false
        self.pullingDown = false

        var tableFrame = tableView.frame
        super.init(frame: CGRectMake(CGRectGetMinX(tableFrame), -LyricFilterBarHeight, CGRectGetWidth(tableFrame), LyricFilterBarHeight))
        
        backgroundColor = UIColor.blackColor()
        tableView.addSubview(self)
        tableView.addObserver(self, forKeyPath: "contentOffset", options: .New | .Initial, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        scrollViewDidScroll(tableView)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var ratio: CGFloat = -(scrollView.contentInset.top + scrollView.contentOffset.y) / self.frame.size.height
        println("ratio: \(ratio)")
        
        var pulldownDeactivationThresholdInFilterBarHeights: CGFloat = 3
        
        if pulledDown && ratio < -pulldownDeactivationThresholdInFilterBarHeights && scrollView.decelerating {
            pulledDown = false
            pullingDown = false
            tableView.tableHeaderView = nil
            var frame = self.frame
            frame.origin.y = frame.origin.y - self.frame.size.height
            self.frame = frame
            tableView.addSubview(self)
            return
        }
        
        if ratio < -1 {
            // If the bar is out of sight, no point in doing more work
            return
        }
        
        // If the view is decelerating (i.e. we released the touch), the filter bar is still entirely
        // visible and we had previously pulled enough to activate it (i.e. pullingDown == YES) then
        // activate the filter bar (by attaching it as the tableHeaderView.
        if !pulledDown && ratio < 1 && pullingDown && scrollView.decelerating {
            tableView.tableHeaderView = self
            pulledDown = true
            pullingDown = false
        }
        
        if pulledDown {
            return
        }
        
        var pulldownActivationThresholdInFilterBarHeights: CGFloat = 1.5
        var minScale: CGFloat = 0.8
        var maxScale: CGFloat = 1.0
        var minAlpha: CGFloat = 0.1
        var maxAlpha: CGFloat = 1
        var snapAnimationDuration = 0.05
        
        var shouldSnapNow = false
        if ratio > pulldownActivationThresholdInFilterBarHeights && !scrollView.decelerating {
            shouldSnapNow = !pullingDown
            pullingDown = true
        }
        
        if ratio < 0 {
            ratio = 0
        }
        
        var normalizedRatio: CGFloat = (ratio / pulldownActivationThresholdInFilterBarHeights)
        
        var scale: CGFloat = pullingDown ? 1 : normalizedRatio * (maxScale - minScale) + minScale
        var alpha: CGFloat = pullingDown ? 1 : normalizedRatio * (maxAlpha - minAlpha) + minAlpha
        
        if shouldSnapNow {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(snapAnimationDuration)
        }
        
        self.alpha = alpha
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale)
        
        if shouldSnapNow {
            UIView.commitAnimations()
        }
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        self.init(tableView: UITableView(), targetViewController: UIViewController())
    }

}
