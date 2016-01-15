//
//  BaseViewModel.swift
//  Often
//
//  Created by Luc Succes on 1/7/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

class BaseViewModel: DataLoadable {
    let baseRef: Firebase
    let ref: Firebase
    var path: String?
    var isDataLoaded: Bool

    init(baseRef: Firebase = Firebase(url: BaseURL), path: String?) {
        self.baseRef = baseRef
        self.path = path
        ref = path != nil ? baseRef.childByAppendingPath(path) : baseRef
        isDataLoaded = false
    }

    /**
     Fetches data for current view model

     - throws:
     */
    func fetchData() throws {

    }
}

protocol DataLoadable {
    func fetchData() throws
}