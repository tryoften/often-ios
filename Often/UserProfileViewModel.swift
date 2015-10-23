//
//  UserProfileViewModel.swift
//  Often
//

import Foundation

class UserProfileViewModel: NSObject, SessionManagerObserver {
    weak var delegate: UserProfileViewModelDelegate?
    var sessionManager: SessionManager
    var currentUser: User?
    var favoriteRef: Firebase
    var recentsRef: Firebase
    var userFavorites: [SearchResult]?
    var userRecents: [SearchResult]?
    
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        favoriteRef =  Firebase(url: BaseURL)
        recentsRef = Firebase(url: BaseURL)
        
        userFavorites = []
        userRecents = []
        
        super.init()
        
        self.sessionManager.addSessionObserver(self)
    }
    
    deinit {
        sessionManager.removeSessionObserver(self)
    }
    
    func requestData(completion: ((Bool) -> ())? = nil) {
        if sessionManager.userDefaults.objectForKey("openSession") != nil {
            if let user = sessionManager.currentUser {
                currentUser = user
                pullUserFavoriteAndRecents(currentUser!)
                delegate?.userProfileViewModelDidLoginUser(self, user: currentUser!)
            }
            
        } else {
                    }
    }
    
    func pullUserFavoriteAndRecents(user: User) {
        userFavorites = []
        userRecents = []
        favoriteRef = favoriteRef.childByAppendingPath("users/\(user.id)/favorites")
        favoriteRef.keepSynced(true)

        favoriteRef.observeEventType(.Value, withBlock: { snapshot in
            
            if let data = snapshot.value as? [String: AnyObject] {
                for (_,favoritesData) in data {
                    self.userFavorites!.append(self.processSearchResultData(favoritesData as! [String : AnyObject])!)
                }
                self.delegate?.userProfileViewModelDidPullUserFavorites(self)
            }
        })
        
        recentsRef = recentsRef.childByAppendingPath("users/\(user.id)/recents")
        recentsRef.keepSynced(true)
        
        recentsRef.observeEventType(.Value, withBlock: { snapshot in
            
            if let data = snapshot.value as? [String: AnyObject] {
                for (_,favoritesData) in data {
                    self.userRecents!.append(self.processSearchResultData(favoritesData as! [String : AnyObject])!)
                }
                self.delegate?.userProfileViewModelDidPullUserFavorites(self)
            }
        })
        
    }
    
    func processSearchResultData(resultData: [String: AnyObject]) -> SearchResult? {
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

    
    func sessionDidOpen(sessionManager: SessionManager, session: FBSession) {
        
    }
    
    func sessionManagerDidLoginUser(sessionManager: SessionManager, user: User, isNewUser: Bool) {
        currentUser = user
        pullUserFavoriteAndRecents(currentUser!)
        delegate?.userProfileViewModelDidLoginUser(self, user: user)
    }
    
    func sessionManagerDidFetchSocialAccounts(sessionsManager: SessionManager, socialAccounts: [String: AnyObject]?) {
    }
    
}

protocol UserProfileViewModelDelegate: class {
    func userProfileViewModelDidLoginUser(userProfileViewModel: UserProfileViewModel, user: User)
    func userProfileViewModelDidPullUserFavorites(userProfileViewModel: UserProfileViewModel)
}

