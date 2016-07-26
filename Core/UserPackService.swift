//
//  UserPackService.swift
//  Often
//
//  Created by Luc Succes on 1/17/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Firebase


class UserPackService: MediaItemsViewModel {
    static let defaultInstance = UserPackService()
    private(set) var ids: Set<String> = []

    let userRef: FIRDatabaseReference
    let userId: String
    let didChangeItems = Event<[MediaItem]>()

    init() {
        userId = SessionManagerFlags.defaultManagerFlags.userId!
        userRef = FIRDatabase.database().reference().child("users/\(userId)")

        super.init(collectionType: .Favorites)

        do {
            try setupUser { inner in
                if let favsId = self.currentUser?.favoritesPackId {
                    self.collectionEndpoint = self.userRef.child("packs/\(favsId)")
                    self.fetchData()
                }
            }
        } catch _ {}
    }

    override func fetchData(completion: ((Bool) -> Void)? = nil) {
        fetchCollection { success in
            if self.mediaItems.isEmpty {
                return
            }
            
            self.ids = []
            for favorite in self.mediaItems {
                self.ids.insert(favorite.id)
            }
            
            self.didChangeItems.emit(self.mediaItems)
        }
    }

    func toggleItem(selected: Bool, result: MediaItem) {
        if selected {
            addItem(result)
        } else {
            removeItem(result)
        }
        
        didChangeItems.emit([result])
        delegate?.mediaLinksViewModelDidCreateMediaItemGroups(self, collectionType: .Favorites, groups: mediaItemGroups)
    }

    func addItem(result: MediaItem) {
        ids.insert(result.id)
        sendTask("addFavorite", result: result)
        
        Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.favorited), additionalProperties: AnalyticsAdditonalProperties.mediaItem(result.toDictionary()))
        
        mediaItems.append(result)
    }
    
    func removeItem(result: MediaItem) {
        Analytics.sharedAnalytics().track(AnalyticsProperties(eventName: AnalyticsEvent.unfavorited), additionalProperties: AnalyticsAdditonalProperties.mediaItem(result.toDictionary()))
        
        ids.remove(result.id)
        sendTask("removeFavorite", result: result)
        mediaItems = mediaItems.filter({ $0 != result })
    }
    
    func checkItem(result: MediaItem) -> Bool {
        return ids.contains(result.id)
    }

    override func generateMediaItemGroups() -> [MediaItemGroup] {
        if !mediaItems.isEmpty {
            return []
        }
        return []
    }

    override func sectionHeaderImageURL(indexPath: NSIndexPath) -> NSURL? {
        let groups = mediaItemGroups

        if indexPath.section >= groups.count {
            return nil
        }

        let group = groups[indexPath.section]
        if !group.items.isEmpty {
            if let lyric = group.items.first as? LyricMediaItem {
                return lyric.smallImageURL
            }
        }

        return nil
    }

    // MARK: Private Methods    
    private func sendTask(task: String, result: MediaItem) {
        guard let userId = currentUser?.id else {
            return
        }
        
        let favoriteQueueRef = baseRef.child("queues/user/tasks").childByAutoId()
        favoriteQueueRef.setValue([
            "task": task,
            "user": userId,
            "result": result.toDictionary()
        ])
    }

}