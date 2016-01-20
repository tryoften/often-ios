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

    var userState: UserState = .NonEmpty
    var hasSeenTwitter: Bool = true

    var shouldShowEmptyStateViewOrData: Bool {
       return !(userState == .NoTwitter || userState == .NoKeyboard) || hasSeenTwitter
    }

    private var filteredCollections: [MediaItemsCollectionType: [MediaItem]] /// collections with current filters applied

    var filters: [MediaType] {
        didSet {
            for (type, collection) in collections {
                filteredCollections[type] = applyFilters(collection)
            }
        }
    }

    init(baseRef: Firebase = Firebase(url: BaseURL)) {
        filteredCollections = [:]
        collectionEndpoints = [:]
        collections = [:]
        filters = []

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
                let filteredCollection = self.filteredMediaItemsForCollectionType(collectionType)
                self.delegate?.mediaLinksViewModelDidReceiveMediaItems(self, collectionType: collectionType, links: filteredCollection)
                completion?(true)
            }
        })
    }

    /// Reapplies filters on passed in collection and returns a list of filtered links
    func filteredMediaItemsForCollectionType(collectionType: MediaItemsCollectionType) -> [MediaItem] {
        filteredCollections[collectionType] = applyFilters(collections[collectionType] ?? [])
        return filteredCollections[collectionType] ?? []
    }

    func sectionHeaderTitleForCollectionType(collectionType: MediaItemsCollectionType) -> String {
        var headerTitle = ""
        let links = filteredMediaItemsForCollectionType(collectionType)
        if filters.isEmpty {
            headerTitle =  "\(links.count)" + " " + collectionType.rawValue
        } else {
            headerTitle =  "\(links.count)" + " \(filters[0].rawValue.uppercaseString)s"
        }

        return headerTitle
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

    private func applyFilters(links: [MediaItem]) -> [MediaItem] {
        if filters.isEmpty {
            return links
        }
        
        var filteredLinks: [MediaItem] = []
        for link in links {
            if filters.contains(link.type) {
                filteredLinks.append(link)
            }
        }
        
        return filteredLinks
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
    func mediaLinksViewModelDidReceiveMediaItems(mediaLinksViewModel: MediaItemsViewModel, collectionType: MediaItemsCollectionType, links: [MediaItem])
    func mediaLinksViewModelDidFailLoadingMediaItems(mediaLinksViewModel: MediaItemsViewModel, error: MediaItemsViewModelError)
}

