//
//  PacksService.swift
//  Often
//
//  Created by Luc Succes on 4/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Firebase
import FirebaseMessaging
import FirebaseInstanceID

class PacksService: PackItemViewModel {
    static let defaultInstance = PacksService()
    let didUpdatePacks = Event<[PackMediaItem]>()
    var mediaItems: [MediaItem]
    
    internal var collectionEndpoint: FIRDatabaseReference!
    private var subscriptionsRef: FIRDatabaseReference!
    private var subscriptions: [PackSubscription] = []
    private(set) var ids: Set<String> = []
    private(set) var recentsPack: PackMediaItem?
    private(set) var favoritesPack: PackMediaItem?
    
    override var typeFilter: MediaType {
        didSet {
            SessionManagerFlags.defaultManagerFlags.lastFilterType = typeFilter.rawValue
            delegate?.mediaItemGroupViewModelDataDidLoad(self, groups: self.mediaItemGroups)
        }
    }

    override var isCurrentUser: Bool {
        guard let currentUserId = SessionManagerFlags.defaultManagerFlags.userId else {
            return false
        }

        return userId == currentUserId
    }

    init(userId: String) {
        mediaItems = []

        super.init(userId: userId, packId: "")
        collectionEndpoint = userRef.child("packs")

        if let lastPack = SessionManagerFlags.defaultManagerFlags.lastPack {
            packId = lastPack
        }

        if let lastFilterType = SessionManagerFlags.defaultManagerFlags.lastFilterType,
            let type = MediaType(rawValue: lastFilterType) {
            typeFilter = type
        }

        currentCategory = Category.all

        do {
            try setupUser { inner in
            }
        } catch _ {
        }

        subscriptionsRef = userRef.childByAppendingPath("subscriptions")
        subscriptionsRef.observeEventType(.Value, withBlock: self.onSubscriptionsChanged)
        subscriptionsRef.keepSynced(true)
    }
    
    convenience init() {
        var id: String
        if let userId = SessionManagerFlags.defaultManagerFlags.userId {
            id = userId
        } else {
            id = "default"
        }

        self.init(userId: id)
    }
    
