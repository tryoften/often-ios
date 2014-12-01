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
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.labelFont = UIFont(name: "Lato-Light", size: 20)

        self.tableView.backgroundColor = UIColor(fromHexString: "#1f2743")
        self.tableView.separatorColor = UIColor(fromHexString: "#373e57")
        self.tableView.separatorInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        self.tableView.registerNib(UINib(nibName: LyricTableViewCellIdentifier, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: LyricTableViewCellIdentifier)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
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
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
