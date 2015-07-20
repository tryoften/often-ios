//
//  KeyboardMaps.swift
//  October
//
//  Created by Luc Succes on 7/15/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import Foundation

let EnglishKeyboardMap: [ [KeyboardKey] ] = [
    [.letter(.Q), .letter(.W), .letter(.E), .letter(.R), .letter(.T), .letter(.Y), .letter(.U), .letter(.I), .letter(.O), .letter(.P)],
    [.letter(.A), .letter(.S), .letter(.D), .letter(.F), .letter(.G), .letter(.H), .letter(.J), .letter(.K), .letter(.L)],
    [.modifier(.CapsLock), .letter(.Z), .letter(.X), .letter(.C), .letter(.V), .letter(.B), .letter(.N), .letter(.M), .modifier(.Backspace)],
    [.modifier(.SpecialKeypad), .modifier(.GoToBrowse), .modifier(.SwitchKeyboard), .modifier(.Space), .modifier(.Enter)]
]

let SpecialCharacterKeyboardMap: [ [KeyboardKey] ] = [
    [.digit(.One), .digit(.Two), .digit(.Three), .digit(.Four), .digit(.Five), .digit(.Six), .digit(.Seven), .digit(.Eight), .digit(.Nine), .digit(.Zero)],
    [.special(.Hyphen), .special(.Slash), .special(.Colon), .special(.Semicolon), .special(.OpenParenthesis), .special(.CloseParenthesis), .special(.DollarSign), .special(.Ampersand), .special(.At), .special(.Quote)],
    [.modifier(.NextSpecialKeypad), .special(.Period), .special(.Comma), .special(.QuestionMark), .special(.ExclamationMark), .special(.SingleQuote), .modifier(.Backspace)],
    [.modifier(.AlphabeticKeypad), .modifier(.GoToBrowse), .modifier(.SwitchKeyboard), .modifier(.Space), .modifier(.Enter)]
]

let NextSpecialCharacterKeyboardMap: [ [KeyboardKey] ] = [

]
