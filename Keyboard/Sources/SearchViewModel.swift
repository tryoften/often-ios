//
//  SearchViewModel.swift
//  Often
//
//  Created by Luc Succes on 8/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class SearchViewModel: NSObject {
    var delegate: SearchViewModelDelegate?
    
    var requestsRef: Firebase
    var responsesRef: Firebase
    
    var currentRequest: SearchRequest?
    var currentResponseRef: Firebase?
    var currentResponse: SearchResponse?
    
    var isDataLoaded: Bool
    var hasReceivedResponse: Bool
    
    init(base: Firebase) {    
        requestsRef = base.childByAppendingPath("queues/search/tasks")
        responsesRef = base.childByAppendingPath("responses")
        
        hasReceivedResponse = true
        isDataLoaded = false
    }
    
    func sendRequest(request: SearchRequest) {
        currentRequest = request
        isDataLoaded = false
        
        if !request.query.isEmpty {
            if currentResponseRef != nil {
                currentResponseRef?.removeAllObservers()
            }

            let requestRef = requestsRef.childByAppendingPath(request.id)
            requestRef.setValue(request.toDictionary())
            hasReceivedResponse = false
            
            let responseRef = responsesRef.childByAppendingPath(request.id)
            currentResponseRef = responseRef
            
            responseRef.observeEventType(.Value, withBlock: { snapshot in
                if (self.currentRequest?.id != snapshot.key) {
                    return
                }
                
                if let data = snapshot.value as? [String: AnyObject] {
                    self.responseDataReceived(data)
                }
            })
        }
    }
    
    func sendRequestForQuery(query: String, autocomplete: Bool) -> SearchRequest {
        let request = SearchRequest(id: SearchRequest.idFromQuery(query), query: query, userId: "anon", timestamp: NSDate().timeIntervalSince1970 * 1000, isFulfilled: false, autocomplete: autocomplete)
        sendRequest(request)
        return request
    }
    
    func responseDataReceived(data: [String: AnyObject]) {
        hasReceivedResponse = true

        guard let id = data["id"] as? String,
            let query = data["query"] as? String,
            let _ = data["autocomplete"] as? Bool,
            let resultsData = data["results"] as? [ [String: AnyObject] ],
            let request = currentRequest else {
                return
        }
        
        if request.autocomplete {
            processAutocompleteSuggestions(query, resultsData: resultsData)
            return
        } else {
            var results = [SearchResult]()
            
            for resultData in resultsData {
                if let result = processSearchResultData(resultData) {
                    results.append(result)
                }
            }
            
            var responseChanged = true
            
            let lastModified = (data["time_modified"] as? NSTimeInterval) ?? NSDate().timeIntervalSince1970
            let response = SearchResponse(id: id, results: results, timeModified: NSDate(timeIntervalSince1970: lastModified))
            
            // check if the response has different results than the previously received result set
            // if it is, let the view layer know
            if let currentResponse = currentResponse {
                if currentResponse == response {
                    responseChanged = false
                }
            }
            
            if responseChanged {
                print("SearchViewModel: response to query (\(query)) changed")
            } else {
                print("SearchViewModel: response to query (\(query)) is the same as previous")
            }
            
            currentResponse = response
            
            if let doneUpdating = data["doneUpdating"] as? Bool {
                if doneUpdating {
                    self.currentResponseRef?.removeAllObservers()
                    self.currentRequest = nil
                    self.isDataLoaded = true
                    if NSThread.isMainThread() {
                        self.delegate?.searchViewModelDidReceiveResponse(self, response: response, responseChanged: responseChanged)
                    } else {
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            self.delegate?.searchViewModelDidReceiveResponse(self, response: response, responseChanged: responseChanged)
                        }
                    }
                }
            }
            
            // We already have data so wait another 300ms before displaying in case more data comes in by then
            delay(0.3) {
                if (!self.isDataLoaded) {
                    self.delegate?.searchViewModelDidReceiveResponse(self, response: response, responseChanged: responseChanged)
                    self.isDataLoaded = true
                }
            }
        }

    }
    
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
        
        delegate?.searchViewModelDidReceiveAutocompleteSuggestions(self, suggestions: suggestions[query])
    }
    
    func processSearchResultData(resultData: [String: AnyObject]) -> SearchResult? {
        if let provider = resultData["_index"] as? String,
            let rawType = resultData["_type"] as? String,
            let _ = resultData["_id"] as? String,
            let _ = resultData["_score"] as? Double,
            let _ = SearchResultSource(rawValue: provider),
            let type = SearchResultType(rawValue: rawType) {
                
                var result: SearchResult? = nil
                
                switch(type) {
                case .Article:
                    result = ArticleSearchResult(data: resultData)
                case .Music:
                    break
                case .Track:
                    result = TrackSearchResult(data: resultData)
                case .Album:
                    break
                case .User:
                    break
                case .Video:
                    result = VideoSearchResult(data: resultData)
                    break
                case .Other:
                    break
                default:
                    break
                }
                
                
                if let item = result {
                    if let index = resultData["_index"] as? String,
                        let source = SearchResultSource(rawValue: index) {
                            item.source = source
                    } else {
                        item.source = .Unknown
                    }
                    
                    if let source = resultData["source"] as? [String: String],
                        let sourceName = source["name"] {
                            item.sourceName = sourceName
                    } else {
                        item.sourceName = item.getNameForSource()
                    }
                    return item
                }
        }
        return nil
    }
}

protocol SearchViewModelDelegate {
    /*
        sent when a response for a request is received, may be called multiple times for a given query
        :param: searchViewModel view model handling the search requests/responses
        :param: response the response object containing the results
        :param: responseChanged whether this response is different from a previous one
    */
    func searchViewModelDidReceiveResponse(searchViewModel: SearchViewModel, response: SearchResponse, responseChanged: Bool)
    func searchViewModelDidReceiveAutocompleteSuggestions(searchViewModel: SearchViewModel, suggestions: [[String: AnyObject]]?)
}
