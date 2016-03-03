//
//  CategoryService.swift
//  Often
//
//  Created by Luc Succes on 3/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class CategoryService {
    static let defaultInstance = CategoryService()
    var categories: [Category]?

    let didUpdateCategories = Event<[Category]>()

    let ref: Firebase
    init(baseRef: Firebase = Firebase(url: BaseURL)) {
        ref = baseRef.childByAppendingPath("categories")
        ref.observeEventType(.Value, withBlock: { snapshot in
            var newCategories = [Category]()
            if let data = snapshot.value as? [String: AnyObject] {

                for (_, categoryData) in data {
                    if let categoryData = categoryData as? [String: String],
                        let id = categoryData["id"], let name = categoryData["name"] {
                            let category = Category(id: id, name: name)
                            newCategories.append(category)
                    }
                }
                self.categories = newCategories
                self.didUpdateCategories.emit(newCategories)
            }
        })
    }

    func assignCategory(lyric: LyricMediaItem, category: Category) {
        guard let userId = SessionManagerFlags.defaultManagerFlags.userId else {
            return
        }

        let userQueueRef = Firebase(url: BaseURL).childByAppendingPath("queues/user/tasks").childByAutoId()
        userQueueRef.setValue([
            "task": "assignCategory",
            "user": userId,
            "result": lyric.toDictionary(),
            "category": category.toDictionary()
        ])

        // Preemptively add item to collection before backend queue modifies
        // in case user worker is down
        lyric.category = category
    }
}