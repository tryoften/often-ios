//
//  TermDictionary.swift
//  Often
//
//  Created by Luc Succes on 11/4/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation
import RealmSwift

class Term: Object, Equatable, Hashable {
    var id: Int = -1
    var term: String = ""
    
    var length: Int {
        return term.length
    }
    
    override var hashValue: Int {
        return term.hashValue
    }

    required init(string: String) {
        term = string
        super.init()
    }

    required convenience init() {
        self.init(string: "")
    }
}

func ==(lhs: Term, rhs: Term) -> Bool {
    return lhs.term == rhs.term
}

class Index: Object, Equatable {
    var value: Int

    init(int: Int) {
        self.value = int
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }
}

func ==(lhs: Index, rhs: Index) -> Bool {
    return lhs.value == rhs.value
}