//
//  MediaItemsGroup.swift
//  Often
//
//  Created by Luc Succes on 1/7/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//
//  swiftlint:disable force_cast

import Foundation

class MediaItemGroup: Equatable {
    var id: String?
    private var originalItems: [MediaItem] = []
    var items: [MediaItem] {
        get {
            guard  let _ = currentFilterCategory else {
                return originalItems
            }
                return filteredItems

        }
        
        set {
            originalItems = newValue
        }
   }
    private(set) var currentFilterCategory: Category?
    var score: Int?
    var title: String?
    var type: MediaType = .Other
    private var filteredItems: [MediaItem] = []
    
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
        self.items = []
        id = dictionary["id"] as? String
        if let items = dictionary["items"] as? NSArray {
            self.items = MediaItem.modelsFromDictionaryArray(items)
        }
        
        if let items = dictionary["results"] as? NSArray {
            self.items = MediaItem.modelsFromDictionaryArray(items)
        }
        
        score = dictionary["score"] as? Int
        
        if let typeStr = dictionary["type"] as? String, let type = MediaType(rawValue: typeStr) {
            self.type = type
        }
        
        if let title = dictionary["title"] as? String {
            self.title = title
        } else {
            self.title = "\(items.count) \(type)s"
        }
        
    }
    
    func filterMediaItems(category: Category) {
        filteredItems = []
        currentFilterCategory = category
        
        for item in originalItems {
            // Check for filters, if present applies them
            if shouldFilterMediaItem(category, item: item) {
                continue
            }
            
            filteredItems.append(item)
        }
    }
    
    
    private func shouldFilterMediaItem(category: Category, item: MediaItem) -> Bool {
        guard let itemCategory = item.category else {
            if category.id == Category.all.id {
                return false
            }
            return true
        }


        if category.id == Category.all.id {
            return false
        }
        
        if itemCategory.id != category.id {
            return true
        }
        
        
        return false
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

func ==(lhs: MediaItemGroup, rhs: MediaItemGroup) -> Bool {
    return lhs.items == rhs.items
}