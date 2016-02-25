//
//  MediaItem.swift
//  Often
//
//  Created by Luc Succes on 8/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//
//  swiftlint:disable force_cast

import Foundation

class MediaItem: Equatable {
    var id: String = ""
    var type: MediaType = .Other
    var score: Double = 0.0
    var source: MediaItemSource = .Unknown
    var sourceName: String {
        return getNameForSource()
    }
    var smallImage: String?
    var mediumImage: String?
    var largeImage: String?
    var created: NSDate?
    var data: NSDictionary = [:]

    class func mediaItemFromType(data: NSDictionary) -> MediaItem? {
        guard let typeString = data["type"] as? String,
            let type = MediaType(rawValue: typeString),
            let MediaItemClass = MediaItemTypes[type] else {
                return nil
        }

        return MediaItemClass.init(data: data)
    }

    /**
     Returns an array of models based on given dictionary.

     Sample usage:
     let groups = MediaItemGroup.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

     - parameter array:  NSArray from JSON dictionary.
     - returns: Array of MediaItemGroup Instances.
     */
    class func modelsFromDictionaryArray(array: NSArray) -> [MediaItem] {
        var models: [MediaItem] = []
        for item in array {
            if let item = item as? NSDictionary, let mediaItem = MediaItem.mediaItemFromType(item) {
                models.append(mediaItem)
            }
        }
        return models
    }
    
    required init(data: NSDictionary) {
        self.data = data
        
        if let id = data["id"] as? String {
            self.id = id
        }

        if let typeStr = data["type"] as? String, let type = MediaType(rawValue: typeStr) {
            self.type = type
        }

        if let score = data["score"] as? Double {
            self.score = score
        }

        if let sourceStr = data["source"] as? String, let source = MediaItemSource(rawValue: sourceStr) {
            self.source = source
        }

        if let time_added = data["time_added"] as? Double {
            let date = NSDate(timeIntervalSince1970: time_added / 1000.0)
            self.created = date
        }
    }

    func iconImageForSource() -> UIImage? {
        return UIImage(named: source.rawValue)
    }
    
    func getInsertableText() -> String {
        return ""
    }

    func toDictionary() -> [String: AnyObject] {
        var data: [String: AnyObject] = [
            "_id": id,
            "id": id,
            "type": type.rawValue,
            "source": source.rawValue
        ]
        
        if let time = created {
            data["time_added"] = time
        }
        
        for (key, value) in self.data {
            data[key as! String] = value
        }
        
        return data
    }

    /**
     Path to a subcollection.
     e.g. 
     TrackMediaItem -> "lyrics"
     ArtistMediaItem -> "tracks"

     - returns:
     */
    func subCollectionType() -> MediaItemsCollectionType? {
        return nil
    }
}

func ==(lhs: MediaItem, rhs: MediaItem) -> Bool {
    return lhs.id == rhs.id
}