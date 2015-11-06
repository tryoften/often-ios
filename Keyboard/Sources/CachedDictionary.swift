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
    
    override init() {
        do {
            realm = try Realm()
        } catch {}
        
        super.init()
    }
    
    override func objectForKey(key: AnyObject) -> AnyObject? {
        
        if let cachedObj = super.objectForKey(key) {
            return cachedObj
        }
        
        if let term = realm?.objectForPrimaryKey(T.self, key: key) {
            setObject(term, forKey: key)
            return term
        }
        
        return nil
    }
}

class CachedDictionary<T: Object>: CachedCollectionType<T> {
    
    subscript(index: AnyObject) -> AnyObject? {
        get {
            if let obj = objectForKey(index) {
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
    
    override init() {
        count = 0
        super.init()
    }
    
    func append(element: T) {
        count++
        setObject(element, forKey: count)
    }
    
    subscript(index: Int) -> T? {
        get {
            return objectForKey(index) as? T
        }
        
        set(newValue) {
            if let value = newValue {
                setObject(value, forKey: index)
            }
        }
    }
}