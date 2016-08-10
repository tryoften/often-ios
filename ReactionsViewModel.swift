//
//  ReactionsViewModel.swift
//  Often
//
//  Created by Katelyn Findlay on 8/8/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Firebase

class ReactionsViewModel: BaseViewModel {
    weak var delegate: ReactionsViewModelDelegate?
    var reactions: [Category]
    var mediaItemGroups: [MediaItemGroup]
    var filteredGroups: [MediaItemGroup]
    var currentReaction: Category?
    
    init() {
        reactions = []
        filteredGroups = []
        mediaItemGroups = []
        super.init(baseRef: FIRDatabase.database().reference(), path: "categories")
    }
    
    func fetchReactionsForUser() {
        guard let packs = PacksService.defaultInstance.mediaItems as? [PackMediaItem] else {
            return
        }
        
        var gifs: [GifMediaItem] = []
        var quotes: [QuoteMediaItem] = []
        var images: [ImageMediaItem] = []
        mediaItemGroups = []
        reactions = []
        
        var unsortedReactions: [Category] = []
        
        for pack in packs {
            for item in pack.items {
                if let category = item.category {
                    if !unsortedReactions.contains(category) {
                        unsortedReactions.append(category)
                    }
                    
                    switch item.type {
                    case .Gif:
                        if let gif = item as? GifMediaItem {
                            gifs.append(gif)
                        }
                    case .Quote:
                        if let quote = item as? QuoteMediaItem {
                            quotes.append(quote)
                        }
                    case .Image:
                        if let image = item as? ImageMediaItem {
                            images.append(image)
                        }
                    default: break
                    }
                    
                }
            }
        }
        
        reactions = unsortedReactions.sort{$0.name < $1.name}
        
        if !gifs.isEmpty {
            let gifGroup = MediaItemGroup(dictionary: [
                "id": "gifs",
                "title": "Gifs",
                "type": "gif"
                ])
            gifGroup.items = gifs
            mediaItemGroups.append(gifGroup)
        }
        
        if !quotes.isEmpty {
            let quoteGroup = MediaItemGroup(dictionary: [
                "id": "quotes",
                "title": "Quotes",
                "type": "quote"
                ])
            quoteGroup.items = quotes
            mediaItemGroups.append(quoteGroup)
        }
        
        if !images.isEmpty {
            let imagesGroup = MediaItemGroup(dictionary: [
                "id": "images",
                "title": "Images",
                "type": "image"
                ])
            imagesGroup.items = images
            mediaItemGroups.append(imagesGroup)
        }
        
        
    }
    
    func generateFilteredGroups(reaction: Category) {
        currentReaction = reaction
        filteredGroups = filterItemsForReaction(reaction)
    }
    
    func filterItemsForReaction(reaction: Category) -> [MediaItemGroup] {
        guard let packs = PacksService.defaultInstance.mediaItems as? [PackMediaItem] else {
            return []
        }
                
        var gifs: [GifMediaItem] = []
        var quotes: [QuoteMediaItem] = []
        var images: [ImageMediaItem] = []
        
        for pack in packs {
            for item in pack.items {
                if let category = item.category {
                    if category == reaction {
                        switch item.type {
                        case .Gif:
                            if let gif = item as? GifMediaItem {
                                gifs.append(gif)
                            }
                        case .Quote:
                            if let quote = item as? QuoteMediaItem {
                                quotes.append(quote)
                            }
                        case .Image:
                            if let image = item as? ImageMediaItem {
                                images.append(image)
                            }
                        default: break
                        }
                    }
                }
            }
        }
        
        var groups: [MediaItemGroup] = []
        
        if !gifs.isEmpty {
            let gifGroup = MediaItemGroup(dictionary: [
                "id": "gifs",
                "title": "Gifs",
                "type": "gif"
                ])
            gifGroup.items = gifs
            groups.append(gifGroup)
        }
        
        if !quotes.isEmpty {
            let quoteGroup = MediaItemGroup(dictionary: [
                "id": "quotes",
                "title": "Quotes",
                "type": "quote"
                ])
            quoteGroup.items = quotes
            groups.append(quoteGroup)
        }
        
        if !images.isEmpty {
            let imagesGroup = MediaItemGroup(dictionary: [
                "id": "images",
                "title": "Images",
                "type": "image"
                ])
            imagesGroup.items = images
            groups.append(imagesGroup)
        }
        
        return groups
    }
    
}

protocol ReactionsViewModelDelegate: class {
    func reactionsViewModelDelegateDataDidLoad(viewModel: ReactionsViewModel, reactions: [Category]?)
}