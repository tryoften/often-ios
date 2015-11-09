//
//  TermDictionary.swift
//  Often
//
//  Created by Luc Succes on 11/4/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Term: Object, Equatable, Hashable {
    dynamic var id: String = ""
    dynamic var term: String = ""
    
    dynamic var length: Int {
        return term.length
    }
    
    override var hashValue: Int {
        return term.hashValue
    }

    required init(string: String) {
        term = string
        super.init()
    }
    
    override init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }

    required convenience init() {
        self.init(string: "")
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

func ==(lhs: Term, rhs: Term) -> Bool {
    return lhs.term == rhs.term
}