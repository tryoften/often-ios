//
//  MockImageMemoryCache.swift
//  Nuke
//
//  Created by Alexander Grebenyuk on 04/10/15.
//  Copyright (c) 2016 Alexander Grebenyuk. All rights reserved.
//

import Foundation
import Nuke

class MockImageMemoryCache: ImageMemoryCaching {
    var enabled = true
    var responses = [ImageRequestKey: ImageCachedResponse]()
    init() {}

    func responseForKey(_ key: ImageRequestKey) -> ImageCachedResponse? {
        return self.enabled ? self.responses[key] : nil
    }
    
    func setResponse(_ response: ImageCachedResponse, forKey key: ImageRequestKey) {
        if self.enabled {
            self.responses[key] = response
        }
    }
    
    func removeResponseForKey(_ key: ImageRequestKey) {
        if self.enabled {
            self.responses[key] = nil
        }
    }
    
    func clear() {
        self.responses.removeAll()
    }
}
