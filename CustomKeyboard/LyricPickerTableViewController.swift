//
//  LyricPickerTableViewController.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

let LyricTableViewCellIdentifier = "LyricTableViewCell"

class LyricPickerTableViewController: UITableViewController, SectionPickerViewDelegate,
    LyricTableViewCellDelegate {
    
    var delegate: LyricPickerDelegate?
    var labelFont: UIFont?
    var currentCategory: Category?
    var selectedRows = [Int: Bool]()
    var trackService: TrackService?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelFont = UIFont(name: "Lato-Light", size: 20)

        self.tableView.backgroundColor = UIColor(fromHexString: "#f7f7f7")
        self.tableView.registerClass(LyricTableViewCell.self, forCellReuseIdentifier: LyricTableViewCellIdentifier)
        self.tableView.separatorStyle = .None
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        self.tableView.showsVerticalScrollIndicator = false
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
        if let category = self.currentCategory {
            return category.lyrics!.count
        }
        
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LyricTableViewCellIdentifier, forIndexPath: indexPath) as LyricTableViewCell
        
        var lyric = self.currentCategory?.lyrics![indexPath.row]
        cell.lyric = lyric
        cell.delegate = self

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as LyricTableViewCell
        
        var lyric = self.currentCategory?.lyrics![indexPath.row]
        
        if (self.selectedRows.indexForKey(indexPath.row) == nil) {
            self.selectedRows[indexPath.row] = true
        } else {
            var selected = selectedRows[indexPath.row]!
            self.selectedRows[indexPath.row] = !selected
        }
        
        if lyric?.track == nil {
            var track = self.trackService?.trackForId(lyric!.trackId!)
            lyric?.track = track
            
            cell.shareVC!.lyric = lyric
            cell.metadataView.track = track
        }

        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var selected = selectedRows[indexPath.row]
        if selected == true {
            return 180
        }
        return 80
    }
    
    // MARK: SectionPickerViewDelegate
    
    func didSelectSection(sectionPickerView: SectionPickerView, category: Category) {
        self.currentCategory = category
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }

    // MARK: LyricTableViewCellDelegate
    
    func lyricTableViewCellDidLongPress(cell: LyricTableViewCell) {
        self.delegate?.didPickLyric(self, lyric: cell.lyric)
    }
}

protocol LyricPickerDelegate {
    func didPickLyric(lyricPicker: LyricPickerTableViewController, lyric: Lyric?)
}
