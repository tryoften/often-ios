//
//  LyricPickerTableViewController.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class LyricPickerTableViewController: UITableViewController, UITableViewDelegate, SectionPickerViewDelegate,
    LyricTableViewCellDelegate, LyricFilterBarDelegate {
    
    var keyboardViewController: KeyboardViewController!
    var delegate: LyricPickerDelegate?
    var viewModel: LyricPickerViewModel!
    var labelFont: UIFont?
    var currentCategory: Category?
    var selectedRows = [Int: Bool]()
    var selectedRow: NSIndexPath?
    var selectedCell: LyricTableViewCell?
    var animatingCell: Bool!
    var searchModeOn :Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        labelFont = BaseFont
        animatingCell = false
        searchModeOn = false

        tableView.backgroundColor = KeyboardTableViewBackgroundColor
        tableView.registerClass(LyricTableViewCell.self, forCellReuseIdentifier: LyricTableViewCellIdentifier)
        tableView.separatorStyle = .None
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsMultipleSelection = false
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let category = currentCategory {
            return category.lyrics.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LyricTableViewCellIdentifier, forIndexPath: indexPath) as! LyricTableViewCell
        
        var lyrics = currentCategory?.lyrics
        var lyric = lyrics![indexPath.row]
        
        cell.lyric = lyric
        cell.delegate = self

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! LyricTableViewCell
        
        var lyrics = currentCategory?.lyrics
        
        selectedRow = indexPath
        selectedCell = cell
        
        if let lyric = lyrics?[indexPath.row] {
        
            if lyric.track == nil {
                
                self.viewModel.getTrackForLyric(lyric, completion: { track in
                    lyric.track = track
                    cell.shareVC!.lyric = lyric
                    cell.metadataView.track = track
                })
            }
        }
        
        animatingCell = true
        CATransaction.begin()
        
        CATransaction.setCompletionBlock({
            self.animatingCell = false
        })
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        CATransaction.commit()
        
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {

        selectedRow = nil
        selectedCell = nil
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if interfaceOrientation == .LandscapeLeft
            || interfaceOrientation == .LandscapeRight {

            if indexPath == selectedRow {
                return 120
            }
        }
        
        if indexPath == selectedRow {
            return KeyboardHeight - SectionPickerViewHeight
        }
        return LyricTableViewCellHeight
    }
    
    // MARK: UIScrollViewDelegate
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollToNearestRow()
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if selectedRow != nil && !animatingCell && !scrollView.decelerating {
            selectedRow = nil
            selectedCell = nil
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
            CATransaction.commit()
        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    }
    
    func scrollToNearestRow() {
        var point = tableView.contentOffset
        point.y = point.y + LyricTableViewCellHeight / 2
        var indexPath = tableView.indexPathForRowAtPoint(point)
        tableView.scrollToRowAtIndexPath(indexPath!, atScrollPosition: .Top, animated: true)
    }
    
    // MARK: SectionPickerViewDelegate
    
    func didSelectSection(sectionPickerView: SectionPickerView, category: Category) {
        currentCategory = category
        selectedRow = nil
        selectedCell = nil

        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.alpha = 0.0
            self.tableView.layer.transform = CATransform3DMakeScale(0.90, 0.90, 0.90)
            
            self.tableView.reloadData()
            UIView.animateWithDuration(0.3, animations: {
                self.tableView.alpha = 1.0
                self.tableView.layer.transform = CATransform3DIdentity
            })
            
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            
            if self.tableView.numberOfSections() > 0 && self.tableView.numberOfRowsInSection(0) > 0 {
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
            }
        })
    }

    // MARK: LyricTableViewCellDelegate
    
    func lyricTableViewCellDidSelect(cell: LyricTableViewCell) {
        if tableView.decelerating {
            return
        }
        
        if let indexPath = tableView.indexPathForCell(cell) {
            selectedRow = indexPath
            var selected = selectedRows[indexPath.row]
            
            if selected == nil || selected == false {
                delegate?.didPickLyric(self, shareVC: cell.shareVC, lyric: cell.lyric)
                var data = [NSString: AnyObject]()
                data["lyric"] = cell.lyric

                var notification = NSNotification(name: LyricSelectedEventIdentifier, object: nil, userInfo: data)
                NSNotificationCenter.defaultCenter().postNotification(notification)
            }
        }
    }
    
    // MARK: LyricFilterBarDelegate
    
    func lyricFilterBarShouldShowKeyboard(lyricFilterBar: LyricFilterBar, showKeyboard: Bool) {
    }
    
    func lyricFilterBarStateDidChange(lyricFilterBar: LyricFilterBar, hidden: Bool) {

        
    }
    
    func lyricFilterBarTextDidChange(lyricFilterBar: LyricFilterBar, searchText: String) {
    }
}

protocol LyricPickerDelegate {
    func didPickLyric(lyricPicker: LyricPickerTableViewController,shareVC: ShareViewController, lyric: Lyric?)
}
