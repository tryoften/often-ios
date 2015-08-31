//
//  SearchRequest.swift
//  Often
//
//  Created by Luc Succes on 8/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

struct SearchRequest {
    var id: String
    var query: String
    var userId: String
    var timestamp: NSTimeInterval
    var isFulfilled: Bool = false
    
    func toDictionary() -> [String: String] {
        return [
            "id": id,
            "query": query,
            "user": userId,
            "time_made": "\(timestamp)"
        ]
    }
    
    static func idFromQuery(query: String) -> String {
        let utf8str = query.dataUsingEncoding(NSUTF8StringEncoding)
        let base64Encoded = utf8str!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        return base64Encoded
    }
}
