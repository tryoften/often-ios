//
//  SearchSuggestion.swift
//  Often
//
//  Created by Luc Succes on 10/20/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation


enum SearchSuggestionType: String {
    case Query = "query"
    case Filter = "filter"
}

class SearchSuggestion {
    var id: String = ""
    var title: String = ""
    var type: SearchSuggestionType = .Query
    var image: String?
    var resultsCount: Int?
}