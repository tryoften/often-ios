//
//  UserProfileViewModel.swift
//  Often
//

import Foundation

typealias UserFavoriteLink = SearchResult
typealias UserRecentLink = SearchResult

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
    var userFavorites: [UserFavoriteLink]
    var userRecents: [UserRecentLink]
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        
        userFavorites = []
        userRecents = []
        
        super.init()
        
        self.sessionManager.addSessionObserver(self)
    }
    
    deinit {
        sessionManager.removeSessionObserver(self)
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
            self.userFavorites = []
            
            if let data = snapshot.value as? [String: AnyObject] {
                for (_, favoritesData) in data {
                    if let favoriteLink = self.processSearchResultData(favoritesData as! [String: AnyObject]) {
                        self.userFavorites.append(favoriteLink)
                    }
                }
            }
            
            self.delegate?.userProfileViewModelDidReceiveFavorites(self, favorites: self.userFavorites)
        })
        
    }
    
    func fetchRecents() throws {
        guard let recentsRef = recentsRef else {
            throw UserProfileViewModelError.FetchingRecentsDataFailed
        }
        
        recentsRef.observeEventType(.Value, withBlock: { snapshot in
            self.userRecents = []
            
            if let data = snapshot.value as? [String: AnyObject] {
                for (_, recentsData) in data {
                    if let recentLink = self.processSearchResultData(recentsData as! [String : AnyObject]) {
                        self.userRecents.append(recentLink)
                    }
                }
            }
            
            self.delegate?.userProfileViewModelDidReceiveRecents(self, recents: self.userRecents)
        })
    }
    
    private func processSearchResultData(resultData: [String: AnyObject]) -> SearchResult? {
        if let provider = resultData["_index"] as? String,
            let rawType = resultData["_type"] as? String,
            let _ = resultData["_id"] as? String,
            let _ = resultData["_score"] as? Double,
            let _ = SearchResultSource(rawValue: provider),
            let type = SearchResultType(rawValue: rawType) {
                
                var result: SearchResult? = nil
                
                switch(type) {
                case .Article:
                    result = ArticleSearchResult(data: resultData)
                case .Track:
                    result = TrackSearchResult(data: resultData)
                case .Video:
                    result = VideoSearchResult(data: resultData)
                    break
                default:
                    break
                }
                
                if let item = result {
                    if let index = resultData["_index"] as? String,
                        let source = SearchResultSource(rawValue: index) {
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
        }
        return nil
    }

    func filterUserFavoriteAndRecents(filterFlag: FilterFlag) {
        
        
    }
    
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
        
    }
    
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool) {
        delegate?.userProfileViewModelDidLoginUser(self, user: user)
    }
    
    func sessionManagerDidFetchSocialAccounts(sessionsManager: SessionManager, socialAccounts: [String: AnyObject]?) {
    }
    
}

protocol UserProfileViewModelDelegate: class {
    func userProfileViewModelDidLoginUser(userProfileViewModel: UserProfileViewModel, user: User)
    func userProfileViewModelDidReceiveFavorites(userProfileViewModel: UserProfileViewModel, favorites: [UserFavoriteLink])
    func userProfileViewModelDidReceiveRecents(userProfileViewModel: UserProfileViewModel, recents: [UserRecentLink])
}

