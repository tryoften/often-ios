//
//  BrowseCategorySelectionTableViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 6/15/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class BrowseCategorySelectionTableViewController: UITableViewController {
    
    var viewModel: PacksViewModel
    
    init(style: UITableViewStyle, viewModel: PacksViewModel) {
        self.viewModel = viewModel
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        return viewModel.mediaItemGroups.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath) as? BrowseCategorySelectionTableViewCell, let section = viewModel.mediaItemGroups[indexPath.row].title {
            cell.textLabel?.setTextWith(UIFont(name: "Montserrat", size: 12.0)!,
                                        letterSpacing: 1.0,
                                        color: UIColor.oftBlack74Color(),
                                        text: section.uppercaseString)
            cell.indentationLevel = 3
            
            return cell
        }

        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSNotificationCenter.defaultCenter().postNotificationName("didSelectBrowseCategory", object: nil, userInfo: ["section": indexPath.row])
    }
}
