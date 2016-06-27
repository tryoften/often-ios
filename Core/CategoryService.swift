//
//  CategoryService.swift
//  Often
//
//  Created by Luc Succes on 3/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import Firebase

class CategoryService {
    static let defaultInstance = CategoryService()
    var categories: [Category]?
    let didUpdateCategories = Event<[Category]>()
    let ref: FIRDatabaseReference

    init(baseRef: FIRDatabaseReference = FIRDatabase.database().reference()) {
        ref = baseRef.child("categories")
        ref.observe(.value, with: { snapshot in
            var newCategories = [Category]()
            if let data = snapshot.value as? [String: AnyObject] {

                for (_, categoryData) in data {
                    if let categoryData = categoryData as? [String: AnyObject],
                        let id = categoryData["id"] as? String, let name = categoryData["name"] as? String {
                            let category = Category(id: id, name: name, smallImageURL: nil, largeImageURL: nil)
                            newCategories.append(category)
                    }
                }
                self.categories = newCategories.sorted { $0.name < $1.name }
                self.didUpdateCategories.emit(self.categories!)
            }
        })
    }

    func assignCategory(_ lyric: LyricMediaItem, category: Category) {
        guard let userId = SessionManagerFlags.defaultManagerFlags.userId else {
            return
        }

        let userQueueRef = FIRDatabase.database().reference().child("queues/user/tasks").childByAutoId()
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
