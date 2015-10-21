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
    
    func processAutocompleteSuggestions(query: String, resultsData: [[String: AnyObject]]) {
        var suggestions = [SearchSuggestion]()
        
        for resultData in resultsData {
            if let options = resultData["options"] as? [ [String: AnyObject] ] {
                
                    for option in options {
                        if  let id = option["id"] as? String,
                            let optionText = option["text"] as? String,
                            let optionType = option["type"] as? String {
                                
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

                                suggestions.append(suggestion)
                        }
                    }
            }
        }
        
        suggestionsDelegate?.searchSuggestionsViewModelDidReceiveSuggestions(self, suggestions: suggestions)
    }
    
    override func responseDataReceived(data: [String : AnyObject]) {
        guard let _ = data["id"] as? String,
            let query = data["query"] as? String,
            let _ = data["autocomplete"] as? Bool,
            let resultsData = data["results"] as? [ [String: AnyObject] ],
            let _ = currentRequest else {
                return
        }
        
        processAutocompleteSuggestions(query, resultsData: resultsData)
    }
    
}

protocol SearchSuggestionsViewModelDelegate: SearchViewModelDelegate {
    func searchSuggestionsViewModelDidReceiveSuggestions(searchSuggestionsViewModel: SearchSuggestionsViewModel, suggestions: [SearchSuggestion]?)
}