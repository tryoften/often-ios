//
//  SearchSuggestionsViewController.swift
//  Often
//
//  Created by Luc Succes on 8/28/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

let SearchSuggestionCellReuseIdentifier = "SearchSuggestionsCell"

class SearchSuggestionsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(SearchSuggestionTableViewCell.self, forCellReuseIdentifier: SearchSuggestionCellReuseIdentifier)
        tableView.separatorColor = DarkGrey
        tableView.separatorInset = UIEdgeInsetsZero
        view.backgroundColor = VeryLightGray
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
        return 5
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SearchSuggestionCellReuseIdentifier, forIndexPath: indexPath) as! SearchSuggestionTableViewCell

        // Configure the cell...
        cell.textLabel!.text = "Luc is dope"

        return cell
    }

}
