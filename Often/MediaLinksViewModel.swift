//
//  MediaLinksViewModel.swift
//  Often
//

import Foundation

typealias UserFavoriteLink = MediaLink
typealias UserRecentLink = MediaLink

enum UserProfileViewModelError: ErrorType {
    case NoUser
    case FetchingFavoritesDataFailed
    case FetchingRecentsDataFailed
    case RequestDataFailed
}

class MediaLinksViewModel {
    weak var delegate: UserProfileViewModelDelegate?
    private let userId: String
    let baseRef: Firebase
    private var userRef: Firebase?
    private var favoriteRef: Firebase?
    private var recentsRef: Firebase?
    var currentUser: User?
    private var favorites: [String]
    private var shouldFilter: Bool = false
    private let userDefaults: NSUserDefaults
    var mediaLinks: [MediaLink]
    private var filteredUserRecents: [UserRecentLink]
    private var filteredUserFavorites: [UserFavoriteLink]
    var currentCollectionType: UserProfileCollectionType  {
        didSet {
            filterMediaLinks()
        }
    }
    
    var filters: [MediaType] {
        didSet {
            filterMediaLinks()
        }
    }
    
    var userRecents: [UserRecentLink] {
        didSet {
            filterMediaLinks()
        }
    }
    
    var userFavorites: [UserFavoriteLink] {
        didSet {
            filterMediaLinks()
        }
    }
    
    init(ref: Firebase = Firebase(url: BaseURL)) {
        baseRef = ref
        favorites = []
        userFavorites = []
        userRecents = []
        filteredUserRecents = []
        filteredUserFavorites = []
        mediaLinks = []
        filters = []
        currentCollectionType = .Favorites
        userDefaults = NSUserDefaults(suiteName: AppSuiteName)!
        self.userId = ""
        
    }
    
    func requestData(completion: ((Bool) -> ())? = nil) throws {
        guard let userId = userDefaults.objectForKey(UserDefaultsProperty.userID) as? String else {
                throw UserProfileViewModelError.NoUser
        }
        
        guard userDefaults.boolForKey(UserDefaultsProperty.openSession) else {
            throw UserProfileViewModelError.RequestDataFailed
        }
        
        userRef = baseRef.childByAppendingPath("users/\(userId)")
        userRef?.keepSynced(true)
        
        userRef?.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                if let _ = snapshot.key,
                    let value = snapshot.value as? [String: AnyObject] {
                        self.currentUser = User()
                        self.currentUser?.setValuesForKeysWithDictionary(value)
                }
            }
            self.delegate?.userProfileViewModelDidLoginUser(self)
        })
        
        favoriteRef = baseRef.childByAppendingPath("users/\(userId)/favorites")
        favoriteRef?.keepSynced(true)
        
        recentsRef = baseRef.childByAppendingPath("users/\(userId)/recents")
        recentsRef?.keepSynced(true)
        
        try fetchFavorites()
        try fetchRecents()
    
    }
    

    func fetchFavorites() throws {
        guard let favoriteRef = favoriteRef else {
            throw UserProfileViewModelError.FetchingFavoritesDataFailed
        }
        
        favoriteRef.observeEventType(.Value, withBlock: { snapshot in
            var favoritesLinks: [UserFavoriteLink] = []
            
            if let data = snapshot.value as? [String: AnyObject] {
                var ids = [String]()
                
                for (id, _) in data {
                    ids.append(id)
                }
                
                self.favorites = ids
                
                for (_, item) in data {
                    guard let favoritesData = item as? [String: AnyObject],
                        let favoriteLink = self.processMediaLinkData(favoritesData) else {
                        continue
                    }

                    favoritesLinks.append(favoriteLink)
                }
            }
            self.userFavorites = favoritesLinks
        })
        
    }
    
    func fetchRecents() throws {
        guard let recentsRef = recentsRef else {
            throw UserProfileViewModelError.FetchingRecentsDataFailed
        }
        
        recentsRef.observeEventType(.Value, withBlock: { snapshot in
            var recentsLinks: [UserRecentLink] = []
            
            if let data = snapshot.value as? [String: AnyObject] {
                for (_, item) in data {
                    guard let recentsData = item as? [String: AnyObject],
                        let recentLink = self.processMediaLinkData(recentsData) else {
                            continue
                    }
                    recentsLinks.append(recentLink)
                }
                
            }
            self.userRecents = recentsLinks
        })
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
    

    func filterMediaLinks() {
        switch(currentCollectionType) {
        case .Favorites:
            mediaLinks = applyFilters(userFavorites)
            break
        case .Recents:
            mediaLinks = applyFilters(userRecents)
            break
        }
        delegate?.userProfileViewModelDidReceiveMediaLinks(self, links: mediaLinks)
    }
    
    func toggleFavorite(selected: Bool, result: MediaLink) {
        if selected {
            addFavorite(result)
        } else {
            removeFavorite(result)
        }
    }
    
    func addFavorite(result: MediaLink) {
        sendTask("addFavorite", result: result)
    }
    
    func removeFavorite(result: MediaLink) {
        sendTask("removeFavorite", result: result)
    }
    
    func checkFavorite(result: MediaLink) -> Bool {
        let base64URI = SearchRequest.idFromQuery(result.id)
            .stringByReplacingOccurrencesOfString("/", withString: "_")
            .stringByReplacingOccurrencesOfString("+", withString: "-")
        
        return favorites.contains(base64URI)
    }
    
    
    
    func applyFilters(links: [MediaLink]) -> [MediaLink] {

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
    
    private func sendTask(task: String, result: MediaLink) {
        let favoriteQueueRef = Firebase(url: BaseURL).childByAppendingPath("queues/user/tasks").childByAutoId()
        favoriteQueueRef.setValue([
            "task": task,
            "user": userId,
            "result": result.toDictionary()
            ])
    }
}

enum UserProfileCollectionType: String {
    case Favorites = "Favorites"
    case Recents = "Recents"
}

protocol UserProfileViewModelDelegate: class {
    func userProfileViewModelDidLoginUser(userProfileViewModel: MediaLinksViewModel)
    func userProfileViewModelDidReceiveMediaLinks(userProfileViewModel: MediaLinksViewModel, links: [MediaLink])
}

