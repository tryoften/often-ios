//
//  KeyboardPage.swift
//  Surf
//
//  Created by Luc Succes on 7/23/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

typealias KeyboardRow = [KeyboardKey]

enum KeyboardPageIdentifier: String {
    case Letter = "letter"
    case Numeric = "numeric"
    case Special = "special"
    case SecondSpecial = "second-special"
}

struct KeyboardPage {
    var id: KeyboardPageIdentifier
    var rows: [ KeyboardRow ]
}