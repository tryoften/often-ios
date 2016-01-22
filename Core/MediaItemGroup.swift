//
//  MediaItemsGroup.swift
//  Often
//
//  Created by Luc Succes on 1/7/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//
//  swiftlint:disable force_cast

import Foundation

class MediaItemGroup {
    var id: String?
    var items: [MediaItem] = []
    var score: Int?
    var title: String?
    var type: MediaType = .Other

    /**
     Returns an array of models based on given dictionary.

     Sample usage:
     let groups = MediaItemGroup.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

     - parameter array:  NSArray from JSON dictionary.
     - returns: Array of MediaItemGroup Instances.
     */
    class func modelsFromDictionaryArray(array: NSArray) -> [MediaItemGroup] {
        var models: [MediaItemGroup] = []
        for item in array {
            if let data = item as? NSDictionary {
                models.append(MediaItemGroup(dictionary: data))
            }
        }
        return models
    }

    /**
     Constructs the object based on the given dictionary.

     Sample usage:
     let group = MediaItemGroup(someDictionaryFromJSON)

     - parameter dictionary:  NSDictionary from JSON.
     - returns: MediaItemGroup Instance.
     */
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? String
        if let items = dictionary["items"] as? NSArray {
            self.items = MediaItem.modelsFromDictionaryArray(items)
        }
        score = dictionary["score"] as? Int
        title = dictionary["title"] as? String

        if let typeStr = dictionary["type"] as? String, let type = MediaType(rawValue: typeStr) {
            self.type = type
        }
     }

    /**
     Returns the dictionary representation for the current instance.

     - returns: NSDictionary.
     */
    func toDictionary() -> NSDictionary {
        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.score, forKey: "score")
        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.type.rawValue, forKey: "type")
        
        return dictionary
    }
}