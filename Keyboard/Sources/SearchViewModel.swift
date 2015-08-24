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
    
    var currentTime: NSDate
    
    init(base: Firebase) {
        requests = [:]
        responses = [:]
        
        requestsRef = base.childByAppendingPath("requests")
        responsesRef = base.childByAppendingPath("responses")
        
        currentTime = NSDate.new()
    }
    
    func sendRequest(request: SearchRequest) {
        if !request.query.isEmpty {
            let requestRef = requestsRef.childByAutoId()
            let requestId = requestRef.key
            
            requestRef.setValue(request.toDictionary())
            responsesRef.childByAppendingPath(requestId).observeEventType(.Value, withBlock: { snapshot in
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
                                let source = resultData["source"] as? [String: String],
                                let type = SearchResultType(rawValue: rawType) {
                                    
                                    var result: SearchResult? = nil
                                    
                                    switch(type) {
                                    case .Article:
                                        if let title = resultData["title"] as? String,
                                            let author = resultData["author"] as? String,
                                            let date = resultData["date"] as? String,
                                            let description = resultData["description"] as? String,
                                            let link = resultData["link"] as? String {
                                        result = ArticleSearchResult(id: id, title: title, date: NSDate(), link: link, score: score)
                                        }
                                    case .Music:
                                        break
                                    case .Album:
                                        if let name = resultData["name"] as? String,
                                            let imageLarge = resultData["image_large"] as? String {
                                            
                                        }
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
                                        if let sourceId = source["id"] {
                                            item.sourceId = sourceId
                                        }
                                        
                                        if let sourceName = source["name"] {
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
