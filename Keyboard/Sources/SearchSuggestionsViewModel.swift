//
//  SearchSuggestionsViewModel.swift
//  Often
//
//  Created by Luc Succes on 10/18/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//


/// View Model that handles sending search query for autocomplete suggestions from the search service
class SearchSuggestionsViewModel: SearchBaseViewModel {
    weak var suggestionsDelegate: SearchSuggestionsViewModelDelegate?
    var filtersRef: Firebase
    var filters: [Filter]
    var suggestions: [SearchSuggestion]?
    
    override init(base: Firebase) {
        filtersRef = base.childByAppendingPath("filters")
        filters = []

        super.init(base: base)
        
        filtersRef.observeEventType(.Value, withBlock: { snapshot in
            guard let data = snapshot.value as? [[String: AnyObject]] else {
                return
            }
            
            var filters = [Filter]()
            
            for item in data {
                if let filter = self.processSuggestionData(item) {
                    filters.append(filter)
                }
            }
            
            self.filters = filters
        })
    }

    func requestData() {
        let filter = SearchRequestFilter(type: "search-terms", value: "10")
        sendRequestForQuery(" ", type: .Autocomplete, filter: filter)
    }
    
    func checkFilterInQuery(query: String) -> Filter? {
        if query.isEmpty {
            return nil
        }
        
        let tokens = query.componentsSeparatedByString(" ")
        let firstToken = tokens[0]
        
        // check if first token is command call
        if firstToken.hasPrefix("#") {

            var filter: Filter? = nil
            for item in self.filters {
                if item.text == firstToken {
                    filter = item
                    break
                }
            }
            
            return filter
        }
        
        return nil
    }
    
    func processAutocompleteSuggestions(query: String, resultsData: [[String: AnyObject]]) {
        suggestions = []

        for resultData in resultsData {
            guard let options = resultData["options"] as? [ [String: AnyObject] ] else {
                continue
            }

            for option in options {
                if let suggestion = processSuggestionData(option) {
                    suggestions?.append(suggestion)
                }
            }
        }
        
        suggestionsDelegate?.searchSuggestionsViewModelDidReceiveSuggestions(self, suggestions: suggestions)
    }
    
    func processSuggestionData(option: [String: AnyObject]) -> SearchSuggestion? {
        guard let id = option["id"] as? String,
            let optionText = option["text"] as? String,
            let optionType = option["type"] as? String else {
                return nil
        }
        
        let suggestion = SearchSuggestion()
        suggestion.id = id
        suggestion.text = optionText
        
        if let type = SearchSuggestionType(rawValue: optionType) {
            suggestion.type = type
        }
        
        if let image = option["image"] as? String {
            suggestion.image = image
        }
        
        if let payload = option["payload"] as? [String: AnyObject],
            let resultsCount = payload["resultsCount"] as? Int {
                suggestion.resultsCount = resultsCount
        }
        
        return suggestion
    }
    
    override func responseDataReceived(data: [String : AnyObject]) {
        guard let _ = data["id"] as? String,
            let query = data["query"] as? [String: AnyObject],
            let queryText = query["text"] as? String,
            let _ = data["type"] as? String,
            let resultsData = data["results"] as? [ [String: AnyObject] ],
            let _ = currentRequest else {
                return
        }
        
        processAutocompleteSuggestions(queryText, resultsData: resultsData)
    }
    
}

protocol SearchSuggestionsViewModelDelegate: SearchViewModelDelegate {
    func searchSuggestionsViewModelDidReceiveSuggestions(searchSuggestionsViewModel: SearchSuggestionsViewModel, suggestions: [SearchSuggestion]?)
}