//
//  SearchBarController.swift
//  Surf
//
//  Created by Luc Succes on 7/19/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import UIKit

class SearchBarController: UIViewController, UITextFieldDelegate {
    var viewModel: SearchViewModel
    var searchBar: SearchBar
    var suggestionsViewModel: SearchSuggestionsViewModel?

    weak var textProcessor: TextProcessingManager? {
        didSet {
            primaryTextDocumentProxy = textProcessor?.currentProxy

            if let textProcessor = textProcessor {
                textProcessor.proxies["search"] = searchBar.textInput
            }
        }
    }
    var filter: Filter?
    var primaryTextDocumentProxy: UITextDocumentProxy?
    var autocompleteTimer: NSTimer?

//    var isNewSearch: Bool = false

    init(viewModel aViewModel: SearchViewModel, suggestionsViewModel aSuggestionsViewModel: SearchSuggestionsViewModel) {
        viewModel = aViewModel
        suggestionsViewModel = aSuggestionsViewModel

        searchBar = SearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = searchBar
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.textInput.placeholder = searchBar.textInput.placeholderText

        let center = NSNotificationCenter.defaultCenter()
        
        center.addObserver(self, selector: "resetSearchBar", name: KeyboardResetSearchBar, object: nil)
//        center.addObserver(self, selector: "didTapEnterButton:", name: KeyboardEnterKeyTappedEvent, object: nil)
        center.addObserver(self, selector: "keyboardDidRestore", name: RestoreKeyboardEvent, object: nil)

        searchBar.textInput.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged)
        searchBar.textInput.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: .EditingDidBegin)
        searchBar.textInput.addTarget(self, action: "textFieldDidEndEditing:", forControlEvents: .EditingDidEnd)
        searchBar.shareButton.addTarget(self, action: "didTapShareButton", forControlEvents: .TouchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

        NSNotificationCenter.defaultCenter().postNotificationName(ResizeKeyboardEvent, object: self, userInfo: [
            "height": 0,
            "hideToggleBar": true
        ])
        NSNotificationCenter.defaultCenter().postNotificationName(CollapseKeyboardEvent, object: nil)
    }
    
    func didTapShareButton() {
        if let shareText = PFConfig.currentConfig().objectForKey("shareText") as? String {
            textProcessor?.insertText(shareText)
        } else {
            textProcessor?.insertText("Download Often at oftn.me/app")
        }
    }
    
    func scheduleAutocompleteRequestTimer() {
        autocompleteTimer?.invalidate()
        autocompleteTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "requestAutocompleteSuggestions", userInfo: nil, repeats: false)
    }
    
    func requestAutocompleteSuggestions() {
        let query = searchBar.textInput.text
        
        if query.isEmpty {
            suggestionsViewModel?.sendRequestForQuery("#top-searches:10", autocomplete: true)
        } else if query == "#" {
            suggestionsViewModel?.sendRequestForQuery("#filters-list", autocomplete: true)
        } else {
            suggestionsViewModel?.sendRequestForQuery(query, autocomplete: true)
        }
    }
    
    func keyboardDidRestore() {
//        searchResultsViewController?.response = nil
//        searchResultsContainerView?.hidden = true
    }
    
    func didTapProviderButton(button: ServiceProviderSearchBarButton?) {
        resetSearchBar()
    }
    
    func showNoResultsEmptyState() {
//        searchResultsViewController?.updateEmptySetVisible(true, animated: true)
    }

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
    }
    
    func textFieldDidChange() {
        textProcessor?.parseTextInCurrentDocumentProxy()
//        searchSuggestionsViewController.tableView.setContentOffset(CGPointZero, animated: true)

        if viewModel.hasReceivedResponse == true {
            scheduleAutocompleteRequestTimer()
//            isNewSearch = true
//            searchResultsContainerView?.hidden = true
            NSNotificationCenter.defaultCenter().postNotificationName(ToggleButtonKeyboardEvent, object: nil, userInfo: ["hide": true])
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textProcessor?.setCurrentProxyWithId("default")
//        searchSuggestionsViewController.tableView.setContentOffset(CGPointZero, animated: true)
        searchBar.textInput.updateButtonPositions()
    }
    
    func setFilter(filter: Filter) {
        self.filter = filter
        searchBar.setFilterButton(filter)
        suggestionsViewModel?.sendRequestForQuery("#top-searches:10", autocomplete: true)
    }

    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        searchBar.textInput.selected = searchBar.textInput.selected
    }
    

}
