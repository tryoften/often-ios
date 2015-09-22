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
        readFriendsData()
    }
    
    func readFriendsData() {
        do {
            if let data = userDefaults.objectForKey("friends") as? NSData {
                if let friendsData = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                    for var i = 0; i < friendsData.count; i++ {
                        let friend = VenmoFriend()
                        friend.setValuesForKeysWithDictionary(friendsData[i] as! [String : AnyObject])
                        friends.append(friend)
                    }
                }
            }
        } catch _ as NSError {
            
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
            if fuzzySearch(friend.name, stringToSearch: searchString) {
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
