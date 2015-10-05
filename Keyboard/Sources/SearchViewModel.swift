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

        if let id = data["id"] as? String,
            let query = data["query"] as? String,
            let _ = data["autocomplete"] as? Bool,
            let resultsData = data["results"] as? [ [String: AnyObject] ],
            let request = currentRequest {
                
                if request.autocomplete {
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
                    
                    self.delegate?.searchViewModelDidReceiveAutocompleteSuggestions(self, suggestions: suggestions[query])
                    return
                } else {
                    var results = [SearchResult]()
                    
                    for resultData in resultsData {
                        if let result = self.processSearchResultData(resultData) {
                            results.append(result)
                        }
                    }
                    
                    let lastModified = (data["time_modified"] as? NSTimeInterval) ?? NSDate().timeIntervalSince1970

                    let response = SearchResponse(id: id, results: results, timeModified: NSDate(timeIntervalSince1970: lastModified))
                    
                    if let doneUpdating = data["doneUpdating"] as? Bool {
                        if doneUpdating {
                            self.currentResponseRef?.removeAllObservers()
                            self.currentRequest = nil
                            self.isDataLoaded = true
                            if NSThread.isMainThread() {
                                self.delegate?.searchViewModelDidReceiveResponse(self, response: response)

                            } else {
                                NSOperationQueue.mainQueue().addOperationWithBlock {
                                    self.delegate?.searchViewModelDidReceiveResponse(self, response: response)
                                }
                            }
                        }
                    }
                    
                    // We already have data so wait another 300ms before displaying in case more data comes in by then
                    delay(0.3) {
                        if (!self.isDataLoaded) {
                            self.delegate?.searchViewModelDidReceiveResponse(self, response: response)
                            self.isDataLoaded = true
                        }
                    }
                }
        }

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
    func searchViewModelDidReceiveResponse(searchViewModel: SearchViewModel, response: SearchResponse)
    func searchViewModelDidReceiveAutocompleteSuggestions(searchViewModel: SearchViewModel, suggestions: [[String: AnyObject]]?)
}
