//
//  LyricPickerTableViewController.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

let LyricTableViewCellIdentifier = "LyricTableViewCell"
let LyricTableViewCellHeight: CGFloat = 75

class LyricPickerTableViewController: UITableViewController, UITableViewDelegate, SectionPickerViewDelegate,
    LyricTableViewCellDelegate {
    
    var delegate: LyricPickerDelegate?
    var labelFont: UIFont?
    var currentCategory: Category?
    var selectedRows = [Int: Bool]()
    var trackService: TrackService?

    override func viewDidLoad() {
        super.viewDidLoad()
        labelFont = UIFont(name: "Lato-Light", size: 20)

        tableView.backgroundColor = UIColor(fromHexString: "#f7f7f7")
        tableView.registerClass(LyricTableViewCell.self, forCellReuseIdentifier: LyricTableViewCellIdentifier)
        tableView.separatorStyle = .None
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.showsVerticalScrollIndicator = false
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
            return category.lyrics!.count
        }
        
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LyricTableViewCellIdentifier, forIndexPath: indexPath) as LyricTableViewCell
        
        var lyric = currentCategory?.lyrics![indexPath.row]
        cell.lyric = lyric
        cell.delegate = self

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as LyricTableViewCell
        var lyric = currentCategory?.lyrics![indexPath.row]
        
        if (selectedRows.indexForKey(indexPath.row) == nil) {
            selectedRows[indexPath.row] = true
        } else {
            var selected = selectedRows[indexPath.row]!
            selectedRows[indexPath.row] = !selected
        }
        
        if lyric?.track == nil {
            var track = trackService?.trackForId(lyric!.trackId!)
            lyric?.track = track
            
            cell.shareVC!.lyric = lyric
            cell.metadataView.track = track
        }

        tableView.beginUpdates()
        tableView.endUpdates()
        
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var selected = selectedRows[indexPath.row]
        if selected == true {
            return 171
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
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollToNearestRow()
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
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.alpha = 0.0
            self.tableView.layer.transform = CATransform3DMakeScale(0.90, 0.90, 0.90)
            
            self.selectedRows = [Int: Bool]()
            self.tableView.reloadData()
            UIView.animateWithDuration(0.3, animations: {
                self.tableView.alpha = 1.0
                self.tableView.layer.transform = CATransform3DIdentity
            })
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
        })
    }

    // MARK: LyricTableViewCellDelegate
    
    func lyricTableViewCellDidSelect(cell: LyricTableViewCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            var selected = selectedRows[indexPath.row]
            
            if selected == nil || selected == false {
                delegate?.didPickLyric(self, shareVC: cell.shareVC, lyric: cell.lyric)
                var data = [NSString: AnyObject]()
                data["lyric"] = cell.lyric

                var notification = NSNotification(name: "lyric:selected", object: nil, userInfo: data)
                NSNotificationCenter.defaultCenter().postNotification(notification)
                
                
            }
        }
    }
}

protocol LyricPickerDelegate {
    func didPickLyric(lyricPicker: LyricPickerTableViewController,shareVC: ShareViewController, lyric: Lyric?)
}
