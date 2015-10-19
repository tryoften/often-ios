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
        var suggestions = [ String: [[String: AnyObject]] ]()
        
        for resultData in resultsData {
            if let text = resultData["text"] as? String,
                let options = resultData["options"] as? [ [String: AnyObject] ] {
                    var texts = [[String: AnyObject]]()
                    
                    for option in options {
                        if let optionText = option["text"] as? String {
                            var dict: [String: AnyObject] = [
                                "text": optionText
                            ]
                            
                            if let payload = option["payload"] as? [String: AnyObject],
                                let resultsCount = payload["resultsCount"] as? Int {
                                    dict["resultsCount"] = resultsCount
                            }
                            
                            texts.append(dict)
                        }
                    }
                    
                    suggestions[text] = texts
            }
        }
        
        suggestionsDelegate?.searchSuggestionsViewModelDidReceiveSuggestions(self, suggestions: suggestions[query])
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
    func searchSuggestionsViewModelDidReceiveSuggestions(searchSuggestionsViewModel: SearchSuggestionsViewModel, suggestions: [[String: AnyObject]]?)
}