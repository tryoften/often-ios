//
//  SearchViewController.swift
//  Often
//
//  Created by Luc Succes on 12/14/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

/// Controller that displays a search bar and search results
class SearchViewController: UIViewController, SearchViewModelDelegate,
    SearchSuggestionViewControllerDelegate {
    var viewModel: SearchViewModel
    var searchBarController: SearchBarController
    var searchBarHeight: CGFloat = KeyboardSearchBarHeight
    var searchSuggestionsViewController: SearchSuggestionsViewController
    var searchResultsViewController: SearchResultsCollectionViewController
    weak var searchResultsContainerView: UIView? {
        didSet {
            if let view = searchResultsContainerView {
                view.hidden = true
            }
        }
    }
    var textProcessor: TextProcessingManager
    var noResultsTimer: NSTimer?
    var isNewSearch: Bool = false

    init(viewModel aViewModel: SearchViewModel, suggestionsViewModel: SearchSuggestionsViewModel, textProcessor aTextProcessor: TextProcessingManager) {
        viewModel = aViewModel
        textProcessor = aTextProcessor

        searchBarController = SearchBarController(viewModel: aViewModel, suggestionsViewModel: suggestionsViewModel)
        searchBarController.textProcessor = textProcessor
        searchBarHeight = KeyboardSearchBarHeight

        searchSuggestionsViewController = SearchSuggestionsViewController(viewModel: suggestionsViewModel)
        searchResultsViewController = SearchResultsCollectionViewController(textProcessor: textProcessor)
        searchResultsViewController.searchBarController = searchBarController

        super.init(nibName: nil, bundle: nil)

        addChildViewController(searchBarController)
        addChildViewController(searchResultsViewController)

        view.addSubview(searchResultsViewController.view)
        view.addSubview(searchSuggestionsViewController.view)
        view.addSubview(searchBarController.view)

        viewModel.delegate = self
        searchSuggestionsViewController.delegate = self

        let center = NSNotificationCenter.defaultCenter()

        center.addObserver(self, selector: "didTapEnterButton:", name: KeyboardEnterKeyTappedEvent, object: nil)

        searchBarController.searchBar.textInput.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: .EditingDidBegin)
        searchBarController.searchBar.textInput.addTarget(self, action: "textFieldDidEndEditing:", forControlEvents: .EditingDidEnd)
        searchBarController.searchBar.cancelButton.addTarget(self, action: "didTapSearchBarCancelButton", forControlEvents: .TouchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        searchBarController.view.frame = CGRectMake(0, KeyboardSearchBarHeight, CGRectGetWidth(view.frame), KeyboardSearchBarHeight)
        let containerFrame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))
        searchResultsViewController.view.frame = containerFrame
        searchSuggestionsViewController.view.frame = containerFrame
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchBarController.requestAutocompleteSuggestions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didTapEnterButton(button: KeyboardKeyButton?) {
        let searchBar = searchBarController.searchBar
        if searchBar.textInput.text == "" {
            return
        }

        submitSearchRequest()
        delay(0.5) {
            searchBar.textInput.resignFirstResponder()
        }
        searchSuggestionsViewController.view.hidden = true
    }

    func submitSearchRequest() {
        let text = searchBarController.searchBar.textInput.text
        let query = searchBarController.filter != nil ? searchBarController.filter!.text + " " + text : text
        viewModel.sendRequestForQuery(query, autocomplete: false)
        searchResultsViewController.updateEmptySetVisible(false)
        searchSuggestionsViewController.view.hidden = true

        noResultsTimer?.invalidate()
        noResultsTimer = NSTimer.scheduledTimerWithTimeInterval(6.5, target: self, selector: "showNoResultsEmptyState", userInfo: nil, repeats: false)

        if searchBarController.searchBar.textInput.selected {
            searchResultsViewController.response = nil
            searchResultsViewController.refreshResults()
            searchResultsViewController.view.hidden = false
            NSNotificationCenter.defaultCenter().postNotificationName(CollapseKeyboardEvent, object: self)
        }
    }

    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        containerViewController?.hideTabBar(true) {
            var searchBarFrame = self.searchBarController.view.frame
            searchBarFrame.origin.y = 0
            self.searchBarController.view.frame = searchBarFrame
        }
        searchSuggestionsViewController.view.hidden = false
    }

    func textFieldDidEndEditing(textField: UITextField) {
        containerViewController?.showTabBar(true)
    }

    func didTapSearchBarCancelButton() {

    }

    // MARK: AutocorrectSuggestionsViewControllerDelegate
    func autocorrectSuggestionsViewControllerDidSelectSuggestion(autocorrectSuggestions: AutocorrectSuggestionsViewController, suggestion: SuggestItem) {
        textProcessor.applyTextSuggestion(suggestion)
    }

    func autocorrectSuggestionsViewControllerShouldShowSuggestions(autocorrectSuggestions: AutocorrectSuggestionsViewController) -> Bool {
        if viewModel.hasReceivedResponse == false {
            return false
        }

        return true
    }

    // MARK: SearchSuggestionsViewControllerDelegate
    func searchSuggestionViewControllerDidTapSuggestion(viewController: SearchSuggestionsViewController, suggestion: SearchSuggestion) {
        let searchBar = searchBarController.searchBar

        switch(suggestion.type) {
        case .Query:
            isNewSearch = true
            textProcessor.parseTextInCurrentDocumentProxy()
            searchBar.textInput.text = suggestion.text
            searchBar.cancelButton.selected = true
            submitSearchRequest()
            searchBar.textInput.resignFirstResponder()
        case .Filter:
            textProcessor.parseTextInCurrentDocumentProxy()
            searchBar.textInput.text = ""
            if let filter = searchSuggestionsViewController.viewModel.checkFilterInQuery(suggestion.text) {
                searchBarController.setFilter(filter)
            }
        case .Unknown:
            break
        }
    }

    // MARK: SearchViewModelDelegate
    func searchViewModelDidReceiveResponse(searchViewModel: SearchViewModel, response: SearchResponse, responseChanged: Bool) {
        // TODO(luc): don't do anything if the keyboard is restored
        if response.results.isEmpty {
            return
        }

        noResultsTimer?.invalidate()

        if isNewSearch {
            searchResultsViewController.view.hidden = false
            searchResultsViewController.response = response
            searchResultsViewController.refreshResults()
            NSNotificationCenter.defaultCenter().postNotificationName(CollapseKeyboardEvent, object: self)
            searchBarController.searchBar.textInput.resignFirstResponder()
            isNewSearch = false
        } else if responseChanged {
            searchResultsViewController.nextResponse = response
            searchResultsViewController.showRefreshResultsButton()
        }
    }

}
