//
//  KeyboardTheme.swift
//  Often
//
//  Created by Luc Succes on 8/6/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

struct KeyboardTheme {
    init(dictionary: [String: UIColor]) {
        keyboardBackgroundColor = dictionary["keyboardBackgroundColor"]!    
        keyboardKeyBackgroundColor = dictionary["keyboardKeyBackgroundColor"]!
        keyboardKeyUnderColor = dictionary["keyboardKeyUnderColor"]!
        keyboardKeyBorderColor = dictionary["keyboardKeyBorderColor"]!
        keyboardKeyPopupColor = dictionary["keyboardKeyPopupColor"]!
        keyboardKeyTextColor = dictionary["keyboardKeyTextColor"]!
        shiftKeyBorderColor = dictionary["shiftKeyBorderColor"]!
        enterKeyBackgroundColor = dictionary["enterKeyBackgroundColor"]!
    }
    
    var keyboardBackgroundColor: UIColor
    var keyboardKeyBackgroundColor: UIColor
    var keyboardKeyUnderColor: UIColor
    var keyboardKeyBorderColor: UIColor
    var keyboardKeyPopupColor: UIColor
    var keyboardKeyTextColor: UIColor
    var shiftKeyBorderColor: UIColor
    var enterKeyBackgroundColor: UIColor
}

let DarkTheme: KeyboardTheme = KeyboardTheme(dictionary: [
    "keyboardBackgroundColor": UIColor(fromHexString: "#202020"),
    "keyboardKeyBackgroundColor": UIColor(fromHexString: "#2A2A2A"),
    "keyboardKeyUnderColor": UIColor(fromHexString: "#2A2A2A"),
    "keyboardKeyBorderColor": UIColor(fromHexString: "#2A2A2A"),
    "keyboardKeyPopupColor": UIColor(fromHexString: "#121314"),
    "keyboardKeyTextColor": UIColor.whiteColor(),
    "shiftKeyBorderColor": TealColor,
    "enterKeyBackgroundColor": UIColor.whiteColor()
])

let WhiteTheme: KeyboardTheme = KeyboardTheme(dictionary: [
    "keyboardBackgroundColor": UIColor(fromHexString: "#EDEDED"),
    "keyboardKeyBackgroundColor": UIColor.whiteColor(),
    "keyboardKeyUnderColor": UIColor.whiteColor(),
    "keyboardKeyBorderColor": UIColor.whiteColor(),
    "keyboardKeyPopupColor": UIColor.whiteColor(),
    "keyboardKeyTextColor": UIColor.blackColor(),
    "shiftKeyBorderColor": UIColor.blackColor(),
    "enterKeyBackgroundColor": UIColor.whiteColor()
])

let DefaultTheme = WhiteTheme