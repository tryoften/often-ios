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
    var delegate: SearchSuggestionViewControllerDelegate?
    var suggestions: [[String: AnyObject]]? {
        didSet {
            tableView.reloadData()
            tableView.scrollRectToVisible(CGRectZero, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(SearchSuggestionTableViewCell.self, forCellReuseIdentifier: SearchSuggestionCellReuseIdentifier)
        tableView.separatorColor = DarkGrey
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.contentInset = UIEdgeInsetsZero

        view.backgroundColor = VeryLightGray
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
        if let suggestions = suggestions {
            return suggestions.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return SearchSuggestionTableHeaderView()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SearchSuggestionCellReuseIdentifier, forIndexPath: indexPath) as! SearchSuggestionTableViewCell
        
        if let suggestion = suggestions?[indexPath.row] {
            if let text = suggestion["text"] as? String {
                cell.textLabel!.text = text.capitalizedString
            }
            
            if let resultsCount = suggestion["resultsCount"] as? Int {
                cell.resultsCount = resultsCount
            } else {
                cell.resultsCount = nil
            }
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let suggestion = suggestions?[indexPath.row],
            let text = suggestion["text"] as? String {
            delegate?.searchSuggestionViewControllerDidTapSuggestion(self, suggestion: text)
        }
    }

}


protocol SearchSuggestionViewControllerDelegate: class {
    func searchSuggestionViewControllerDidTapSuggestion(viewController: SearchSuggestionsViewController, suggestion: String)
}
