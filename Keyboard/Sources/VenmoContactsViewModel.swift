//
//  VenmoContactsViewModel.swift
//  Surf
//
//  Created by Luc Succes on 8/5/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class VenmoContactsViewModel {
    var userDefaults: NSUserDefaults = NSUserDefaults(suiteName: AppSuiteName)!
    var friends: [VenmoFriend]
    private var filteredFriends: [VenmoFriend]?
    
    init() {
        friends = []
        
        if let friendsData = userDefaults.objectForKey("friends") as? [[NSObject : AnyObject]] {
            for var i = 0; i < friendsData.count; i++ {
                var friend = VenmoFriend()
                friend.setValuesForKeysWithDictionary(friendsData[i])
                friends.append(friend)
            }
        } else {
            println("Keyboard Friends Fail")
        }
    }
    
    func numberOfContacts() -> Int {
        if let filteredFriends = filteredFriends {
            return filteredFriends.count
        }
        return friends.count
    }
    
    func contactAtIndex(index: Int) -> VenmoFriend? {
        let friends: [VenmoFriend] = filteredFriends ?? self.friends
        
        if index < friends.count {
            return friends[index]
        }
        return nil
    }
    
    func filterContacts(searchString: String) {
        if searchString.isEmpty {
            filteredFriends = nil
            return
        }

        var filtered = [VenmoFriend]()
        
        for friend in friends {
            if fuzzySearch(friend.name, searchString) {
                filtered.append(friend)
            }
        }
        
        if filtered.isEmpty {
            filteredFriends = nil
        } else {
            filteredFriends = filtered
        }
    }
}
