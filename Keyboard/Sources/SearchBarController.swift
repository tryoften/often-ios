//
//  SearchBarController.swift
//  Surf
//
//  Created by Luc Succes on 7/19/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import UIKit

class SearchBarController: UIViewController, UITextFieldDelegate, SearchViewModelDelegate,
    SearchSuggestionViewControllerDelegate, SearchSuggestionsViewModelDelegate,
    AutocorrectSuggestionsViewControllerDelegate {

    var viewModel: SearchViewModel!
    var suggestionsViewModel: SearchSuggestionsViewModel!
    var searchBar: SearchBar!
    var bottomSeperator: UIView!
    var textProcessor: TextProcessingManager? {
        didSet {
            primaryTextDocumentProxy = textProcessor?.currentProxy
        }
    }
    var filter: Filter?
    var autocorrectSuggestionsViewController: AutocorrectSuggestionsViewController?
    var searchSuggestionsViewController: SearchSuggestionsViewController?
    var searchResultsViewController: SearchResultsCollectionViewController?
    var searchResultsContainerView: UIView?
    var primaryTextDocumentProxy: UITextDocumentProxy?
    var noResultsTimer: NSTimer?
    var autocompleteTimer: NSTimer?

    var isNewSearch: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar = SearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.textInput.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged)
        searchBar.textInput.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: .EditingDidBegin)
        searchBar.textInput.addTarget(self, action: "textFieldDidEndEditing:", forControlEvents: .EditingDidEnd)
        searchBar.shareButton.addTarget(self, action: "didTapShareButton", forControlEvents: .TouchUpInside)
        
        if let textProcessor = textProcessor {
            textProcessor.proxies["search"] = searchBar.textInput
        }
        searchBar.textInput.placeholder = searchBar.textInput.placeholderText
        
        searchResultsContainerView?.hidden = true
        searchSuggestionsViewController = SearchSuggestionsViewController(style: .Grouped)
        searchSuggestionsViewController!.delegate = self
        searchSuggestionsViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        
        autocorrectSuggestionsViewController = AutocorrectSuggestionsViewController()
        autocorrectSuggestionsViewController!.delegate = self
        autocorrectSuggestionsViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        
        bottomSeperator = UIView()
        bottomSeperator.translatesAutoresizingMaskIntoConstraints = false
        bottomSeperator.backgroundColor = DarkGrey

        let baseURL = Firebase(url: BaseURL)
        viewModel = SearchViewModel(base: baseURL)
        viewModel.delegate = self
        
        suggestionsViewModel = SearchSuggestionsViewModel(base: baseURL)
        suggestionsViewModel.delegate = self
        suggestionsViewModel.suggestionsDelegate = self
        
        view.addSubview(searchSuggestionsViewController!.view)
        view.addSubview(searchBar)
        view.addSubview(autocorrectSuggestionsViewController!.view)
        view.addSubview(bottomSeperator)
        
        setupLayout()
        
        let center = NSNotificationCenter.defaultCenter()
        
        center.addObserver(self, selector: "resetSearchBar", name: KeyboardResetSearchBar, object: nil)
        center.addObserver(self, selector: "didTapEnterButton:", name: KeyboardEnterKeyTappedEvent, object: nil)
        center.addObserver(self, selector: "keyboardDidRestore", name: RestoreKeyboardEvent, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupLayout() {
        view.addConstraints([
            searchBar.al_top == view.al_top,
            searchBar.al_width == view.al_width,
            searchBar.al_left == view.al_left,
            searchBar.al_height == KeyboardSearchBarHeight,
            
            autocorrectSuggestionsViewController!.view.al_top == searchBar.al_top,
            autocorrectSuggestionsViewController!.view.al_height == KeyboardSearchBarHeight,
            autocorrectSuggestionsViewController!.view.al_left == searchBar.al_left,
            autocorrectSuggestionsViewController!.view.al_right == searchBar.al_right,
            
            searchSuggestionsViewController!.view.al_top == searchBar.al_bottom,
            searchSuggestionsViewController!.view.al_bottom == view.al_bottom,
            searchSuggestionsViewController!.view.al_left == view.al_left,
            searchSuggestionsViewController!.view.al_width == view.al_width,
            
            bottomSeperator.al_bottom == view.al_bottom,
            bottomSeperator.al_left == view.al_left,
            bottomSeperator.al_width == view.al_width,
            bottomSeperator.al_height == 0.6
        ])
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == searchBar {
                searchBar.textInput.becomeFirstResponder()
            }
        }
    }
    
    func resetSearchBar() {
        filter = nil
        searchBar.resetSearchBar()
        searchSuggestionsViewController?.tableView.setContentOffset(CGPointZero, animated: true)
        NSNotificationCenter.defaultCenter().postNotificationName(ResizeKeyboardEvent, object: self, userInfo: [
            "height": 0,
            "hideToggleBar": true
        ])
    }
    
    func submitSearchRequest() {
        let query = filter != nil ? filter!.text + " " + searchBar.textInput.text : searchBar.textInput.text
        viewModel.sendRequestForQuery(query, autocomplete: false)
        searchResultsViewController?.updateEmptySetVisible(false)
        
        noResultsTimer?.invalidate()
        noResultsTimer = NSTimer.scheduledTimerWithTimeInterval(6.5, target: self, selector: "showNoResultsEmptyState", userInfo: nil, repeats: false)
        
        if searchBar.textInput.selected {
            searchResultsViewController?.response = nil
            searchResultsViewController?.refreshResults()
            searchResultsContainerView?.hidden = false
            NSNotificationCenter.defaultCenter().postNotificationName(CollapseKeyboardEvent, object: self)
        }
    }
    
    func didTapShareButton() {
        if let shareText = PFConfig.currentConfig().objectForKey("shareText") as? String {
            textProcessor?.insertText(shareText)
        }
    }
    
    func scheduleAutocompleteRequestTimer() {
        autocompleteTimer?.invalidate()
        autocompleteTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "requestAutocompleteSuggestions", userInfo: nil, repeats: false)
    }
    
    func requestAutocompleteSuggestions() {
        let query = searchBar.textInput.text
        
        if query.isEmpty {
            suggestionsViewModel.sendRequestForQuery("#top-searches:10", autocomplete: true)
        } else if query == "#" {
            suggestionsViewModel.sendRequestForQuery("#filters-list", autocomplete: true)
        } else {
            suggestionsViewModel.sendRequestForQuery(query, autocomplete: true)
        }
    }
    
    func updateSuggestions(suggestions: [SuggestItem]) {
        autocorrectSuggestionsViewController?.suggestions = suggestions
    }
    
    func keyboardDidRestore() {
        searchResultsViewController?.response = nil
        searchResultsContainerView?.hidden = true
    }
    
    func didTapProviderButton(button: ServiceProviderSearchBarButton?) {
        resetSearchBar()
    }
    
    func didTapEnterButton(button: KeyboardKeyButton?) {
        if searchBar.textInput.text == "" {
            return
        }
        
        isNewSearch = true
        submitSearchRequest()
        delay(0.5) {
            self.searchBar.textInput.resignFirstResponder()
        }
    }
    
    func showNoResultsEmptyState() {
        searchResultsViewController!.updateEmptySetVisible(true, animated: true)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        textProcessor?.setCurrentProxyWithId("search")
        scheduleAutocompleteRequestTimer()
        
        let center = NSNotificationCenter.defaultCenter()
        
        center.postNotificationName(ResizeKeyboardEvent, object: self, userInfo: [
            "height": 100.0,
            "hideToggleBar": true
        ])
        center.postNotificationName(RestoreKeyboardEvent, object: nil)
        center.postNotificationName(ToggleButtonKeyboardEvent, object: nil, userInfo: ["hide": true])
        
        searchSuggestionsViewController?.tableView.scrollRectToVisible(CGRectZero, animated: false)
        
        // setup search results view controller if nil
        if searchResultsViewController == nil {
            searchResultsViewController = SearchResultsCollectionViewController(textProcessor: textProcessor)
            let searchResultsView = searchResultsViewController!.view
            searchResultsView.translatesAutoresizingMaskIntoConstraints = false
            
            if let containerView = searchResultsContainerView {
                containerView.addSubview(searchResultsView)
                containerView.addConstraints([
                    searchResultsView.al_top == containerView.al_top,
                    searchResultsView.al_left == containerView.al_left,
                    searchResultsView.al_bottom == containerView.al_bottom,
                    searchResultsView.al_right == containerView.al_right
                ])
            }
        }
    }
    
    func textFieldDidChange() {
        textProcessor?.parseTextInCurrentDocumentProxy()
        searchSuggestionsViewController?.tableView.setContentOffset(CGPointZero, animated: true)

        if viewModel.hasReceivedResponse {
            scheduleAutocompleteRequestTimer()
            isNewSearch = true
            searchResultsContainerView?.hidden = true
            NSNotificationCenter.defaultCenter().postNotificationName(ToggleButtonKeyboardEvent, object: nil, userInfo: ["hide": true])
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textProcessor?.setCurrentProxyWithId("default")
        searchSuggestionsViewController?.tableView.setContentOffset(CGPointZero, animated: true)
    }
    
    func setFilter(filter: Filter) {
        self.filter = filter
        searchBar?.setFilterButton(filter)
        suggestionsViewModel.sendRequestForQuery("#top-searches:10", autocomplete: true)
    }
    
    // MARK: SearchViewModelDelegate
    func searchViewModelDidReceiveResponse(searchViewModel: SearchViewModel, response: SearchResponse, responseChanged: Bool) {
        // TODO(luc): don't do anything if the keyboard is restored
        if response.results.isEmpty {
            return
        }
        
        noResultsTimer?.invalidate()
        
        if isNewSearch {
            searchResultsViewController?.view.hidden = false
            searchResultsViewController?.response = response
            searchResultsViewController?.refreshResults()
            NSNotificationCenter.defaultCenter().postNotificationName(CollapseKeyboardEvent, object: self)
            searchBar.textInput.resignFirstResponder()
            isNewSearch = false
        } else if responseChanged {
            searchResultsViewController?.nextResponse = response
            searchResultsViewController?.showRefreshResultsButton()
        }
    }
    
    // MARK: SearchSuggestionsViewModelDelegate
    func searchSuggestionsViewModelDidReceiveSuggestions(searchSuggestionsViewModel: SearchSuggestionsViewModel, suggestions: [SearchSuggestion]?) {
        searchSuggestionsViewController?.suggestions = suggestions
    }
    
    // MARK: SearchSuggestionsViewControllerDelegate
    func searchSuggestionViewControllerDidTapSuggestion(viewController: SearchSuggestionsViewController, suggestion: SearchSuggestion) {
        
        switch(suggestion.type) {
        case .Query:
            isNewSearch = true
            textProcessor?.parseTextInCurrentDocumentProxy()
            searchBar.textInput.text = suggestion.text
            searchBar.cancelButton.selected = true
            submitSearchRequest()
            searchBar.textInput.resignFirstResponder()
        case .Filter:
            textProcessor?.parseTextInCurrentDocumentProxy()
            searchBar.textInput.text = ""
            if let filter = suggestionsViewModel.checkFilterInQuery(suggestion.text) {
                setFilter(filter)
            }
        case .Unknown:
            break
        }
    }
    
    // MARK: AutocorrectSuggestionsViewControllerDelegate
    func autocorrectSuggestionsViewControllerDidSelectSuggestion(autocorrectSuggestions: AutocorrectSuggestionsViewController, suggestion: SuggestItem) {
        textProcessor?.applyTextSuggestion(suggestion)
    }
    
    func autocorrectSuggestionsViewControllerShouldShowSuggestions(autocorrectSuggestions: AutocorrectSuggestionsViewController) -> Bool {
        if !viewModel.hasReceivedResponse {
            return false
        }
        
        if searchBar.textInput.selected {
            return false
        }
        return true
    }
}
