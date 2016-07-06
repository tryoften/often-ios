//
//  MediaItemsViewModel.swift
//  Often
//

import Foundation
import Firebase

enum MediaItemsViewModelError: ErrorType {
    case NoUser
    case FetchingCollectionDataFailed
}

/// fetches recents for current user and keeps them up to date
class MediaItemsViewModel: BaseViewModel {
    weak var delegate: MediaItemsViewModelDelegate?
    
    var mediaItems: [MediaItem]
    var mediaItemGroups: [MediaItemGroup]
    var filteredMediaItems: [MediaItem]
    var sectionIndex: [String: NSInteger?]

    internal var collectionEndpoint: FIRDatabaseReference
    private var collectionType: MediaItemsCollectionType
    
    var userState: UserState = .NonEmpty
    var hasSeenTwitter: Bool = true
    
    var shouldShowEmptyStateViewOrData: Bool {
        return !(userState == .NoTwitter || userState == .NoKeyboard) || hasSeenTwitter
    }
    
    init(baseRef: FIRDatabaseReference = FIRDatabase.database().reference(), collectionType aCollectionType: MediaItemsCollectionType) {
        collectionType = aCollectionType
        collectionEndpoint = baseRef.child(collectionType.rawValue)
        mediaItems = []
        mediaItemGroups = []
        filteredMediaItems = []
        sectionIndex = [:]

        super.init(baseRef: baseRef, path: nil)
    }
    
    func fetchCollection(completion: ((Bool) -> Void)? = nil) {
        collectionEndpoint.observeEventType(.Value, withBlock: { snapshot in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                self.isDataLoaded = true
                if let data = snapshot.value as? [String: AnyObject] {
                    self.mediaItems = self.processMediaItemsCollectionData(data)
                }

                let mediaItemGroups = self.generateMediaItemGroups()
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.mediaLinksViewModelDidCreateMediaItemGroups(self, collectionType: self.collectionType, groups: mediaItemGroups)
                    completion?(true)
                }
            }
        })
    }
    
    func generateMediaItemGroups() -> [MediaItemGroup] {
        return []
    }

    func mediaItemGroupItemsForIndex(index: Int) -> [MediaItem] {
        let groups = mediaItemGroups

        if index > groups.count {
            return []
        }

        if !groups.isEmpty {
            return groups[index].items
        }

        return []
    }
    
    func leftSectionHeaderTitle(index: Int) -> String {
        return sectionHeaderTitle()
    }
    
    func sectionHeaderTitle() -> String {
        var headerTitle = ""
        if !mediaItems.isEmpty {
            headerTitle =  "\(mediaItems.count)" + " " + collectionType.rawValue
        }
        
        return headerTitle
    }
    
    func rightSectionHeaderTitle(indexPath: NSIndexPath) -> String {
        return ""
    }

    func sectionForSectionIndexTitle(title: String) -> NSInteger? {
        guard let index = sectionIndex[title] else {
            return nil
        }

        return index
    }

    func sectionHeaderImageURL(indexPath: NSIndexPath) -> NSURL? {
        return nil
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
    case Packs = "packs"
    case Tracks = "tracks"
    case Lyrics = "lyrics"
    
    static let allValues = [Favorites, Recents, Packs]
}

protocol MediaItemsViewModelDelegate: class {
    func mediaLinksViewModelDidAuthUser(mediaLinksViewModel: MediaItemsViewModel, user: User)
    func mediaLinksViewModelDidCreateMediaItemGroups(mediaLinksViewModel: MediaItemsViewModel, collectionType: MediaItemsCollectionType, groups: [MediaItemGroup])
    func mediaLinksViewModelDidFailLoadingMediaItems(mediaLinksViewModel: MediaItemsViewModel, error: MediaItemsViewModelError)
}

