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
    
    /// set of requests where the key is the query string
    var requests: [String: SearchRequest]
    
    /// set of responses keyed on query string
    var responses: [String: SearchResponse]
    
    var requestsRef: Firebase
    var responsesRef: Firebase
    
    var currentRequest: SearchRequest?
    var currentTime: NSDate
    
    var isDataLoaded: Bool
    
    init(base: Firebase) {
        requests = [:]
        responses = [:]
        
        requestsRef = base.childByAppendingPath("queue/tasks")
        responsesRef = base.childByAppendingPath("responses")
        
        currentTime = NSDate.new()
        
        isDataLoaded = false
    }
    
    func sendRequest(request: SearchRequest) {
        if !request.query.isEmpty {
            
            let utf8str = request.query.dataUsingEncoding(NSUTF8StringEncoding)
            let base64Encoded = utf8str!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            let requestId = base64Encoded
            let requestRef = requestsRef.childByAppendingPath(requestId)
            requestRef.setValue(request.toDictionary(requestId))

            responsesRef.childByAppendingPath(requestId).observeEventType(.Value, withBlock: { snapshot in
                if (self.currentRequest?.query != request.query) {
                    self.isDataLoaded = false
                }
                // TODO: only show the first result for now
                if self.isDataLoaded {
                    return
                }
                self.currentRequest = request
                
                println("\(snapshot.value)")
                if let data = snapshot.value as? [String: AnyObject],
                    let id = data["id"] as? String,
                    let resultsData = data["results"] as? [ [String: AnyObject] ],
                    let lastModified = data["time_modified"] as? NSTimeInterval {
                        var results = [SearchResult]()
                        
                        for resultData in resultsData {
                            if let provider = resultData["_index"] as? String,
                                let rawType = resultData["_type"] as? String,
                                let id = resultData["_id"] as? String,
                                let score = resultData["_score"] as? Double,
                                let source = SearchResultSource(rawValue: provider),
                                let type = SearchResultType(rawValue: rawType) {
                                    
                                    var result: SearchResult? = nil
                                    
                                    switch(type) {
                                    case .Article:
                                        result = ArticleSearchResult(data: resultData)
                                    case .Music:
                                        break
                                    case .Track:
                                        result = TrackSearchResult(resultData: resultData)
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
                                        }
                                        
                                        results.append(item)
                                    }
                            }
                        }
                        
                        if var response = self.responses[id] {
                            response.results = results
                            self.delegate?.searchViewModelDidReceiveResponse(self, response: response)
                        } else {
                            let response = SearchResponse(id: id, results: results, timeModified: NSDate(timeIntervalSince1970: lastModified))
                            self.responses[id] = response
                            self.delegate?.searchViewModelDidReceiveResponse(self, response: response)
                        }
                        self.isDataLoaded = true
                        
                }
            })
        }
    }
    
    
    
    func observeResponses() {
        responsesRef
            .queryEqualToValue("userId", childKey: "user")
            .queryEqualToValue(false, childKey: "processed")
            .observeEventType(.Value, withBlock: { snapshot in
            if let data = snapshot.value as? [String: AnyObject],
                let timestamp = data["timestamp"] as? NSTimeInterval {
                    
                    let publishedTime = NSDate(timeIntervalSince1970: timestamp)
                    if publishedTime.compare(self.currentTime) == .OrderedDescending {
                        let response = SearchResponse(id: snapshot.key, results: [], timeModified: publishedTime)
                        
                    }
            }
        })
    }
}

protocol SearchViewModelDelegate {
    func searchViewModelDidReceiveResponse(searchViewModel: SearchViewModel, response: SearchResponse)
}
