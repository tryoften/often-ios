//
//  PackSubscription.swift
//  Often
//
//  Created by Luc Succes on 4/6/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

enum PackSubscriptionType: String {
    case Free = "free"
    case Premium = "premium"
}

class PackSubscription {
    let id: String
    let userId: String
    let packId: String
    let subscriptionType: PackSubscriptionType
    let timeSubscribed: Date?

    init(data: NSDictionary) {
        if let id = data["id"] as? String {
            self.id = id
        } else {
            self.id = ""
        }

        if let userId = data["userId"] as? String {
            self.userId = userId
        } else {
            self.userId = ""
        }

        if let packId = data["packId"] as? String {
            self.packId = packId
        } else {
            self.packId = ""
        }

        if let typeString = data["subscriptionType"] as? String,
            let type = PackSubscriptionType(rawValue: typeString) {
            subscriptionType = type
        } else {
            subscriptionType = .Free
        }

        if let timestamp = data["timeSubscribed"] as? TimeInterval {
            timeSubscribed = Date(timeIntervalSince1970: timestamp)
        } else {
            timeSubscribed = nil
        }
    }
}
