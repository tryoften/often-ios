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


class CachedCollectionType<T: Object>: NSCache {
    var realm: Realm?
    
    init(realm aRealm: Realm) {
        realm = aRealm
    }
    
    func objectForKey(key: String) -> T? {
        
        if let cachedObj = super.objectForKey(key) as? T {
            return cachedObj
        }
        
        if let term = realm?.objectForPrimaryKey(T.self, key: key) {
            setObject(term, forKey: key)
            return term
        }
        
        return nil
    }
    
    func setObject(obj: T, forKey key: String) {
        super.setObject(obj, forKey: key)
        
        if let object = obj as? T {
            if !realm!.inWriteTransaction {
                realm?.beginWrite()
            }
            realm?.add(object, update: true)
            if !realm!.inWriteTransaction {
                try! realm?.commitWrite()
            }
        }
    }
}

// Dictionary class backed by
class CachedDictionary<S, T: Object>: CachedCollectionType<T> {
    
    override init(realm: Realm) {
        super.init(realm: realm)
    }
    
    subscript(index: String) -> T? {
        get {
            if let obj = super.objectForKey(index) {
                return obj
            }
            return nil
        }
        
        set(newValue) {
            if let value = newValue {
                setObject(value, forKey: index)
            }
        }
    }
    

}

class CachedArray<T: Object>: CachedCollectionType<T> {
    var count: Int
    
    override init(realm: Realm) {
        count = 0
        super.init(realm: realm)
        
        count = realm.objects(T).count
    }
    
    func append(element: T) {
        count++
        setObject(element, forKey: count)
    }
    
    subscript(index: Int) -> T? {
        get {
            return objectForKey(String(index))
        }
        
        set(newValue) {
            if let value = newValue {
                setObject(value, forKey: index)
            }
        }
    }
}