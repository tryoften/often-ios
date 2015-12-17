//
//  SearchViewController.swift
//  Often
//
//  Created by Luc Succes on 12/14/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

/// Controller that displays a search bar and search results
class SearchViewController: UIViewController, SearchViewModelDelegate {
    var viewModel: SearchViewModel
    var searchBarController: SearchBarController
    var searchBarHeight: CGFloat = KeyboardSearchBarHeight
    var resultsContainerView: UIView

    init(viewModel aViewModel: SearchViewModel, textProcessor: TextProcessingManager) {
        viewModel = aViewModel

        searchBarController = SearchBarController(viewModel: aViewModel)
        searchBarController.textProcessor = textProcessor
        searchBarHeight = KeyboardSearchBarHeight

        resultsContainerView = UIView()
        searchBarController.searchResultsContainerView = resultsContainerView

        let baseURL = Firebase(url: BaseURL)
        let suggestionsViewModel = SearchSuggestionsViewModel(base: baseURL)
        searchBarController.suggestionsViewModel = suggestionsViewModel
        searchBarController.viewModel = viewModel
        searchBarController.searchResultsContainerView = resultsContainerView

        suggestionsViewModel.delegate = searchBarController
        suggestionsViewModel.suggestionsDelegate = searchBarController

        super.init(nibName: nil, bundle: nil)

        view.addSubview(resultsContainerView)
        view.addSubview(searchBarController.view)

        searchBarController.searchBar.textInput.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: .EditingDidBegin)
        searchBarController.searchBar.textInput.addTarget(self, action: "textFieldDidEndEditing:", forControlEvents: .EditingDidEnd)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        searchBarController.view.frame = view.bounds
        resultsContainerView.frame = CGRectMake(0, KeyboardSearchBarHeight, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame) - KeyboardSearchBarHeight)
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

    func searchViewModelDidReceiveResponse(searchViewModel: SearchViewModel, response: SearchResponse, responseChanged: Bool) {

    }

    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        containerViewController?.hideTabBar(true)
    }

    func textFieldDidEndEditing(textField: UITextField) {
        containerViewController?.showTabBar(true)
    }
}
