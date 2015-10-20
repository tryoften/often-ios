//
//  SearchViewModel.swift
//  Often
//
//  Created by Luc Succes on 8/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class SearchViewModel: SearchBaseViewModel {
    
    override func responseDataReceived(data: [String: AnyObject]) {
        hasReceivedResponse = true

        guard let id = data["id"] as? String,
            let query = data["query"] as? String,
            let _ = data["autocomplete"] as? Bool,
            let resultsData = data["results"] as? [ [String: AnyObject] ],
            let _ = currentRequest else {
                return
        }
        
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
                case .Track:
                    result = TrackSearchResult(data: resultData)
                case .Video:
                    result = VideoSearchResult(data: resultData)
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


