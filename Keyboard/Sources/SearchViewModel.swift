//
//  SearchViewModel.swift
//  Often
//
//  Created by Luc Succes on 8/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class SearchViewModel: SearchBaseViewModel {
    var groups: [MediaItemGroup]

    override init(base: Firebase) {
        groups = []
        super.init(base: base)
    }
    
    override func responseDataReceived(data: [String: AnyObject]) {
        hasReceivedResponse = true

        guard let id = data["id"] as? String,
            let query = data["query"] as? [String: AnyObject],
            let queryText = query["text"] as? String,
            let type = data["type"] as? String,
            let resultsData = data["results"] as? [ [String: AnyObject] ],
            let _ = currentRequest else {
                return
        }
        
        var results = [MediaItem]()
        
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
            print("SearchViewModel: response to query (\(queryText)) changed")
        } else {
            print("SearchViewModel: response to query (\(queryText)) is the same as previous")
        }
        
        currentResponse = response
        
        if let doneUpdating = data["doneUpdating"] as? Bool {
            if doneUpdating {
                print("doneUpdating")
                self.currentResponseRef?.removeAllObservers()
                self.currentRequest = nil
            }
        }
        self.isDataLoaded = true
        self.delegate?.searchViewModelDidReceiveResponse(self, response: response, responseChanged: responseChanged)

    }
    
    func processSearchResultData(resultData: [String: AnyObject]) -> MediaItem? {
        if let data = resultData as? NSDictionary {
            return MediaItem.mediaItemFromType(data)
        }
        return nil
    }
}


