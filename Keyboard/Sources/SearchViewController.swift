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
    SearchSuggestionViewControllerDelegate,
    KeyboardSectionsContainerViewControllerDelegate,
    UISearchBarDelegate {
    var delegate: SearchViewControllerDelegate?
    var viewModel: SearchViewModel
    var searchBarController: SearchBarController
    var searchBarHeight: CGFloat = KeyboardSearchBarHeight
    var searchSuggestionsViewController: SearchSuggestionsViewController
    var searchResultsViewController: SearchResultsCollectionViewController
    var shouldLayoutSearchBar: Bool = true
    weak var searchResultsContainerView: UIView? {
        didSet {
            if let view = searchResultsContainerView {
                view.hidden = true
            }
        }
    }
    var textProcessor: TextProcessingManager?
    var noResultsTimer: NSTimer?
    var isNewSearch: Bool = false

    init(viewModel aViewModel: SearchViewModel,
        suggestionsViewModel: SearchSuggestionsViewModel,
        textProcessor aTextProcessor: TextProcessingManager?,
        SearchBarControllerClass: SearchBarController.Type,
        SearchBarClass: SearchBar.Type) {
            viewModel = aViewModel

            if let textProcessor = aTextProcessor {
                self.textProcessor = textProcessor
            }

            searchBarController = SearchBarControllerClass.init(viewModel: aViewModel, suggestionsViewModel: suggestionsViewModel, SearchBarClass: SearchBarClass)

            searchBarHeight = KeyboardSearchBarHeight

            searchSuggestionsViewController = SearchSuggestionsViewController(viewModel: suggestionsViewModel)
            searchResultsViewController = SearchResultsCollectionViewController(textProcessor: textProcessor)
            searchResultsViewController.searchBarController = searchBarController

            super.init(nibName: nil, bundle: nil)

            navigationController?.addChildViewController(searchBarController)
            addChildViewController(searchResultsViewController)

            view.addSubview(searchResultsViewController.view)
            view.addSubview(searchSuggestionsViewController.view)
            view.addSubview(searchBarController.view)

            view.hidden = true

            viewModel.delegate = self
            searchSuggestionsViewController.delegate = self
            searchBarController.searchBar.delegate = self

            let center = NSNotificationCenter.defaultCenter()

            center.addObserver(self, selector: "didTapEnterButton:", name: KeyboardEnterKeyTappedEvent, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if shouldLayoutSearchBar {
            searchBarController.view.frame = CGRectMake(0, KeyboardSearchBarHeight, CGRectGetWidth(view.frame), KeyboardSearchBarHeight)
        }
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
        guard let searchBar = searchBarController.searchBar as? KeyboardSearchBar else {
            return
        }

        if searchBar.textInput.text == "" {
            return
        }

        submitSearchRequest()
        delay(0.5) {
            searchBar.textInput.resignFirstResponder()
        }
        searchSuggestionsViewController.showSearchSuggestionsView(false)
    }

    func submitSearchRequest() {
       guard let text = searchBarController.searchBar.text else {
            return
        }

        let query = searchBarController.filter != nil ? searchBarController.filter!.text + " " + text : text
        viewModel.sendRequestForQuery(query, autocomplete: false)
        searchResultsViewController.updateEmptySetVisible(false)
        searchSuggestionsViewController.showSearchSuggestionsView(false)

        noResultsTimer?.invalidate()
        noResultsTimer = NSTimer.scheduledTimerWithTimeInterval(6.5, target: self, selector: "showNoResultsEmptyState", userInfo: nil, repeats: false)

        if searchBarController.searchBar.selected {
            searchResultsViewController.response = nil
            searchResultsViewController.refreshResults()
            searchResultsViewController.view.hidden = false
            NSNotificationCenter.defaultCenter().postNotificationName(CollapseKeyboardEvent, object: self)
        }
    }

    func keyboardHeightForOrientation(orientation: UIInterfaceOrientation) -> CGFloat {
        let isPad = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad

        //TODO: hardcoded stuff
        let actualScreenWidth = (UIScreen.mainScreen().nativeBounds.size.width / UIScreen.mainScreen().nativeScale)
        let canonicalPortraitHeight = (isPad ? CGFloat(264) : CGFloat(orientation.isPortrait && actualScreenWidth >= 400 ? 226 : 216))
        let canonicalLandscapeHeight = (isPad ? CGFloat(352) : CGFloat(162))

        return CGFloat(orientation.isPortrait ? canonicalPortraitHeight : canonicalLandscapeHeight)
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        view.hidden = false
        delegate?.searchViewControllerSearchBarDidTextDidBeginEditing(self, searchBar: searchBar)
        if let containerViewController = containerViewController {
            containerViewController.hideTabBar(true, animations: nil)
            var searchBarFrame = self.searchBarController.view.frame
            searchBarFrame.origin.y = containerViewController.tabBarHeight
            searchBarController.view.frame = searchBarFrame
        }
        searchSuggestionsViewController.tableViewBottomInset = keyboardHeightForOrientation(interfaceOrientation)
        searchSuggestionsViewController.showSearchSuggestionsView(true)
    }

    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        containerViewController?.showTabBar(true, animations: nil)
        searchSuggestionsViewController.tableViewBottomInset = 0
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchSuggestionsViewController.showSearchSuggestionsView(true)
        containerViewController?.resetPosition()
        view.hidden = true
        delegate?.searchViewControllerSearchBarDidTapCancel(self, searchBar: searchBar)
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if searchBar.text == "" {
            return
        }

        submitSearchRequest()
        delay(0.5) {
            searchBar.resignFirstResponder()
        }
        searchSuggestionsViewController.showSearchSuggestionsView(false)
        
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarController.textFieldDidChange()
    }

    func showNoResultsEmptyState() {
        searchResultsViewController.updateEmptySetVisible(true, animated: true)
    }

    // MARK: AutocorrectSuggestionsViewControllerDelegate
    func autocorrectSuggestionsViewControllerDidSelectSuggestion(autocorrectSuggestions: AutocorrectSuggestionsViewController, suggestion: SuggestItem) {
        textProcessor?.applyTextSuggestion(suggestion)
    }

    func autocorrectSuggestionsViewControllerShouldShowSuggestions(autocorrectSuggestions: AutocorrectSuggestionsViewController) -> Bool {
        if viewModel.hasReceivedResponse == false {
            return false
        }

        return true
    }

    // MARK: SearchSuggestionsViewControllerDelegate
    func searchSuggestionViewControllerDidTapSuggestion(viewController: SearchSuggestionsViewController, suggestion: SearchSuggestion) {
        var searchBar = searchBarController.searchBar

        switch(suggestion.type) {
        case .Query:
            isNewSearch = true
            containerViewController?.resetPosition()
            textProcessor?.parseTextInCurrentDocumentProxy()
            searchBar.text = suggestion.text
            searchResultsViewController.response = nil
            searchResultsViewController.refreshResults()

            if let searchBar = searchBarController.searchBar as? KeyboardSearchBar {     
                searchBar.cancelButton.selected = true

            }

            submitSearchRequest()
            searchBar.resignFirstResponder()
        case .Filter:
            searchBar.text = ""

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

        delegate?.searchViewControllerDidReceiveResponse(self)

        noResultsTimer?.invalidate()

        if isNewSearch {
            searchResultsViewController.view.hidden = false
            searchResultsViewController.response = response
            searchResultsViewController.refreshResults()
            NSNotificationCenter.defaultCenter().postNotificationName(CollapseKeyboardEvent, object: self)
            searchBarController.searchBar.resignFirstResponder()
            isNewSearch = false
        } else if responseChanged {
            searchResultsViewController.nextResponse = response
            searchResultsViewController.showRefreshResultsButton()
        }
    }

    func keyboardSectionsContainerViewControllerShouldShowBarShadow(containerViewController: KeyboardSectionsContainerViewController) -> Bool {
        return false
    }
}

protocol SearchViewControllerDelegate: class {
    func searchViewControllerSearchBarDidTextDidBeginEditing(viewController: SearchViewController, searchBar: UISearchBar)
    func searchViewControllerSearchBarDidTapCancel(viewController: SearchViewController,  searchBar: UISearchBar)
    func searchViewControllerDidReceiveResponse(viewController: SearchViewController)
}
