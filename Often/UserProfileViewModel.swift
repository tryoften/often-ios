//
//  UserProfileViewModel.swift
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

class UserProfileViewModel: NSObject, SessionManagerObserver {
    weak var delegate: UserProfileViewModelDelegate?
    let sessionManager: SessionManager
    var favoriteRef: Firebase?
    var recentsRef: Firebase?
    var shouldFilter: Bool = false
    
    var filteredUserRecents: [UserRecentLink]
    var filteredUserFavorites: [UserFavoriteLink]
    
    var filters: [MediaType] {
        didSet {
            filterUserRecents()
            filterUserFavorites()
        }
    }
    
    var userRecents: [UserRecentLink] {
        didSet {
            filterUserRecents()
        }
    }
    
    var userFavorites: [UserFavoriteLink] {
        didSet {
            filterUserFavorites()
        }
    }
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        
        userFavorites = []
        userRecents = []
        filteredUserRecents = []
        filteredUserFavorites = []
        filters = []
        
        super.init()
    }
    
    func requestData(completion: ((Bool) -> ())? = nil) throws {
        guard let user = sessionManager.currentUser else {
            throw UserProfileViewModelError.NoUser
        }
        
        guard sessionManager.userDefaults.boolForKey(SessionManagerProperty.openSession) else {
            throw UserProfileViewModelError.RequestDataFailed
        }
        
        let root = Firebase(url: BaseURL)
        favoriteRef = root.childByAppendingPath("users/\(user.id)/favorites")
        favoriteRef?.keepSynced(true)
        
        recentsRef = root.childByAppendingPath("users/\(user.id)/recents")
        recentsRef?.keepSynced(true)
        
        try fetchFavorites()
        try fetchRecents()

        delegate?.userProfileViewModelDidLoginUser(self, user: user)
    }
    

    func fetchFavorites() throws {
        guard let favoriteRef = favoriteRef else {
            throw UserProfileViewModelError.FetchingFavoritesDataFailed
        }
        
        favoriteRef.observeEventType(.Value, withBlock: { snapshot in
            var favoritesLinks: [UserFavoriteLink] = []
            
            if let data = snapshot.value as? [String: AnyObject] {
                for (_, favoritesData) in data {
                    if let favoriteLink = self.processMediaLinkData(favoritesData as! [String: AnyObject]) {
                        favoritesLinks.append(favoriteLink)
                    }
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
                for (_, recentsData) in data {
                    if let recentLink = self.processMediaLinkData(recentsData as! [String : AnyObject]) {
                        recentsLinks.append(recentLink)
                    }
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
    

    func filterUserRecents() {
        filteredUserRecents = applyFilters(userRecents)
        delegate?.userProfileViewModelDidReceiveRecents(self, recents: filteredUserRecents)
    }
    
    func filterUserFavorites() {
        filteredUserFavorites = applyFilters(userFavorites)
        delegate?.userProfileViewModelDidReceiveFavorites(self, favorites: filteredUserFavorites)
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
}

protocol UserProfileViewModelDelegate: class {
    func userProfileViewModelDidLoginUser(userProfileViewModel: UserProfileViewModel, user: User)
    func userProfileViewModelDidReceiveFavorites(userProfileViewModel: UserProfileViewModel, favorites: [UserFavoriteLink])
    func userProfileViewModelDidReceiveRecents(userProfileViewModel: UserProfileViewModel, recents: [UserRecentLink])
}

