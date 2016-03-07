//
//  SearchBarController.swift
//  Surf
//
//  Created by Luc Succes on 7/19/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import UIKit

class SearchBarController: UIViewController, UISearchBarDelegate {
    var viewModel: SearchViewModel
    var searchBar: SearchBar
    var suggestionsViewModel: SearchSuggestionsViewModel?
    var filter: Filter?
    var autocompleteTimer: NSTimer?

    required init(viewModel aViewModel: SearchViewModel, suggestionsViewModel aSuggestionsViewModel: SearchSuggestionsViewModel, SearchBarClass: SearchBar.Type) {
        viewModel = aViewModel
        suggestionsViewModel = aSuggestionsViewModel
        searchBar = SearchBarClass.init(frame: CGRectZero)
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        if let searchBar = searchBar as? UIView {
            view = searchBar
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.clear()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first where touch.view == searchBar as? UIView {
            searchBar.becomeFirstResponder()
        }
    }
    
    func reset() {
        filter = nil
    }

    func scheduleAutocompleteRequestTimer() {
        autocompleteTimer?.invalidate()
        autocompleteTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "requestAutocompleteSuggestions", userInfo: nil, repeats: false)
    }
    
    func requestAutocompleteSuggestions() {
        guard let query = searchBar.text else {
            return
        }
        
        if query.isEmpty {
            suggestionsViewModel?.requestData()
        } else {
            suggestionsViewModel?.sendRequestForQuery(query, type: .Autocomplete)
        }

    }

    func textFieldDidChange() {
        if viewModel.hasReceivedResponse == true {
            scheduleAutocompleteRequestTimer()
        }
    }

    func setFilter(filter: Filter) {
        self.filter = filter
        suggestionsViewModel?.requestData()
    }

    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        searchBar.selected = searchBar.selected
    }
}
