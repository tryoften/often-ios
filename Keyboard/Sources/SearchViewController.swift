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

    UISearchBarDelegate {
    var delegate: SearchViewControllerDelegate?
    var viewModel: SearchViewModel
    var searchBarController: SearchBarController
    var searchBarHeight: CGFloat = KeyboardSearchBarHeight
    var searchSuggestionsViewController: SearchSuggestionsViewController
    var shouldLayoutSearchBar: Bool = true
    weak var searchResultsContainerView: UIView? {
        didSet {
            if let view = searchResultsContainerView {
                view.hidden = true
            }
        }
    }
    var textProcessor: TextProcessingManager?
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

            super.init(nibName: nil, bundle: nil)

            navigationController?.addChildViewController(searchBarController)
            view.addSubview(searchBarController.view)

            addChildViewController(searchSuggestionsViewController)
            view.addSubview(searchSuggestionsViewController.view)

            view.hidden = true

            viewModel.delegate = self
            searchSuggestionsViewController.delegate = self
            searchBarController.searchBar.delegate = self
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

        searchSuggestionsViewController.view.frame = containerFrame
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchSuggestionsViewController.viewModel.requestData()
    }

    func didTapEnterButton(button: UIButton?) {
        let searchBar = searchBarController.searchBar

        if searchBar.text == "" {
            return
        }

        submitSearchRequest()
        searchBar.resignFirstResponder()
    }

    func submitSearchRequest() {
        guard let text = searchBarController.searchBar.text else {
            return
        }

//        if let searchBar = searchBarController.searchBar as? MainAppSearchBar {
//            searchBar.setShowsCancelButton(false, animated: false)
//        }
        searchSuggestionsViewController.showSearchSuggestionsView(false)
        view.hidden = true
        
        searchBarController.searchBar.reset()
        
        viewModel.sendRequestForQuery(text, type: .Search)

    #if KEYBOARD
        NSNotificationCenter.defaultCenter().postNotificationName(CollapseKeyboardEvent, object: self)
    #endif

        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        navigationController?.view.layer.addAnimation(transition, forKey: nil)

        let searchResultsViewController = SearchResultsCollectionViewController(textProcessor: textProcessor, searchViewModel: SearchViewModel(base: Firebase(url: BaseURL)), query: text)
        navigationController?.pushViewController(searchResultsViewController, animated: false)
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

        searchSuggestionsViewController.tableViewBottomInset = keyboardHeightForOrientation(interfaceOrientation)
        searchSuggestionsViewController.showSearchSuggestionsView(true)
    }

    func searchBarTextDidEndEditing(searchBar: UISearchBar) {

        searchSuggestionsViewController.tableViewBottomInset = 0
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchSuggestionsViewController.showSearchSuggestionsView(true)
        view.hidden = true
        delegate?.searchViewControllerSearchBarDidTapCancel(self, searchBar: searchBar)
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if searchBar.text?.isEmpty == true {
            return
        }

        submitSearchRequest()

        searchBar.resignFirstResponder()
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarController.textFieldDidChange()
    }


    // MARK: SearchSuggestionsViewControllerDelegate
    func searchSuggestionViewControllerDidTapSuggestion(viewController: SearchSuggestionsViewController, suggestion: SearchSuggestion) {
        var searchBar = searchBarController.searchBar

        switch suggestion.type {
        case .Query:
            isNewSearch = true

            textProcessor?.parseTextInCurrentDocumentProxy()
            searchBar.text = suggestion.text

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
        searchBarController.searchBar.resignFirstResponder()
        isNewSearch = false
    }


}

protocol SearchViewControllerDelegate: class {
    func searchViewControllerSearchBarDidTextDidBeginEditing(viewController: SearchViewController, searchBar: UISearchBar)
    func searchViewControllerSearchBarDidTapCancel(viewController: SearchViewController,  searchBar: UISearchBar)
    func searchViewControllerDidReceiveResponse(viewController: SearchViewController)
}
