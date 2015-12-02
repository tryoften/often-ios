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
let SearchLoaderSuggestionCellReuseIdentifier = "SearchLoaderSuggestionsCell"

class SearchSuggestionsViewController: UITableViewController {
    var delegate: SearchSuggestionViewControllerDelegate?
    var suggestions: [SearchSuggestion]? {
        didSet {
            tableView.reloadData()
            tableView.scrollRectToVisible(CGRectZero, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(SearchSuggestionTableViewCell.self, forCellReuseIdentifier: SearchSuggestionCellReuseIdentifier)
        tableView.registerClass(ServiceProviderSuggestionTableViewCell.self, forCellReuseIdentifier: ServiceProviderSuggestionCellReuseIdentifier)
        tableView.registerClass(SearchLoaderSuggestionTableViewCell.self, forCellReuseIdentifier: SearchLoaderSuggestionCellReuseIdentifier)
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
            if suggestions.isEmpty {
                return 3
            } else {
                return suggestions.count
            }
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
        
        if suggestions?.isEmpty == true {
            let loaderCell = tableView.dequeueReusableCellWithIdentifier(SearchLoaderSuggestionCellReuseIdentifier, forIndexPath: indexPath) as? SearchLoaderSuggestionTableViewCell
            
            if indexPath.row % 2 == 0 {
                loaderCell?.short = true
            } else {
                loaderCell?.short = false
            }
            
            return loaderCell!
        }
        
        guard let suggestion = suggestions?[indexPath.row] else {
            return cell
        }
        
        switch (suggestion.type) {
        case .Filter:
            cell = tableView.dequeueReusableCellWithIdentifier(ServiceProviderSuggestionCellReuseIdentifier, forIndexPath: indexPath)
            
            guard let filterCell = cell as? ServiceProviderSuggestionTableViewCell else {
                return cell
            }
            if let image = suggestion.image {
                filterCell.serviceProviderLogo.image = UIImage(named: image)
            } else {
                filterCell.serviceProviderLogo.image = nil
            }
            cell.textLabel!.text = suggestion.text.capitalizedString
            
        case .Query:
            cell = tableView.dequeueReusableCellWithIdentifier(SearchSuggestionCellReuseIdentifier, forIndexPath: indexPath)
            cell.textLabel!.text = suggestion.text.capitalizedString
            
            if let searchCell = cell as? SearchSuggestionTableViewCell {
                searchCell.resultsCount = suggestion.resultsCount
            }
        case .Unknown:
            break
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if suggestions?.isEmpty == true {
            return
        }
    
        if let suggestion = suggestions?[indexPath.row] {
            delegate?.searchSuggestionViewControllerDidTapSuggestion(self, suggestion: suggestion)
        }
    }

}


protocol SearchSuggestionViewControllerDelegate: class {
    func searchSuggestionViewControllerDidTapSuggestion(viewController: SearchSuggestionsViewController, suggestion: SearchSuggestion)
}
