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
    case Euro = "\u{128}"
}

enum Modifier {
    case Space
    case CapsLock
    case Backspace
    case Enter
    case AlphabeticKeypad
    case SpecialKeypad
    case NextSpecialKeypad
    case SwitchKeyboard
    case SearchMode
    case GoToBrowse
}

enum KeyboardKey {
    case digit(Digit)
    case letter(Letter)
    case modifier(Modifier)
    case special(SpecialCharacter)
}

enum Lettercase {
    case Lowercase
    case Uppercase
}