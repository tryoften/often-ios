//
//  MediaItemsViewModel.swift
//  Often
//

import Foundation

enum MediaItemsViewModelError: ErrorType {
    case NoUser
    case FetchingCollectionDataFailed
}

/// fetches favorites and recent links for current user and keeps them up to date
/// also has methods to add/remove favorites
class MediaItemsViewModel: BaseViewModel {
    weak var delegate: MediaItemsViewModelDelegate?
    
    var collections: [MediaItemsCollectionType: [MediaItem]]
    var collectionEndpoints: [MediaItemsCollectionType: Firebase]
    var mediaItemGroups: [MediaItemGroup]
    
    var userState: UserState = .NonEmpty
    var hasSeenTwitter: Bool = true
    
    var shouldShowEmptyStateViewOrData: Bool {
        return !(userState == .NoTwitter || userState == .NoKeyboard) || hasSeenTwitter
    }
    
    init(baseRef: Firebase = Firebase(url: BaseURL)) {
        collectionEndpoints = [:]
        collections = [:]
        mediaItemGroups = []
        
        super.init(baseRef: baseRef, path: nil)
        
        do {
            try setupUser { inner in
                do {
                    let user = try inner()
                    
                    for type in MediaItemsCollectionType.allValues {
                        let endpoint = baseRef.childByAppendingPath("users/\(user.id)/\(type.rawValue.lowercaseString)")
                        self.collectionEndpoints[type] = endpoint
                    }
                    
                    self.didSetupUser()
                } catch let error {
                    print(error)
                }
            }
        } catch _ {
        }
    }
    
    func didSetupUser() {}
    
    func fetchAllData() throws {
        for type in MediaItemsCollectionType.allValues {
            try fetchCollection(type)
        }
    }
    
    func fetchCollection(collectionType: MediaItemsCollectionType, completion: ((Bool) -> Void)? = nil) throws {
        guard let ref = collectionEndpoints[collectionType] else {
            completion?(false)
            let error: MediaItemsViewModelError = .FetchingCollectionDataFailed
            delegate?.mediaLinksViewModelDidFailLoadingMediaItems(self, error: error)
            throw error
        }
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            dispatch_async(dispatch_get_main_queue()) {
                self.isDataLoaded = true
                if let data = snapshot.value as? [String: AnyObject] {
                    self.collections[collectionType] = self.processMediaItemsCollectionData(data)
                }
                
                let mediaItemGroups = self.generateMediaItemGroupsForCollectionType(collectionType)
                self.delegate?.mediaLinksViewModelDidCreateMediaItemGroups(self, collectionType: collectionType, groups: mediaItemGroups)
                completion?(true)
            }
        })
    }
    
    func generateMediaItemGroupsForCollectionType(collectionType: MediaItemsCollectionType) -> [MediaItemGroup] {
        if let collection = self.collections[collectionType] {
            return separateGroupByArtist(collectionType, items: collection)
        } else {
            return []
        }
    }
    
    func separateGroupByArtist(collectionType: MediaItemsCollectionType, items: [MediaItem]) -> [MediaItemGroup] {
        switch collectionType {
        case .Favorites:
            var groups: [String: MediaItemGroup] = [:]
            for item in items {
                guard let lyric = item as? LyricMediaItem,
                    let artistName = lyric.artist_name else {
                        continue
                }
                
                if let _ = groups[artistName] {
                    groups[artistName]!.items.append(item)
                } else {
                    let group = MediaItemGroup(dictionary: [
                        "title": artistName,
                        ])
                    group.items = [item]
                    groups[artistName] = group
                }
            }
            
            let sortedGroups = groups.values.sort({ $0.title < $1.title })
            for group in sortedGroups {
                group.items = sortLyricsByTrack(group.items)
            }
            return sortedGroups
        case .Recents:
            let group = MediaItemGroup(dictionary: [
                "id": "recents",
                "title": sectionHeaderTitle(collectionType),
                "type": "lyric"
                ])
            group.items = items
            return [group]
        default:
            return []
        }
    }
    
    func sortLyricsByTrack(groups: [MediaItem]) -> [MediaItem] {
        if let unsorted = groups as? [LyricMediaItem] {
            return unsorted.sort({ $0.track_title < $1.track_title })
        }
        return groups
    }
    
    func mediaItemGroupItemsForIndex(index: Int, collectionType: MediaItemsCollectionType) -> [MediaItem] {
        let groups = generateMediaItemGroupsForCollectionType(collectionType)
        if(!groups.isEmpty) {
            return groups[index].items
        }
        return []
    }
    
    func sectionHeaderTitle(collectionType: MediaItemsCollectionType) -> String {
        var headerTitle = ""
        
        if let links = collections[collectionType] {
            headerTitle =  "\(links.count)" + " " + collectionType.rawValue
        }
        
        return headerTitle
    }
    
    func sectionHeaderTitleForCollectionType(collectionType: MediaItemsCollectionType, isLeft: Bool, indexPath: NSIndexPath) -> String {
        return sectionHeaderTitle(collectionType)
    }
    
    func processMediaItemsCollectionData(data: [String: AnyObject]) -> [MediaItem] {
        var links: [MediaItem] = []
        var ids = [String]()
        
        for (id, item) in data {
            ids.append(id)
            if let dict = item as? NSDictionary, let link = MediaItem.mediaItemFromType(dict) {
                links.append(link)
            }
        }
        
        return links
    }
}

enum MediaItemsCollectionType: String {
    case Favorites = "favorites"
    case Recents = "recents"
    case Tracks = "tracks"
    case Lyrics = "lyrics"
    
    static let allValues = [Favorites, Recents]
}

protocol MediaItemsViewModelDelegate: class {
    func mediaLinksViewModelDidAuthUser(mediaLinksViewModel: MediaItemsViewModel, user: User)
    func mediaLinksViewModelDidCreateMediaItemGroups(mediaLinksViewModel: MediaItemsViewModel, collectionType: MediaItemsCollectionType, groups: [MediaItemGroup])
    func mediaLinksViewModelDidFailLoadingMediaItems(mediaLinksViewModel: MediaItemsViewModel, error: MediaItemsViewModelError)
}

