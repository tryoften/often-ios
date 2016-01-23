//
//  SearchBaseViewModel.swift
//  Often
//
//  Created by Luc Succes on 10/19/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class SearchBaseViewModel {
    weak var delegate: SearchViewModelDelegate?
    
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
    
    func sendRequestForQuery(query: String, type: SearchRequestType = .Search, filter: SearchRequestFilter? = nil) -> SearchRequest {
        let idHash = SearchRequest.idFromQuery(query)
        let id = type == .Autocomplete ? "autocomplete:" + idHash : idHash
        
        var userId: String = "anon"
        if let uId = SessionManagerFlags.defaultManagerFlags.userId {
            userId = uId
        }

        SEGAnalytics.sharedAnalytics().track("Sent Query", properties: [
            "query": query,
            "type": type.rawValue,
            "userId": userId
        ])

        let request = SearchRequest(id: id, query: query, userId: userId,
            timestamp: NSDate().timeIntervalSince1970 * 1000,
            isFulfilled: false,
            filter: filter,
            type: type)

        sendRequest(request)
        return request
    }
    
    func responseDataReceived(data: [String: AnyObject]) {
    }
}

protocol SearchViewModelDelegate: class {
    /*
    sent when a response for a request is received, may be called multiple times for a given query
    :param: searchViewModel view model handling the search requests/responses
    :param: response the response object containing the results
    :param: responseChanged whether this response is different from a previous one
    */
    func searchViewModelDidReceiveResponse(searchViewModel: SearchViewModel, response: SearchResponse, responseChanged: Bool)
}