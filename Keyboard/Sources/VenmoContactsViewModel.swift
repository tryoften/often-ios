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
        
        if let data = userDefaults.objectForKey("friends") as? NSData {
            if let friendsData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSArray {
                for var i = 0; i < friendsData.count; i++ {
                    var friend = VenmoFriend()
                    friend.setValuesForKeysWithDictionary(friendsData[i] as! [NSObject : AnyObject])
                    friends.append(friend)
                }
            }
        } else {
            print("Keyboard Friends Fail")
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
