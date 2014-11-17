//
//  CategoryService.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/15/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

let CategoryServiceEndpoint = "https://blinding-fire-1400.firebaseio.com/"

class CategoryService: NSObject {
    var root = Firebase(url: CategoryServiceEndpoint)
    var categories: [Category] = []
    
    override init() {
        self.categories = [
            Category(id: "misc", name: "Miscellaneous", lyrics: [
                    Lyric(text: "This woman that I messed with unprotected, texting saying that she wish she would've kept it.", categoryId: "misc", trackId: "0llA0pYA6GpGk7fTjew0wO"),
                    Lyric(text: "Everybody talks and everybody listens/but somehow the truth always comes up missing", categoryId: "misc", trackId: "0llA0pYA6GpGk7fTjew0wO")
                ]),

            Category(id: "party", name: "Party", lyrics: [
                Lyric(text: "Let's toast to the fact that I moved out my momma's basement", categoryId: "party", trackId: "")
                ])
        ]
    }
    
    func fetchInitialData() {
        var categoriesRef = root.childByAppendingPath("categories")
        
        categoriesRef.observeSingleEventOfType(.Value, withBlock: {
            (snapshot: FDataSnapshot!)  in
            
            let categories = snapshot.value as [Dictionary<String, AnyObject>]
        })
    }
}
