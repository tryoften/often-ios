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

class SearchSuggestionsViewController: UITableViewController, SearchSuggestionsViewModelDelegate {
    var delegate: SearchSuggestionViewControllerDelegate?
    var viewModel: SearchSuggestionsViewModel
    var tableViewBottomInset: CGFloat {
        didSet {
            tableView.contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, tableViewBottomInset, contentInset.bottom)
        }
    }

    var contentInset: UIEdgeInsets {
        didSet {
            tableView.contentInset = contentInset
        }
    }

    init(viewModel aViewModel: SearchSuggestionsViewModel) {
        viewModel = aViewModel
    #if KEYBOARD
        contentInset = UIEdgeInsetsMake(2 * KeyboardSearchBarHeight, 0, 0, 0)
    #else
        contentInset = UIEdgeInsetsMake(68, 0, 0, 0)
    #endif
        tableViewBottomInset = 80
        
        super.init(style: .Grouped)

        viewModel.delegate = self
        viewModel.suggestionsDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showSearchSuggestionsView(showSearchSuggestionsView: Bool) {
        viewModel.requestData()
        if showSearchSuggestionsView {
            UIView.animateWithDuration(0.3, animations: {
                self.view.alpha = 1.0
                self.view.hidden = false
            })
        } else {
            view.hidden = true
            view.alpha = 0.0
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(SearchSuggestionTableViewCell.self, forCellReuseIdentifier: SearchSuggestionCellReuseIdentifier)
        tableView.registerClass(ServiceProviderSuggestionTableViewCell.self, forCellReuseIdentifier: ServiceProviderSuggestionCellReuseIdentifier)
        tableView.registerClass(SearchLoaderSuggestionTableViewCell.self, forCellReuseIdentifier: SearchLoaderSuggestionCellReuseIdentifier)
        tableView.separatorColor = DarkGrey
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.contentInset = contentInset

        view.backgroundColor = VeryLightGray
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.requestData()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let suggestions = viewModel.suggestions {
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
        
        if viewModel.suggestions?.isEmpty == true {
            let loaderCell = tableView.dequeueReusableCellWithIdentifier(SearchLoaderSuggestionCellReuseIdentifier, forIndexPath: indexPath) as? SearchLoaderSuggestionTableViewCell
            
            if indexPath.row % 2 == 0 {
                loaderCell?.short = true
            } else {
                loaderCell?.short = false
            }
            
            return loaderCell!
        }
        
        guard let suggestion = viewModel.suggestions?[indexPath.row] else {
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
        if viewModel.suggestions?.isEmpty == true {
            return
        }
    
        if let suggestion = viewModel.suggestions?[indexPath.row] {
            delegate?.searchSuggestionViewControllerDidTapSuggestion(self, suggestion: suggestion)
        }
    }

    // MARK: SearchSuggestionsViewModelDelegate
    func searchSuggestionsViewModelDidReceiveSuggestions(searchSuggestionsViewModel: SearchSuggestionsViewModel, suggestions: [SearchSuggestion]?) {
        tableView.reloadData()
        tableView.scrollRectToVisible(CGRectZero, animated: true)
    }

    func searchViewModelDidReceiveResponse(searchViewModel: SearchViewModel, response: SearchResponse, responseChanged: Bool) {
    }
}


protocol SearchSuggestionViewControllerDelegate: class {
    func searchSuggestionViewControllerDidTapSuggestion(viewController: SearchSuggestionsViewController, suggestion: SearchSuggestion)
}
