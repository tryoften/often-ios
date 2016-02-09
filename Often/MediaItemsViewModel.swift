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
    private var collectionEndpoints: [MediaItemsCollectionType: Firebase]
    private var mediaItemGroups: [MediaItemGroup]
    private var mediaItems: [MediaItem]
    private var sectionIndex: [String: NSInteger?]
    
    var userState: UserState = .NonEmpty
    var hasSeenTwitter: Bool = true
    
    var shouldShowEmptyStateViewOrData: Bool {
        return !(userState == .NoTwitter || userState == .NoKeyboard) || hasSeenTwitter
    }
    
    init(baseRef: Firebase = Firebase(url: BaseURL)) {
        collectionEndpoints = [:]
        collections = [:]
        mediaItemGroups = []
        mediaItems = []
        sectionIndex = [:]

        super.init(baseRef: baseRef, path: nil)

        if let userId = sessionManagerFlags.userId  {
            for type in MediaItemsCollectionType.allValues {
                let endpoint = baseRef.childByAppendingPath("users/\(userId)/\(type.rawValue.lowercaseString)")
                self.collectionEndpoints[type] = endpoint
            }
        }

        do {
            try setupUser { inner in
                self.didSetupUser()
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
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                self.isDataLoaded = true
                if let data = snapshot.value as? [String: AnyObject] {
                    self.collections[collectionType] = self.processMediaItemsCollectionData(data)
                }
                
                let mediaItemGroups = self.generateMediaItemGroupsForCollectionType(collectionType)
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.mediaLinksViewModelDidCreateMediaItemGroups(self, collectionType: collectionType, groups: mediaItemGroups)
                    completion?(true)
                }
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
            // TODO: use actual comparison between mediaItems and new items collection
            if mediaItems.count != items.count {
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
                
                mediaItemGroups = groups.values.sort({ $0.title < $1.title })
                for group in mediaItemGroups {
                    group.items = sortLyricsByTrack(group.items)
                }
                indexSectionHeaderTitles(mediaItemGroups)
            }
            return mediaItemGroups
        case .Recents:
            let group = MediaItemGroup(dictionary: [
                "id": "recents",
                "title": sectionHeaderTitle(collectionType),
                "type": "lyric"
                ])
            group.items = items.sort({ (l, r) in
                if let d1 = l.created, let d2 = r.created {
                    return d1.compare(d2) == .OrderedDescending
                }
                return false
            })
            return [group]
        default:
            return []
        }
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
        if isLeft {
            return sectionHeaderTitle(collectionType)
        }
        return ""
    }

    func sectionForSectionIndexTitle(title: String) -> NSInteger? {
        guard let index = sectionIndex[title] else {
            return nil
        }

        return index
    }

    func sectionHeaderImageURL(collectionType: MediaItemsCollectionType, index: Int) -> NSURL? {
        return nil
    }

    private func sortLyricsByTrack(groups: [MediaItem]) -> [MediaItem] {
        if let unsorted = groups as? [LyricMediaItem] {
            return unsorted.sort({ $0.track_title < $1.track_title })
        }
        return groups
    }

    private func indexSectionHeaderTitles(groups: [MediaItemGroup]) {
        sectionIndex = [:]

        for indexTitle in AlphabeticalSidebarIndexTitles {
            sectionIndex[indexTitle] = nil
        }

        for i in 0..<groups.count {
            guard let artistLyric = groups[i].items.first as? LyricMediaItem, let character = artistLyric.artist_name?.characters.first else {
                return
            }

            let letterChar = Letter(rawValue: character)
            let numberChar = Digit(rawValue: character)

            if let char = letterChar {
                if sectionIndex[String(char)] == nil {
                    sectionIndex[String(char)] = i
                }
            }

            if let _ = numberChar {
                if sectionIndex["#"] == nil {
                    sectionIndex["#"] = i
                }
            }

        }
    }
    
    private func processMediaItemsCollectionData(data: [String: AnyObject]) -> [MediaItem] {
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

