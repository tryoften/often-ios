//
//  LyricFilterBar.swift
//  Drizzy
//
//  Created by Luc Success on 1/6/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

let LyricFilterBarHeight: CGFloat = 50.0

class LyricFilterBar: UIView, UISearchBarDelegate {
    
    var targetViewController: KeyboardViewController
    var tableView: UITableView
    var searchBarContainer: UIView
    var searchBar: UISearchBar
    var pulledDown: Bool
    var pullingDown: Bool
    var delegate: LyricFilterBarDelegate?
    
    init(aTableView: UITableView, aTargetViewController: KeyboardViewController) {
        tableView = aTableView
        targetViewController = aTargetViewController
        pulledDown = false
        pullingDown = false

        var tableFrame = tableView.frame
        var barFrame = CGRectMake(CGRectGetMinX(tableFrame), -LyricFilterBarHeight, CGRectGetWidth(tableFrame), LyricFilterBarHeight)
        
        searchBarContainer = UIView(frame: CGRectMake(0, 0, barFrame.width, barFrame.height))
        searchBarContainer.autoresizingMask = .FlexibleLeftMargin | .FlexibleTopMargin | .FlexibleWidth | .FlexibleHeight
        
        searchBar = UISearchBar(frame: CGRectZero)
        searchBar.setTranslatesAutoresizingMaskIntoConstraints(false)
        searchBar.backgroundColor = UIColor.clearColor()
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Filter lyrics"
        searchBar.barTintColor = UIColor.clearColor()
        
        super.init(frame: barFrame)
        
        searchBar.delegate = self
        self.addSubview(searchBarContainer)
        searchBarContainer.addSubview(searchBar)

        tableView.addSubview(self)
        tableView.addObserver(self, forKeyPath: "contentOffset", options: .New | .Initial, context: nil)
        
        setupLayout()
        searchBarContainer.layoutIfNeeded()
        searchBarContainer.updateConstraints()
        
        for subview in searchBar.subviews {
            if subview.isKindOfClass(UITextField.self) {
                let textField = subview as UITextField
                textField.font = UIFont(name: "Lato-Light", size: 13)!
            }
        }
        
        addSeperatorBelow(self)
    }
    
    func setupLayout() {
        searchBarContainer.addConstraints([
            searchBar.al_height == searchBarContainer.al_height,
            searchBar.al_left == searchBarContainer.al_left,
            searchBar.al_right == searchBarContainer.al_right,
            searchBar.al_top == searchBarContainer.al_top,
        ])
    }
    
//    func promotable() -> LyricFilterBarPromotable? {
//        
//        if targetViewController is LyricFilterBarPromotable {
//            return targetViewController as? LyricFilterBarPromotable
//        }
//        
//        return nil
//    }
    
    override func layoutSubviews() {
        searchBar.frame = CGRectMake(0, 0, CGRectGetWidth(searchBarContainer.frame), CGRectGetHeight(searchBarContainer.frame))
    }
    
    func didTapCancelButton() {
        removeSearchBarFromTableHeaderView()
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        scrollViewDidScroll(tableView)
    }
    
    func addSearchBarFromTableHeaderView() {
        tableView.tableHeaderView = self
        pulledDown = true
        pullingDown = false
        delegate?.lyricFilterBarStateDidChange(self, hidden: false)
    }
    
    func removeSearchBarFromTableHeaderView() {
        pulledDown = false
        pullingDown = false
        tableView.tableHeaderView = nil
        var frame = self.frame
        frame.origin.y = frame.origin.y - self.frame.size.height
        self.frame = frame
        tableView.addSubview(self)
        searchBar.endEditing(true)
        delegate?.lyricFilterBarStateDidChange(self, hidden: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var ratio: CGFloat = -(scrollView.contentInset.top + scrollView.contentOffset.y) / self.frame.size.height
        
        var pulldownDeactivationThresholdInFilterBarHeights: CGFloat = 5
        
        if pulledDown && ratio < -pulldownDeactivationThresholdInFilterBarHeights && scrollView.decelerating {
            removeSearchBarFromTableHeaderView()
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
            addSearchBarFromTableHeaderView()
        }
        
        if pulledDown {
            return
        }
        
        var pulldownActivationThresholdInFilterBarHeights: CGFloat = 0.9
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
        self.init(aTableView: UITableView(), aTargetViewController: KeyboardViewController())
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.lyricFilterBarTextDidChange(self, searchText: searchText)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        delegate?.lyricFilterBarShouldShowKeyboard(self, showKeyboard: true)
        targetViewController.promote(true, animated: true)
        searchBar.becomeFirstResponder()
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        delegate?.lyricFilterBarShouldShowKeyboard(self, showKeyboard: false)
        targetViewController.promote(false, animated: true)
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        removeSearchBarFromTableHeaderView()
        searchBarTextDidEndEditing(searchBar)
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        searchBarContainer.endEditing(true)
        searchBar.text = ""
    }
}

protocol LyricFilterBarDelegate {
    /*
        Invoked when the state of the lyric filter bar changes
        @param lyricFilterBar the filter bar in question
        @param hidden Whether the bar is hidden or not
    */
    func lyricFilterBarStateDidChange(lyricFilterBar: LyricFilterBar, hidden: Bool)
    func lyricFilterBarTextDidChange(lyricFilterBar: LyricFilterBar, searchText: String)
    func lyricFilterBarShouldShowKeyboard(lyricFilterBar: LyricFilterBar, showKeyboard: Bool)
}

@objc protocol LyricFilterBarPromotable {
    func promote(shouldPromote: Bool, animated: Bool)
}
