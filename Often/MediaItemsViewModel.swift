//
//  MediaItemsViewModel.swift
//  Often
//

import Foundation
import Firebase

enum MediaItemsViewModelError: ErrorProtocol {
    case noUser
    case fetchingCollectionDataFailed
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
    
    var userState: UserState = .nonEmpty
    var hasSeenTwitter: Bool = true
    
    var shouldShowEmptyStateViewOrData: Bool {
        return !(userState == .noTwitter || userState == .noKeyboard) || hasSeenTwitter
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
    
    func fetchCollection(_ completion: ((Bool) -> Void)? = nil) {
        collectionEndpoint.observe(.value, with: { snapshot in
            DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosBackground).async {
                self.isDataLoaded = true
                if let data = snapshot.value as? [String: AnyObject] {
                    self.mediaItems = self.processMediaItemsCollectionData(data)
                }

                let mediaItemGroups = self.generateMediaItemGroups()
                DispatchQueue.main.async {
                    self.delegate?.mediaLinksViewModelDidCreateMediaItemGroups(self, collectionType: self.collectionType, groups: mediaItemGroups)
                    completion?(true)
                }
            }
        })
    }
    
    func generateMediaItemGroups() -> [MediaItemGroup] {
        return []
    }

    func mediaItemGroupItemsForIndex(_ index: Int) -> [MediaItem] {
        let groups = mediaItemGroups

        if index > groups.count {
            return []
        }

        if !groups.isEmpty {
            return groups[index].items
        }

        return []
    }
    
    func leftSectionHeaderTitle(_ index: Int) -> String {
        return sectionHeaderTitle()
    }
    
    func sectionHeaderTitle() -> String {
        var headerTitle = ""
        if !mediaItems.isEmpty {
            headerTitle =  "\(mediaItems.count)" + " " + collectionType.rawValue
        }
        
        return headerTitle
    }
    
    func rightSectionHeaderTitle(_ indexPath: IndexPath) -> String {
        return ""
    }

    func sectionForSectionIndexTitle(_ title: String) -> NSInteger? {
        guard let index = sectionIndex[title] else {
            return nil
        }

        return index
    }

    func sectionHeaderImageURL(_ indexPath: IndexPath) -> URL? {
        return nil
    }
    
    private func processMediaItemsCollectionData(_ data: [String: AnyObject]) -> [MediaItem] {
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
    func mediaLinksViewModelDidAuthUser(_ mediaLinksViewModel: MediaItemsViewModel, user: User)
    func mediaLinksViewModelDidCreateMediaItemGroups(_ mediaLinksViewModel: MediaItemsViewModel, collectionType: MediaItemsCollectionType, groups: [MediaItemGroup])
    func mediaLinksViewModelDidFailLoadingMediaItems(_ mediaLinksViewModel: MediaItemsViewModel, error: MediaItemsViewModelError)
}

