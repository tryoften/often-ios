//
//  OFTNAnalytics.swift
//  Often
//
//  Created by Kervins Valcourt on 2/9/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

struct AnalyticsProperties {
    var event: String
    var className: String
    var method: String
    var source: String
    var userID: String
    var eventID: String
    var deviceType: String
    var systemVersion: String

    init(eventName: String, classFile: String = #file, methodName: String = #function) {
        event = eventName
        method = methodName
        className = fileNameFromFilepath(classFile)
        deviceType = Diagnostics.platformString().desciption
        systemVersion = UIDevice.currentDevice().systemVersion
        userID = ""
        source = "App"
        
    #if KEYBOARD
        source = "Keyboard"
    #endif

        if let userID = SessionManagerFlags.defaultManagerFlags.userId {
            self.userID = userID
        }

        let eventIDString = eventName.stringByReplacingOccurrencesOfString(" ", withString: "_", options: .LiteralSearch, range: nil)

        eventID = eventIDString.lowercaseString
    }

    func toDictionary() -> [String: AnyObject] {
        return ["class_name": className,
            "method": method,
            "source": source,
            "user_id": userID,
            "event_id": eventID,
            "device_type": deviceType,
            "os_verion": systemVersion
        ]
    }
}

func fileNameFromFilepath(filepath: String) -> String {
    if let url = NSURL(string: filepath), let pathComponent = url.lastPathComponent {
        return (pathComponent as NSString).stringByDeletingPathExtension
    }
    return ""
}

struct AnalyticsEvent {
    static var sentQuery = "Sent Query"
    static var insertedLyric = "Inserted Lyric"
    static var removedLyric = "Removed Lyric"
    static var login = "Login"
    static var logout = "Logout"
    static var favorited = "Favorited"
    static var unfavorited = "Unfavorited"
    static var navigate = "Navigate"
    static var addRecent = "Add to Recent"
}

class AnalyticsAdditonalProperties: NSDictionary {

    class func navigate(to: String, itemID: String, itemIndex: String, itemType: String) -> NSDictionary {
        return [
            "navigate": to,
            "item_id": itemID,
            "item_index": itemIndex
        ]
    }

    class func mediaItem(mediaItemDictionary: [String: AnyObject]) -> NSDictionary {
        return [
            "media_item": mediaItemDictionary,
        ]
    }

    class func sendQuery(query: String, type: String) -> NSDictionary {
        return [
            "query": query,
            "type": type
        ]
    }
}

class Analytics: SEGAnalytics {

    func track(properties: AnalyticsProperties) {
        track(properties.event, properties: properties.toDictionary() as [NSObject : AnyObject])
    }

    func track(properties: AnalyticsProperties, additionalProperties: NSDictionary) {
        var allProperties = properties.toDictionary()

        for (key, value) in additionalProperties {
            if let key = key as? String {
                allProperties[key] = value
            }
        }

        track(properties.event, properties: allProperties as [NSObject : AnyObject])
    }


}