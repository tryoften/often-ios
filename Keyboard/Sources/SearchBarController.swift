//
//  SearchBarController.swift
//  Surf
//
//  Created by Luc Succes on 7/19/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import UIKit

class SearchBarController: UIViewController, UITextFieldDelegate, SearchViewModelDelegate,
    SearchSuggestionViewControllerDelegate {
    var viewModel: SearchViewModel!
    var searchBarView: SearchBar!
    var supplementaryViewContainer: UIView!
    var supplementaryViewHeightConstraint: NSLayoutConstraint!
    var bottomSeperator: UIView!
    var textProcessor: TextProcessingManager? {
        didSet {
            primaryTextDocumentProxy = textProcessor?.currentProxy
        }
    }
    var searchSuggestionsViewController: SearchSuggestionsViewController?
    var searchResultsViewController: SearchResultsCollectionViewController?
    var searchResultsContainerView: UIView?
    var primaryTextDocumentProxy: UITextDocumentProxy?
    var activeServiceProviderType: ServiceProviderType? {
        didSet {
            if let providerType = activeServiceProviderType {
                var button: ServiceProviderSearchBarButton?
                switch(providerType) {
                case .Venmo:
                    activeServiceProvider = VenmoServiceProvider(providerType: providerType, textProcessor: textProcessor!)
                    activeServiceProvider?.searchBarController = self
                    button = activeServiceProvider!.provideSearchBarButton()
                    break
                case .Foursquare:
                    break
                default:
                    break
                }
                button?.addTarget(self, action: "didTapProviderButton:", forControlEvents: .TouchUpInside)
                searchBarView.providerButton = button
            }
        }
    }

    var activeServiceProvider: ServiceProvider? {
        didSet {
            if let supplementaryViewController = activeServiceProvider?.provideSupplementaryViewController() {
                supplementaryViewController.searchBarController = self
                activeSupplementaryViewController = supplementaryViewController
                supplementaryViewContainer.addSubview(supplementaryViewController.view)

                NSNotificationCenter.defaultCenter().postNotificationName(ResizeKeyboardEvent, object: self, userInfo: [
                    "height": supplementaryViewController.supplementaryViewHeight
                ])
            }
        }
    }
    var activeSupplementaryViewController: ServiceProviderSupplementaryViewController? {
        didSet {
            if let supplementaryViewController = activeSupplementaryViewController {
                supplementaryViewHeightConstraint.constant = supplementaryViewController.supplementaryViewHeight
                
                searchBarView.textInput.selected = false
                searchBarView.textInput.placeholder = supplementaryViewController.searchBarPlaceholderText
            }
        }
        
        willSet(value) {
            if value == nil {
                if let supplementaryViewController = activeSupplementaryViewController {
                    supplementaryViewController.view.removeFromSuperview()
                    supplementaryViewHeightConstraint.constant = 0
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarView = SearchBar()
        searchBarView.setTranslatesAutoresizingMaskIntoConstraints(false)
        searchBarView.textInput.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged)
        searchBarView.textInput.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: .EditingDidBegin)
        searchBarView.textInput.addTarget(self, action: "textFieldDidEndEditing:", forControlEvents: .EditingDidEnd)
        if let textProcessor = textProcessor {
            textProcessor.proxies["search"] = searchBarView.textInput
        }
        searchResultsContainerView?.hidden = true
        searchSuggestionsViewController = SearchSuggestionsViewController(style: .Grouped)
        searchSuggestionsViewController!.delegate = self
        searchSuggestionsViewController!.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        bottomSeperator = UIView()
        bottomSeperator.setTranslatesAutoresizingMaskIntoConstraints(false)
        bottomSeperator.backgroundColor = DarkGrey
        
        supplementaryViewContainer = UIView()
        supplementaryViewContainer.backgroundColor = VeryLightGray
        supplementaryViewContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
        supplementaryViewHeightConstraint = supplementaryViewContainer.al_height == 0
        
        viewModel = SearchViewModel(base: Firebase(url: BaseURL))
        viewModel.delegate = self
        
        view.addSubview(searchSuggestionsViewController!.view)
        view.addSubview(supplementaryViewContainer)
        view.addSubview(searchBarView)
        view.addSubview(bottomSeperator)
        
        view.addConstraints([
            searchBarView.al_top == view.al_top,
            searchBarView.al_width == view.al_width,
            searchBarView.al_left == view.al_left,
            searchBarView.al_height == KeyboardSearchBarHeight,

            supplementaryViewContainer.al_top == searchBarView.al_bottom,
            supplementaryViewContainer.al_bottom == view.al_bottom,
            supplementaryViewContainer.al_left == view.al_left,
            supplementaryViewContainer.al_width == view.al_width,
            supplementaryViewHeightConstraint,
            
            searchSuggestionsViewController!.view.al_top == searchBarView.al_bottom,
            searchSuggestionsViewController!.view.al_bottom == view.al_bottom,
            searchSuggestionsViewController!.view.al_left == view.al_left,
            searchSuggestionsViewController!.view.al_width == view.al_width,
            
            bottomSeperator.al_bottom == view.al_bottom,
            bottomSeperator.al_left == view.al_left,
            bottomSeperator.al_width == view.al_width,
            bottomSeperator.al_height == 0.6
        ])
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveSearchBarButton:", name: VenmoAddSearchBarButtonEvent, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resetSearchBar", name: "SearchBarController.resetSearchBar", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didTapEnterButton:", name: KeyboardEnterKeyTappedEvent, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidRestore", name: RestoreKeyboardEvent, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            if touch.view == searchBarView {
                searchBarView.textInput.becomeFirstResponder()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let activeSupplementaryViewController = activeSupplementaryViewController {
            activeSupplementaryViewController.view.frame = supplementaryViewContainer.bounds
        }
    }
    
    func didReceiveSearchBarButton(notification: NSNotification) {
        if let userInfo = notification.userInfo,
            button = userInfo["button"] as? SearchBarButton {
            searchBarView.addButton(button)
            searchBarView.textInput.leftView = UIView()
        }
    }
    
    func resetSearchBar() {
        searchBarView.resetSearchBar()
        activeServiceProviderType = nil
        activeServiceProvider = nil
        activeSupplementaryViewController = nil
        NSNotificationCenter.defaultCenter().postNotificationName(ResizeKeyboardEvent, object: self, userInfo: [
            "height": 0
        ])
    }
    
    func submitSearchRequest() {
        let query = searchBarView.textInput.text
        viewModel.sendRequestForQuery(query, autocomplete: false)
        
        if searchBarView.textInput.selected {
            searchResultsContainerView?.hidden = false
            NSNotificationCenter.defaultCenter().postNotificationName(CollapseKeyboardEvent, object: self)
        }
    }
    
    func requestAutocompleteSuggestions() {
        if searchBarView.textInput.text.isEmpty {
            viewModel.sendRequestForQuery("#top-searches:10", autocomplete: true)
        } else {
            let query = searchBarView.textInput.text
            viewModel.sendRequestForQuery(query, autocomplete: true)
        }
    }
    
    func keyboardDidRestore() {
        searchResultsViewController?.response = nil
        searchResultsContainerView?.hidden = true
    }
    
    func didTapProviderButton(button: ServiceProviderSearchBarButton?) {
        resetSearchBar()
        
    }
    
    func didTapEnterButton(button: KeyboardKeyButton?) {
        submitSearchRequest()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        textProcessor?.setCurrentProxyWithId("search")
        requestAutocompleteSuggestions()
        
        NSNotificationCenter.defaultCenter().postNotificationName(ResizeKeyboardEvent, object: self, userInfo: [
            "height": 100.0
        ])
        
        searchSuggestionsViewController?.tableView.scrollRectToVisible(CGRectZero, animated: false)
        
        if searchResultsViewController == nil {
            searchResultsViewController = SearchResultsCollectionViewController(textProcessor: textProcessor)
            let searchResultsView = searchResultsViewController!.view
            searchResultsView.setTranslatesAutoresizingMaskIntoConstraints(false)
            
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
        
        if viewModel.hasReceivedResponse {
            requestAutocompleteSuggestions()
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textProcessor?.setCurrentProxyWithId("default")
        
        NSNotificationCenter.defaultCenter().postNotificationName(ResizeKeyboardEvent, object: self, userInfo: [
            "height": 0
        ])
    }
    
    // MARK: SearchViewModelDelegate
    func searchViewModelDidReceiveResponse(searchViewModel: SearchViewModel, response: SearchResponse) {
        searchResultsViewController?.response = response
        NSNotificationCenter.defaultCenter().postNotificationName(CollapseKeyboardEvent, object: self)
    }
    
    func searchViewModelDidReceiveAutocompleteSuggestions(searchViewModel: SearchViewModel, suggestions: [[String: AnyObject]]?) {
        searchSuggestionsViewController?.suggestions = suggestions
    }
    
    // MARK: SearchSuggestionsViewControllerDelegate
    func searchSuggestionViewControllerDidTapSuggestion(viewController: SearchSuggestionsViewController, suggestion: String) {
        searchBarView.textInput.text = suggestion
        textProcessor?.parseTextInCurrentDocumentProxy()
        submitSearchRequest()
    }
}
