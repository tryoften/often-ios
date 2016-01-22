//
//  SearchRequest.swift
//  Often
//
//  Created by Luc Succes on 8/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

struct SearchRequestFilter {
    var type: String
    var value: String

    func toDictionary() -> [String: AnyObject] {
        return [
            "type": type,
            "value": value
        ]
    }
}

enum SearchRequestType: String {
    case Search = "search"
    case Autocomplete = "autocomplete"
}

struct SearchRequest {
    var id: String
    var query: String
    var userId: String
    var timestamp: NSTimeInterval
    var isFulfilled: Bool = false
    var filter: SearchRequestFilter? = nil
    var type: SearchRequestType = .Search
    
    func toDictionary() -> [String: AnyObject] {
        var queryDict: [String: AnyObject] = [:]

        if let filter = filter {
            queryDict = [
                "text": query.lowercaseString,
                "filter": filter.toDictionary()
            ]
        } else {
            queryDict = [
                "text": query.lowercaseString
            ]
        }

        let dict: [String: AnyObject] = [
            "id": id,
            "user": userId,
            "time_made": "\(timestamp)",
            "query": queryDict,
            "type": type.rawValue
        ]

        return dict
    }
    
    static func idFromQuery(query: String) -> String {
        let utf8str = query.dataUsingEncoding(NSUTF8StringEncoding)
        let base64Encoded = utf8str!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        return base64Encoded
    }
}
