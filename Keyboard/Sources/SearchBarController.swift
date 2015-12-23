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
    var filter: Filter?
    var autocompleteTimer: NSTimer?

    required init(viewModel aViewModel: SearchViewModel, suggestionsViewModel aSuggestionsViewModel: SearchSuggestionsViewModel, SearchTextFieldClass: SearchTextField.Type) {
        viewModel = aViewModel
        suggestionsViewModel = aSuggestionsViewModel

        searchBar = SearchBar(SearchTextFieldClass: SearchTextFieldClass)
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

        searchBar.textInput.clear()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first where touch.view == searchBar {
            searchBar.textInput.becomeFirstResponder()
        }
    }
    
    func reset() {
        filter = nil
        searchBar.reset()

        NSNotificationCenter.defaultCenter().postNotificationName(CollapseKeyboardEvent, object: nil)
    }

    func scheduleAutocompleteRequestTimer() {
        autocompleteTimer?.invalidate()
        autocompleteTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "requestAutocompleteSuggestions", userInfo: nil, repeats: false)
    }
    
    func requestAutocompleteSuggestions() {
        let query = searchBar.textInput.text
        
        if query!.isEmpty {
            suggestionsViewModel?.sendRequestForQuery("#top-searches:10", autocomplete: true)
        } else if query == "#" {
            suggestionsViewModel?.sendRequestForQuery("#filters-list", autocomplete: true)
        } else {
            suggestionsViewModel?.sendRequestForQuery(query!, autocomplete: true)
        }
    }


    func textFieldDidEndEditingOnExit() {
        reset()
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
