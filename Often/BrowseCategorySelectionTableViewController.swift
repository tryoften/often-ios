//
//  BrowseCategorySelectionTableViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 6/15/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class BrowseCategorySelectionTableViewController: UITableViewController {

    let mediaCategories = [
        "MUSIC",
        "TV SHOWS",
        "SPORTS",
        "POLITICS",
        "CELEBS",
        "RANDOM"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tableView = tableView {
            tableView.registerClass(BrowseCategorySelectionTableViewCell.self, forCellReuseIdentifier: "categoryCell")
            tableView.contentInset = UIEdgeInsetsMake(UIScreen.mainScreen().bounds.height * 0.1, 0.0, 0.0, 0.0)
            tableView.showsVerticalScrollIndicator = false
            tableView.separatorStyle = .None
            tableView.backgroundColor = ClearColor
            tableView.scrollEnabled = false
        }
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
        return mediaCategories.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath) as? BrowseCategorySelectionTableViewCell {
            cell.textLabel?.setTextWith(UIFont(name: "Montserrat", size: 12.0)!,
                                        letterSpacing: 1.0,
                                        color: UIColor.oftBlack74Color(),
                                        text: mediaCategories[indexPath.row])
            cell.indentationLevel = 3
            
            return cell
        }

        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: Scroll To Browse View
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
