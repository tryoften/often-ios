//
//  KeyboardKey.swift
//  October
//
//  Created by Luc Succes on 7/14/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import Foundation

enum Letter: Character {
    case A = "A"
    case B = "B"
    case C = "C"
    case D = "D"
    case E = "E"
    case F = "F"
    case G = "G"
    case H = "H"
    case I = "I"
    case J = "J"
    case K = "K"
    case L = "L"
    case M = "M"
    case N = "N"
    case O = "O"
    case P = "P"
    case Q = "Q"
    case R = "R"
    case S = "S"
    case T = "T"
    case U = "U"
    case V = "V"
    case W = "W"
    case X = "X"
    case Y = "Y"
    case Z = "Z"
}

enum Digit: Character {
    case Zero = "0"
    case One = "1"
    case Two = "2"
    case Three = "3"
    case Four = "4"
    case Five = "5"
    case Six = "6"
    case Seven = "7"
    case Eight = "8"
    case Nine = "9"
}

enum SpecialCharacter: Character {
    case Hyphen = "-"
    case Slash = "/"
    case Colon = ":"
    case Semicolon = ";"
    case OpenParenthesis = "("
    case CloseParenthesis = ")"
    case DollarSign = "$"
    case Ampersand = "&"
    case At = "@"
    case Quote = "\""
    case Period = "."
    case Comma = ","
    case QuestionMark = "?"
    case ExclamationMark = "!"
    case SingleQuote = "'"
    case OpenBracket = "["
    case CloseBracket = "]"
    case OpenBrace = "{"
    case CloseBrace = "}"
    case Hashtag = "#"
    case Percent = "%"
    case Caret = "^"
    case Asterisk = "*"
    case Plus = "+"
    case Equal = "="
    case Underscore = "_"
    case Backslash = "\\"
    case Line = "|"
    case Tilda = "~"
    case LessThan = "<"
    case GreaterThan = ">"
    case Euro = "€"
    case PoundSterling = "£"
    case Dot = "·"
}

enum Modifier: String {
    case Space = "Space"
    case CapsLock = "CapsLock"
    case Backspace = "Backspace"
    case Enter = "Enter"
    case SwitchKeyboard = "SwitchKeyboard"
    case SearchMode = "SearchMode"
    case GoToBrowse = "GoToBrowse"
    case CallService = "CallService"
}

enum KeyboardKey: Hashable {
    case digit(Digit)
    case letter(Letter)
    case special(SpecialCharacter, KeyboardPageIdentifier)
    case modifier(Modifier, KeyboardPageIdentifier)
    case changePage(Int, KeyboardPageIdentifier)
    
    var hashValue: Int {
        return toInt()
    }
    
    var hasOutput: Bool {
        switch self {
        case .modifier(let modifier):
            return false
        case .changePage(let page, let pageId):
            return false
        default:
            return true
        }
    }
    
    var isCharacter: Bool {
        switch self {
        case .modifier(let modifier, let pageId):
            return false
        case .changePage(let page, let pageId):
            return false
        default:
            return true
        }
    }
    
    var isModifier: Bool {
        switch self {
        case .modifier(let modifier, let pageId):
            return true
        case .changePage(let page, let pageId):
            return true
        default:
            return false
        }
    }
    
    var isSpace: Bool {
        switch self {
        case .modifier(.Space, let pageId):
            return true
        default:
            return false
        }
    }
    
    func toString() -> String {
        switch(self) {
        case .digit(let digit):
            return String(digit.rawValue)
        case .letter(let letter):
            return String(letter.rawValue)
        case .modifier(let string, let pageId):
            return "\(string.rawValue):\(pageId.rawValue)"
        case .special(let character, let pageId):
            return "\(character.rawValue):\(pageId.rawValue)"
        case .changePage(let page, let pageId):
            return "Page: \(page)"
        default:
            return ""
        }
    }
    
    func toInt() -> Int {
        switch(self) {
        case .digit(let character):
            return character.hashValue
        case .letter(let character):
            return character.hashValue
        case .modifier(let character, let pageId):
            return character.hashValue
        case .special(let character, let pageId):
            return character.hashValue
        case .changePage(let page, let pageId):
            return page
        default:
            break
        }
    }
}

extension KeyboardKey: Printable, DebugPrintable {
    var description: String {
        return toString()
    }
    
    var debugDescription: String {
        return toString()
    }
}

func ==(lhs: KeyboardKey, rhs: KeyboardKey) -> Bool {
    return lhs.toString() == rhs.toString()
}

enum ShiftState {
    case Disabled
    case Enabled
    case Locked
    
    func uppercase() -> Bool {
        switch self {
        case Disabled:
            return false
        case Enabled:
            return true
        case Locked:
            return true
        }
    }
}

enum Lettercase {
    case Lowercase
    case Uppercase
}