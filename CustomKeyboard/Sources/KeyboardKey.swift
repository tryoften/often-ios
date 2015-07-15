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

enum SpecialCharacter {
    case Space
    case CapsLock
    case Backspace
    case Enter
    case NumericKeypad
    case SwitchKeyboard
    case SearchMode
    case GoToBrowse
}

enum KeyboardKey {
    case letter(Letter)
    case modifier(SpecialCharacter)
}

enum Lettercase {
    case Lowercase
    case Uppercase
}