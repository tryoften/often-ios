//
//  Constants.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/22/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import Foundation

#if DEBUG
let CategoryServiceEndpoint = "https://brilliant-fire-154.firebaseio.com/"
#else
let CategoryServiceEndpoint = "https://blinding-fire-1400.firebaseio.com/" // production
#endif

let ParseAppID = "L1f21j1lJQuu5xtP17BxdEH1qHWD1VSb6M1otl5G"
let ParseClientKey = "TQDQM9tDsLSC31qH1zaPvHtNpyfaVcxaUAHe8OiN"
let FlurryClientKey = "NS7ZP78CBVXH283QN3JB"

// Colors
let BlueColor = UIColor(fromHexString: "#3b5998")
let DarkGrey = UIColor(fromHexString: "#d8d8d8")

let MainBackgroundColor = UIColor(fromHexString: "")
let MainTextColor = UIColor(fromHexString: "#777777")

// Navbar
let NavbarDefaultBackgroundColor = UIColor(fromHexString: "#1c1c1c")
let NavBarHightlightedBackgroundColor = UIColor(fromHexString: "#e85769")


let KeyboardTableViewBackgroundColor = UIColor(fromHexString: "#f7f7f7")
let KeyboardTableSeperatorColor = DarkGrey
let KeyboardTableCoverArtViewBackgroundColor = DarkGrey


let BaseFont = UIFont(name: "Lato-Light", size: 20)
let SubtitleFont = UIFont(name: "Lato-Regular", size: 12)

let CoverArtViewImageWidth = 35.0