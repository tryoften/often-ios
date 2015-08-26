//
//  SearchRequest.swift
//  Often
//
//  Created by Luc Succes on 8/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

struct SearchRequest {
    var query: String
    var userId: String
    var timestamp: NSTimeInterval
    var isFulfilled: Bool = false
    
    func toDictionary() -> [String: String] {
        return [
            "query": query,
            "user": userId,
            "timestamp": "\(timestamp)"
        ]
    }
}
