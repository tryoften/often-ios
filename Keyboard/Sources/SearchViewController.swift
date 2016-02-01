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

            searchResultsViewController.searchViewController = self

            navigationController?.addChildViewController(searchBarController)
            view.addSubview(searchBarController.view)

            addChildViewController(searchResultsViewController)
            view.addSubview(searchResultsViewController.view)

            addChildViewController(searchSuggestionsViewController)
            view.addSubview(searchSuggestionsViewController.view)

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
        searchSuggestionsViewController.viewModel.requestData()
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

    func didTapEmptyStateView() {
        submitSearchRequest()
    }

    func submitSearchRequest() {

        guard let text = searchBarController.searchBar.text else {
            return
        }

        viewModel.sendRequestForQuery(text, type: .Search)
        searchResultsViewController.hideEmptyStateView()

        searchSuggestionsViewController.showSearchSuggestionsView(false)

        noResultsTimer?.invalidate()
        noResultsTimer = NSTimer.scheduledTimerWithTimeInterval(6.5, target: self, selector: "showNoResultsEmptyState", userInfo: nil, repeats: false)

        searchResultsViewController.response = nil
        searchResultsViewController.view.hidden = false
        searchResultsViewController.showLoadingView()

    #if KEYBOARD
        NSNotificationCenter.defaultCenter().postNotificationName(CollapseKeyboardEvent, object: self)
    #endif
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
        containerViewController?.resetPosition()
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
        if searchBar.text?.isEmpty == true {
            return
        }

        submitSearchRequest()
        delay(0.5) {
            searchBar.resignFirstResponder()
        }
        searchSuggestionsViewController.showSearchSuggestionsView(false)
        searchResultsViewController.showLoadingView()
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarController.textFieldDidChange()
    }

    func showNoResultsEmptyState() {
        searchResultsViewController.updateEmptyStateContent(.NoResults, animated: true)
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
            searchResultsViewController.showLoadingView()
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
        if response.groups.isEmpty {
            return
        }

        delegate?.searchViewControllerDidReceiveResponse(self)
        noResultsTimer?.invalidate()

        searchResultsViewController.view.hidden = false
        searchResultsViewController.response = response
        searchResultsViewController.refreshResults()
        NSNotificationCenter.defaultCenter().postNotificationName(CollapseKeyboardEvent, object: self)
        searchBarController.searchBar.resignFirstResponder()
        isNewSearch = false
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
