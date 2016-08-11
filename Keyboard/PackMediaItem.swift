//
//  PackMediaItem.swift
//  Often
//
//  Created by Katelyn Findlay on 3/29/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class PackMediaItem: MediaItem {
    var description: String?
    var pack_id: String?
    var name: String?
    var items_count: Int = 0
    var items: [MediaItem] = []
    var premium: Bool = false
    var price: Double = 0.0
    var categories: [Category] = []
    var availableMediaType: [MediaType: Int] = [:]
    var published: Bool = false
    var featured: Bool = false
    var publishedTime: NSDate = NSDate(timeIntervalSince1970: 0)
    var isFavorites: Bool = false
    var isRecents: Bool = false
    var shareLink: String?
    var isUpdated: Bool = false
    var isNew: Bool = false
    var backgroundColor: UIColor?
    var owner: NSDictionary?

    required init(data: NSDictionary) {
        super.init(data: data)
        
        if let description = data["description"] as? String {
            self.description = description
        }
        
        if let id = data["id"] as? String {
            self.pack_id = id
            self.shareLink = "oftn.at/k/\(id)"
        }

        if let name = data["name"] as? String {
            self.name = name
        }

        if let images = data["image"] as? NSDictionary,
            let small = images["small_url"] as? String {
            self.smallImageURL = NSURL(string: small)
        }

        if let images = data["image"] as? NSDictionary,
            let large = images["large_url"] as? String {
            self.largeImageURL = NSURL(string: large)
        }
        
        if let items = data["items"] as? NSArray,
            let itemsModel = MediaItem.modelsFromDictionaryArray(items) as? [MediaItem] {
            self.items = itemsModel

            for item in itemsModel {
                if let count = availableMediaType[item.type] {
                    availableMediaType[item.type] = count + 1
                } else {
                    availableMediaType[item.type] = 1
                }
            }
        }

        if let itemsCount = data["items_count"] as? Int {
            self.items_count = itemsCount
        } else {
            self.items_count = self.items.count
        }

        self.categories = [Category.all]
        
        if let items = data["categories"] as? NSDictionary {
            for category in Category.modelsFromDictionary(items) {
                self.categories.append(category)
            }
        }

        if let premium = data["premium"] as? Bool {
            self.premium = premium
        }
        
        if let price = data["price"] as? Double {
            self.price = price
        }

        if let published = data["published"] as? Bool {
            self.published = published
        }

        if let featured = data["featured"] as? Bool {
            self.featured = featured
        }

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        if let publishedTime = data["publishedTime"] as? String,
            let date = dateFormatter.dateFromString(publishedTime) {
            self.publishedTime = date
        }

        if let isRecents = data["isRecents"] as? Bool {
            self.isRecents = isRecents
        }

        if let isUpdated = data["isUpdated"] as? Bool {
            self.isUpdated = isUpdated
        }

        if let isNew = data["isNew"] as? Bool {
            self.isNew = isNew
        }

        if let isFavorites = data["isFavorites"] as? Bool {
            self.isFavorites = isFavorites
        }

        if let backgroundColor = data["backgroundColor"] as? String {
            self.backgroundColor = UIColor(fromHexString: backgroundColor)
        }

        if let owner = data["owner"] as? [String: AnyObject] {
            self.owner = owner
        }
    }

    func isUserPackOwner(user: User?) -> Bool {
        guard let ownerId = owner?["id"] as? String,
            let currentUserId = user?.id else {
                return false
        }

        return ownerId == currentUserId
    }

    func callToActionText() -> String {
        if premium {
            if price == 0.0 {
                return "Free"
            }

            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            return formatter.stringFromNumber(NSNumber(double: price))!
        }
        
        return "Download"
    }
    
    func getMediaItemGroups() -> [MediaItemGroup] {
        var gifs = [MediaItem]()
        var quotes = [MediaItem]()
        var images = [MediaItem]()
        
        for item in items {
            switch item.type {
            case .Gif:
                gifs.append(item)
            case .Quote, .Lyric:
                quotes.append(item)
            case .Image:
                images.append(item)
            default:
                continue
            }
        }
        
        let gifGroup = MediaItemGroup(dictionary: [
            "id": "gifs",
            "title": "Gifs",
            "type": MediaType.Gif.rawValue
        ])
        gifGroup.items = gifs
        
        let quoteGroup = MediaItemGroup(dictionary: [
            "id": "quotes",
            "title": "Quotes",
            "type": MediaType.Quote.rawValue
        ])
        quoteGroup.items = quotes

        let imageGroup = MediaItemGroup(dictionary: [
            "id": "images",
            "title": "Images",
            "type": MediaType.Image.rawValue
        ])
        imageGroup.items = images

        var groups = [MediaItemGroup]()
        
        if !gifGroup.items.isEmpty {
            groups.append(gifGroup)
        }
        
        if !quoteGroup.items.isEmpty {
            groups.append(quoteGroup)
        }

        if !imageGroup.items.isEmpty {
            groups.append(imageGroup)
        }
        
        return groups
    }
}