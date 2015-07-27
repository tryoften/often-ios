//
//  KeyboardPage.swift
//  Surf
//
//  Created by Luc Succes on 7/23/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

typealias KeyboardRow = [KeyboardKey]

enum KeyboardPageIdentifier: Int {
    case Letter = 0
    case Numeric
    case Special
    case SecondSpecial
}

struct KeyboardPage {
    var id: KeyboardPageIdentifier
    var rows: [ KeyboardRow ]
}