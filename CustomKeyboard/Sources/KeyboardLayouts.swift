//
//  KeyboardMaps.swift
//  October
//
//  Created by Luc Succes on 7/15/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import Foundation

// CharacterMaps
private let EnglishKeyboardMap: [KeyboardRow] = [
    [.letter(.Q), .letter(.W), .letter(.E), .letter(.R), .letter(.T), .letter(.Y), .letter(.U), .letter(.I), .letter(.O), .letter(.P)],
    [.letter(.A), .letter(.S), .letter(.D), .letter(.F), .letter(.G), .letter(.H), .letter(.J), .letter(.K), .letter(.L)],
    [.modifier(.CapsLock, .Letter), .letter(.Z), .letter(.X), .letter(.C), .letter(.V), .letter(.B), .letter(.N), .letter(.M), .modifier(.Backspace, .Letter)],
    [.changePage(1, .Letter), .modifier(.GoToBrowse, .Letter), .modifier(.SwitchKeyboard, .Letter), .modifier(.Space, .Letter), .modifier(.CallService, .Letter), .modifier(.Enter, .Letter)]
]

private let SpecialCharacterKeyboardMap: [KeyboardRow] = [
    [.digit(.One), .digit(.Two), .digit(.Three), .digit(.Four), .digit(.Five), .digit(.Six), .digit(.Seven), .digit(.Eight), .digit(.Nine), .digit(.Zero)],
    [.special(.Hyphen), .special(.Slash), .special(.Colon), .special(.Semicolon), .special(.OpenParenthesis), .special(.CloseParenthesis), .special(.DollarSign), .special(.Ampersand), .special(.At), .special(.Quote)],
    [.changePage(2, .Special), .special(.Period), .special(.Comma), .special(.QuestionMark), .special(.ExclamationMark), .special(.SingleQuote), .modifier(.Backspace, .Special)],
    [.changePage(0, .Special), .modifier(.GoToBrowse, .Special), .modifier(.SwitchKeyboard, .Special), .modifier(.Space, .Special), .modifier(.CallService, .Special), .modifier(.Enter, .Special)]
]

private let NextSpecialCharacterKeyboardMap: [KeyboardRow] = [
    [.special(.OpenBracket), .special(.CloseBracket), .special(.OpenBrace), .special(.CloseBrace), .special(.Hashtag), .special(.Percent), .special(.Caret), .special(.Asterisk), .special(.Plus), .special(.Equal)],
    [.special(.Underscore), .special(.Backslash), .special(.Line), .special(.Tilda), .special(.LessThan), .special(.GreaterThan), .special(.Euro)],
    [.changePage(1, .SecondSpecial), .special(.Period), .special(.Comma), .special(.QuestionMark), .special(.ExclamationMark), .special(.SingleQuote), .modifier(.Backspace, .SecondSpecial)],
    [.changePage(0, .SecondSpecial), .modifier(.GoToBrowse, .SecondSpecial), .modifier(.SwitchKeyboard, .SecondSpecial), .modifier(.Space, .SecondSpecial), .modifier(.CallService, .SecondSpecial), .modifier(.Enter, .SecondSpecial)]
]

enum Language: String {
    case English = "en_US"
}

let KeyboardLayouts: [Language: KeyboardLayout] = [
    .English: KeyboardLayout(locale: Language.English.rawValue, pages: [
        KeyboardPage(id: .Letter, rows: EnglishKeyboardMap),
        KeyboardPage(id: .Special, rows: SpecialCharacterKeyboardMap),
        KeyboardPage(id: .SecondSpecial, rows: NextSpecialCharacterKeyboardMap)
    ])
]

var DefaultKeyboardLayout = KeyboardLayouts[.English]!
