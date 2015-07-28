//
//  KeyboardLayout.swift
//  Surf
//
//  Created by Luc Succes on 7/23/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation


struct KeyboardLayout {
    var locale: String
    var pages: [KeyboardPage]
}

protocol KeyboardKeyProtocol: class {
    func frameForPopup(key: KeyboardKeyButton, direction: Direction) -> CGRect
    func willShowPopup(key: KeyboardKeyButton, direction: Direction) //may be called multiple times during layout
    func willHidePopup(key: KeyboardKeyButton)
}

extension CGRect: Hashable {
    public var hashValue: Int {
        get {
            return (origin.x.hashValue ^ origin.y.hashValue ^ size.width.hashValue ^ size.height.hashValue)
        }
    }
}

extension CGSize: Hashable {
    public var hashValue: Int {
        get {
            return (width.hashValue ^ height.hashValue)
        }
    }
}
