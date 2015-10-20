//
//  SearchSuggestionsViewController.swift
//  Often
//
//  Created by Luc Succes on 8/28/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

let SearchSuggestionCellReuseIdentifier = "SearchSuggestionsCell"
let ServiceProviderSuggestionCellReuseIdentifier = "ServiceProviderSuggestionCell"

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
        tableView.registerClass(ServiceProviderSuggestionTableViewCell.self, forCellReuseIdentifier: ServiceProviderSuggestionCellReuseIdentifier)
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
        var cell: UITableViewCell = UITableViewCell()
        
        // TODO(luc): Create suggestion model
        if let suggestion = suggestions?[indexPath.row],
            let type = suggestion["type"] as? String {
                
                guard let text = suggestion["text"] as? String,
                    let id = suggestion["id"] as? String else {
                    return cell
                }
            
                if type == "filter" {
                    cell = tableView.dequeueReusableCellWithIdentifier(ServiceProviderSuggestionCellReuseIdentifier, forIndexPath: indexPath)
                    
                    let filterCell = cell as! ServiceProviderSuggestionTableViewCell
                    if let image = suggestion["image"] as? String {
                        filterCell.serviceProviderLogoImage = UIImage(named: image)
                    }
                    cell.textLabel!.text = text.capitalizedString

                    
                } else if type == "query" {
                    cell = tableView.dequeueReusableCellWithIdentifier(SearchSuggestionCellReuseIdentifier, forIndexPath: indexPath)
                    cell.textLabel!.text = text.capitalizedString
                    
                    let searchCell = cell as! SearchSuggestionTableViewCell
                    
                    if let resultsCount = suggestion["resultsCount"] as? Int {
                        searchCell.resultsCount = resultsCount
                    } else {
                        searchCell.resultsCount = nil
                    }
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
