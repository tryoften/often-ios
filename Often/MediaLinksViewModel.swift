//
//  MediaLinksViewModel.swift
//  Often
//

import Foundation

enum MediaLinksViewModelError: ErrorType {
    case NoUser
    case FetchingCollectionDataFailed
}

/// fetches favorites and recent links for current user and keeps them up to date
/// also has methods to add/remove favorites
class MediaLinksViewModel {
    weak var delegate: MediaLinksViewModelDelegate?
    let sessionManagerFlags = SessionManagerFlags.defaultManagerFlags
    let baseRef: Firebase
    var currentUser: User?
    var collections: [MediaLinksCollectionType: [MediaLink]]
    var isDataLoaded: Bool

    private var userId: String
    private var userRef: Firebase?
    private(set) var ids: [String]
    private var filteredCollections: [MediaLinksCollectionType: [MediaLink]] /// collections with current filters applied
    private var collectionEndpoints: [MediaLinksCollectionType: Firebase]

    var filters: [MediaType] {
        didSet {
            for (type, collection) in collections {
                filteredCollections[type] = applyFilters(collection)
            }
        }
    }

    init(ref: Firebase = Firebase(url: BaseURL)) {
        baseRef = ref
        ids = []
        filteredCollections = [:]
        collectionEndpoints = [:]
        collections = [:]
        filters = []
        isDataLoaded = false
        userId = ""

        do {
            try setupUser { inner in
                do {
                    let _ = try inner()
                } catch let error {
                    print(error)
                }
            }
        } catch _ {
        }
    }

    /**
        Creates a user object
        
        :param: completion
        :throws:
     
        read more about try/catch with async closures
        http://appventure.me/2015/06/19/swift-try-catch-asynchronous-closures/
    */
    func setupUser(completion: (() throws -> User) -> ()) throws {
        guard let userId = sessionManagerFlags.userId else {
            throw MediaLinksViewModelError.NoUser
        }

        if !sessionManagerFlags.openSession {
            throw MediaLinksViewModelError.NoUser
        }

        self.userId = userId

        userRef = baseRef.childByAppendingPath("users/\(userId)")
        userRef?.keepSynced(true)

        for type in MediaLinksCollectionType.allValues {
            let endpoint = userRef?.childByAppendingPath(type.rawValue.lowercaseString)
            collectionEndpoints[type] = endpoint
        }

        userRef?.observeEventType(.Value, withBlock: { snapshot in
            if let _ = snapshot.key, let value = snapshot.value as? [String: AnyObject] where snapshot.exists() {
                self.currentUser = User()
                self.currentUser?.setValuesForKeysWithDictionary(value)
                self.delegate?.mediaLinksViewModelDidAuthUser(self, user: self.currentUser!)
                completion({ return self.currentUser! })
            } else {
                completion({ throw MediaLinksViewModelError.NoUser })
            }
        })
    }

    func fetchAllData() throws {
        for type in MediaLinksCollectionType.allValues {
            try fetchCollection(type)
        }
    }

    func fetchCollection(collectionType: MediaLinksCollectionType, completion: ((Bool) -> Void)? = nil) throws {
        guard let ref = collectionEndpoints[collectionType] else {
            throw MediaLinksViewModelError.FetchingCollectionDataFailed
        }

        ref.observeEventType(.Value, withBlock: { snapshot in
            var links: [MediaLink] = []

            if let data = snapshot.value as? [String: AnyObject] {
                var ids = [String]()

                for (id, _) in data {
                    ids.append(id)
                }

                self.ids = ids

                for (_, item) in data {
                    guard let favoritesData = item as? [String: AnyObject],
                        let link = self.processMediaLinkData(favoritesData) else {
                            continue
                    }

                    links.append(link)
                }
            }

            self.isDataLoaded = true
            self.collections[collectionType] = links
            let filteredCollection = self.filteredMediaLinksForCollectionType(collectionType)
            self.delegate?.mediaLinksViewModelDidReceiveMediaLinks(self, collectionType: collectionType, links: filteredCollection)
            completion?(true)
        })
    }

    /// Reapplies filters on passed in collection and returns a list of filtered links
    func filteredMediaLinksForCollectionType(collectionType: MediaLinksCollectionType) -> [MediaLink] {
        filteredCollections[collectionType] = applyFilters(collections[collectionType] ?? [])
        return filteredCollections[collectionType] ?? []
    }

    func sectionHeaderTitleForCollectionType(collectionType: MediaLinksCollectionType) -> String {
        var headerTitle = ""
        let links = filteredMediaLinksForCollectionType(collectionType)
        if filters.isEmpty {
            headerTitle =  "\(links.count)" + " " + collectionType.rawValue
        } else {
            headerTitle =  "\(links.count)" + " \(filters[0].rawValue.uppercaseString)s"
        }

        return headerTitle
    }
    
    private func processMediaLinkData(resultData: [String: AnyObject]) -> MediaLink? {
        guard let provider = resultData["_index"] as? String,
            let rawType = resultData["_type"] as? String,
            let _ = resultData["_id"] as? String,
            let _ = resultData["_score"] as? Double,
            let _ = MediaLinkSource(rawValue: provider),
            let type = MediaType(rawValue: rawType) else {
                return nil
        }

        var result: MediaLink? = nil
        
        switch(type) {
        case .Article:
            result = ArticleMediaLink(data: resultData)
        case .Track:
            result = TrackMediaLink(data: resultData)
        case .Video:
            result = VideoMediaLink(data: resultData)
            break
        default:
            break
        }
        
        guard let item = result else {
            return nil
        }
        
        if let index = resultData["_index"] as? String,
            let source = MediaLinkSource(rawValue: index) {
                item.source = source
        } else {
            item.source = .Unknown
        }
        
        if let source = resultData["source"] as? [String: String],
            let sourceName = source["name"] {
                item.sourceName = sourceName
        } else {
            item.sourceName = item.getNameForSource()
        }
        return item
    }

    private func applyFilters(links: [MediaLink]) -> [MediaLink] {
        if filters.isEmpty {
            return links
        }
        
        var filteredLinks: [MediaLink] = []
        for link in links {
            if filters.contains(link.type) {
                filteredLinks.append(link)
            }
        }
        
        return filteredLinks
    }
}

enum MediaLinksCollectionType: String {
    case Favorites = "Favorites"
    case Recents = "Recents"
    case Trending = "Trending"

    static let allValues = [Favorites, Recents]
}

protocol MediaLinksViewModelDelegate: class {
    func mediaLinksViewModelDidAuthUser(mediaLinksViewModel: MediaLinksViewModel, user: User)
    func mediaLinksViewModelDidReceiveMediaLinks(mediaLinksViewModel: MediaLinksViewModel, collectionType: MediaLinksCollectionType, links: [MediaLink])
}

