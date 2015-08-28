//
//  SearchRequest.swift
//  Often
//
//  Created by Luc Succes on 8/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

struct SearchRequest {
    var id : String
    var query: String
    var userId: String
    var timestamp: NSTimeInterval
    var isFulfilled: Bool = false
    
    func toDictionary(myId:String) -> [String: String] {
        return [
            "id": myId,
            "query": query,
            "user": userId,
            "time_made": "\(timestamp)"
        ]
    }
}
