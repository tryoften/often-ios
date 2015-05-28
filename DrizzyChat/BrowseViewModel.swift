//
//  BrowseViewModel.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 5/27/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

/*******************************************************************************************************
BrowseViewModel
Load data into the tracks array
Acts as table view data source and delegates to the BrowseViewController
Table View Cell
    -> index + 1 ranking in left block
    -> Track Name as Title
    -> Lyric Count as Subtitle
    -> Add a cellAccessoryDisclosureIndicator in right block
*******************************************************************************************************/

class BrowseViewModel: NSObject, UITableViewDataSource {
    var tracks: [Track]?
    
    //(kom) maybe should create own table cell object
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        
        //cell.textLabel?.text = //track name
        //cell.detailTextLabel?.text = //lyric count
        cell.textLabel?.font = UIFont(name: "Lato-Regular", size: 18.0)
        cell.detailTextLabel?.font = UIFont(name: "Lato-Regular", size: 14.0)
        
        cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}