    func fetchCollection(completion: ((Bool) -> Void)? = nil) {
        collectionEndpoint.observeEventType(.Value, withBlock: { snapshot in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                self.isDataLoaded = true
                if let data = snapshot.value as? [String: AnyObject] {
                    self.mediaItems = self.processMediaItemsCollectionData(data)
                }
                dispatch_async(dispatch_get_main_queue()) {
                    completion?(true)
                }
            }
        })
    }
    
    func generatePacksGroup(items: [MediaItem]) -> [MediaItemGroup] {
        let group = MediaItemGroup(dictionary: [
            "id": "packs",
            "title": "Packs",
            "type": "pack"
            ])
        group.items = items
        
        return [group]
    }
    
    override func fetchData(completion: ((Bool) -> Void)? = nil) {
        fetchCollection { [weak self] done in
            if let packs = self?.mediaItems as? [PackMediaItem] {
                self?.populateCurrentPack()
                self?.didUpdatePacks.emit(packs)
            }
        }
    }
    
    func fetchLocalData(completion: ((Bool) -> Void)? = nil) {
        if let path = NSBundle.mainBundle().pathForResource("djkhaledpack", ofType: "json") {
            do {
                let jsonData =  try NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
                if let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    self.isDataLoaded = true
                    let pack = PackMediaItem(data: jsonResult)
                    self.mediaItems = [pack]
                    if let packs = mediaItems as? [PackMediaItem] {
                        populateCurrentPack()
                        didUpdatePacks.emit(packs)
                    }
                }
            } catch _{
                
            }
            
        }
    }
    
    func generateMediaItemGroups() -> [MediaItemGroup] {
        if !mediaItems.isEmpty {
            mediaItemGroups = generatePacksGroup(mediaItems)
            return mediaItemGroups
        }
        
        return []
    }
    
    func addPack(pack: PackMediaItem) {
        sendTask("add", result: pack)
        
        FIRMessaging.messaging().subscribeToTopic("/topics/\(pack.id)")
        
        if let currentInstallation = PFInstallation.currentInstallation() {
            currentInstallation.addUniqueObject("p\(pack.id)", forKey: "channels")
            currentInstallation.saveInBackground()
        }
    }
    
    func addToGlobalPushNotifications() {
        FIRMessaging.messaging().subscribeToTopic("/topics/global")
        
        if let currentInstallation = PFInstallation.currentInstallation() {
            currentInstallation.addUniqueObject("pglobal", forKey: "channels")
            currentInstallation.saveInBackground()
        }
    }
    
    func removeFromGlobalPushNotifications() {
        FIRMessaging.messaging().unsubscribeFromTopic("/topics/global")
        
        if let currentInstallation = PFInstallation.currentInstallation() {
            currentInstallation.removeObject("pglobal", forKey: "channels")
            currentInstallation.saveInBackground()
        }
    }
    
    func removePack(pack: PackMediaItem) {
        sendTask("remove", result: pack)
        
        FIRMessaging.messaging().unsubscribeFromTopic("/topics/\(pack.id)")
        
        if let currentInstallation = PFInstallation.currentInstallation() {
            currentInstallation.removeObject("p\(pack.id)", forKey: "channels")
            currentInstallation.saveInBackground()
        }
    }
    
    func checkPack(result: MediaItem) -> Bool {
        return ids.contains(result.id)
    }

    func checkFavoritesMediaItem(result: MediaItem) -> Bool {
        if let favorites = favoritesPack {
            return favorites.items.contains(result)
        }
        
        return false
    }
    
    func getPackForId(packId: String) -> PackMediaItem? {
        guard let packs = mediaItems as? [PackMediaItem] else {
            return nil
        }
        
        if recentsPack?.id == packId {
            return recentsPack
        }
        
        if favoritesPack?.id == packId {
            return favoritesPack
        }
        
        for pack in packs where packId == pack.pack_id {
            return pack
        }
        
        return nil
    }
    
    func switchCurrentPack(packId: String)  {
        self.packId = packId
        SessionManagerFlags.defaultManagerFlags.lastPack = packId
        currentCategory = Category.all
        fetchData()
    }
    
    private func processMediaItemsCollectionData(data: [String: AnyObject]) -> [MediaItem] {
        var items: [PackMediaItem] = []
        ids.removeAll()
        
        for (id, item) in data {
            ids.insert(id)
            if let dict = item as? NSDictionary, let item = MediaItem.mediaItemFromType(dict) as? PackMediaItem {
                if item.isRecents && item.isUserPackOwner(currentUser) {
                    recentsPack = item
                } else if item.isFavorites && item.isUserPackOwner(currentUser) {
                    favoritesPack = item
                    items.insert(item, atIndex: 0)
                } else {
                    items.append(item)
                }
            }
        }
        
        return items
    }
    
    private func sendTask(task: String, result: MediaItem) {
        guard let userId = currentUser?.id else {
            return
        }
        
        let userQueue = FIRDatabase.database().reference().child("queues/user/tasks").childByAutoId()
        userQueue.setValue([
            "type": "editPackSubscription",
            "userId": userId,
            "data": [
                "packId": result.id,
                "operation": task
            ],
            "result": result.toDictionary()
        ])
        
        // Preemptively add item to collection before backend queue modifies
        // in case user worker is down
        let ref = collectionEndpoint.child("\(result.id)")
        if task == "add" {
            ref.setValue(result.toDictionary())
        } else if task == "remove" {
            ref.removeValue()
        }
        
        fetchData()
    }
    
    private func populateCurrentPack() {
        guard let packs = mediaItems as? [PackMediaItem], let packsID = packs.first?.pack_id  else {
            return
        }
        
        if SessionManagerFlags.defaultManagerFlags.lastPack == nil {
            SessionManagerFlags.defaultManagerFlags.lastPack = packsID
        }
        
        if let currentPackId = SessionManagerFlags.defaultManagerFlags.lastPack, let pack = getPackForId(currentPackId) {
            self.pack = pack
            self.mediaItemGroups = pack.getMediaItemGroups()
            
            if let packId = pack.pack_id {
                self.packId = packId
            }
            
            if SessionManagerFlags.defaultManagerFlags.lastCategoryIndex < pack.categories.count {
                currentCategory = pack.categories[SessionManagerFlags.defaultManagerFlags.lastCategoryIndex]
            } else {
                currentCategory = pack.categories.first
                SessionManagerFlags.defaultManagerFlags.lastCategoryIndex = 0
            }
            
            if let currentCategory = currentCategory {
                applyFilter(currentCategory)
            }
            
            self.delegate?.mediaItemGroupViewModelDataDidLoad(self, groups: self.mediaItemGroups)
        }
        
    }
    
    private func onSubscriptionsChanged(snapshot: FIRDataSnapshot!) {
        var subscriptions = [PackSubscription]()
        if let data = snapshot.value as? [String: AnyObject] {
            for (_, item) in data {
                if let item = item as? NSDictionary {
                    subscriptions.append(PackSubscription(data: item))
                }
            }
            
        }
    }
    
    func generateSuggestedUsername() -> String {
        var username: String = ""
        
        if let user = currentUser {
            if !user.username.isEmpty {
                username = user.username
            } else {
                username = user.name.stringByReplacingOccurrencesOfString(" ", withString: ".").lowercaseString
            }
            
        }
        
        return username
    }
    
    func usernameDoesExist(username: String, completion: ((Bool) -> Void)? = nil) {
        let baseRef = FIRDatabase.database().reference()
        let encodedString = encodeString(username)
        let ref = baseRef.child("usernames/\(encodedString)")
        var exists: Bool = true
        
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let _ = snapshot.value as? NSDictionary {
                exists = true
            } else {
                exists = false
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                completion?(exists)
            }
        })
    }
    
    func saveUsername(username: String) {
        guard let id = currentUser?.id else {
            return
        }
        
        currentUser?.username = username
        
        let baseRef = FIRDatabase.database().reference()
        let encodedString = encodeString(username)
        var ref = baseRef.child("usernames/\(encodedString)")
        ref.setValue([
            "name": username,
            "userid": id,
            "packid": packId
            ])
        
        ref = baseRef.child("users/\(id)")
        ref.updateChildValues([
            "username": username
            ])
    }

    override func updatePackProfileImage(image: ImageMediaItem) {
        guard let favPackID = currentUser?.favoritesPackId,
            smallImage = image.smallImageURL?.absoluteString,
            largeImage = image.largeImageURL?.absoluteString else {
            return
        }

        let ref = userRef.child("packs/\(favPackID)/image")
        ref.updateChildValues([
            "large_url": largeImage,
            "small_url": smallImage
            ])
    }
    
    func updatePackTitleAndDescription(title: String, description: String) {
        guard let favPackID = currentUser?.favoritesPackId else {
            return
        }
        
        let ref = userRef.child("packs/\(favPackID)")
        ref.updateChildValues([
            "name": title,
            "description": description
            ])
    }
    
    func encodeString(username: String) -> String {
        let plainData = (username as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        if let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) {
            return base64String
        }
        return ""
    }
    
}