//
//  Constants.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/22/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import Foundation

var BaseURL = "https://multi-keyboards.firebaseio.com/"
#if DEBUG
let CategoryServiceEndpoint = "https://brilliant-fire-154.firebaseio.com/"
#else
let CategoryServiceEndpoint = "https://blinding-fire-1400.firebaseio.com/" // production
#endif

let AppStoreLink = "itms-apps://itunes.apple.com/app/id955090584"
let ParseAppID = "L1f21j1lJQuu5xtP17BxdEH1qHWD1VSb6M1otl5G"
let ParseClientKey = "TQDQM9tDsLSC31qH1zaPvHtNpyfaVcxaUAHe8OiN"
let FlurryClientKey = "NS7ZP78CBVXH283QN3JB"
let AnalyticsWriteKey = "LBptokrz7FVy55NOfwLpFBdt6fdBh7sI"

// Colors
let BlueColor = UIColor(fromHexString: "#3b5998")
let DarkGrey = UIColor(fromHexString: "#d8d8d8")
let MediumGrey = UIColor(fromHexString: "#eeeeee")
let LightGrey = UIColor(fromHexString: "#f7f7f7")
let BlackColor = UIColor(fromHexString: "#121314")
let MediumLightGrey = UIColor(fromHexString: "#1c1c1c")
let MainBackgroundColor = UIColor(fromHexString: "")
let MainTextColor = UIColor(fromHexString: "#777777")


let BaseFont = UIFont(name: "Lato-Light", size: 20)
let MediumRegularFont = UIFont(name: "Lato-Regular", size: 18)
let SubtitleFont = UIFont(name: "Lato-Regular", size: 12)

// Navbar
let NavbarDefaultBackgroundColor = MediumLightGrey
let NavBarHightlightedBackgroundColor = UIColor(fromHexString: "#e85769")

let KeyboardHeight: CGFloat = 240
let KeyboardTableViewBackgroundColor = LightGrey
let KeyboardTableSeperatorColor = DarkGrey
let KeyboardTableCoverArtViewBackgroundColor = DarkGrey

let LyricTableViewCellNormalBackgroundColor = UIColor(fromHexString: "#f7f7f7")
let LyricTableViewCellHighlightedBackgroundColor = UIColor.whiteColor()

// The color of the background that incapsulates the text
let LyricTableViewCellTextViewBackgroundColor = LightGrey
let LyricTableViewCellMainTitleFont = UIFont(name: "Lato-Regular", size: 15)
let LyricTableViewCellHeight: CGFloat = 75
let LyricTableViewCellInfoHeight: CGFloat = 50.0
let LyricTableViewCellInfoBackgroundColor = MediumGrey
let LyricTableViewCellIdentifier = "LyricTableViewCell"
let LyricSelectedEventIdentifier = "lyric:selected"

let CoverArtViewImageWidth: CGFloat = 35.0

let SectionPickerViewHeight: CGFloat = 55.0
let SectionPickerViewSwitchArtistHeight: CGFloat = 18.0
let SectionPickerViewBackgroundColor = BlackColor

let SectionPickerViewCellHeight: CGFloat = 50.0
let SectionPickerViewCellNormalBackgroundColor = SectionPickerViewBackgroundColor
let SectionPickerViewCellHighlightedBackgroundColor = UIColor.blackColor()
let SectionPickerViewCellTitleFont = BaseFont
let SectionPickerViewCellTitleFontColor = UIColor.whiteColor()
let SectionPickerViewCurrentCategoryLabelTextColor = UIColor.whiteColor()

let NextKeyboardButtonBackgroundColor = BlackColor
let NextKeyboardButtonFont = UIFont(name: "font_icons8", size:16)

let CategoriesCollectionViewBackgroundColor = BlackColor
let CategoryCollectionViewCellBackgroundColor = UIColor(fromHexString: "#1c1c1c")
let CategoryCollectionViewCellTitleFont = UIFont(name: "Lato-Regular", size: 18)
let CategoryCollectionViewCellSubtitleFont = UIFont(name: "Lato-Regular", size: 10)
let CategoryCollectionViewCellSubtitleTextColor = UIColor(fromHexString: "#aeb5b8")
let CategoryCollectionViewCellReuseIdentifier = "CategoryCollectionViewCell"
let CategoryCollectionViewCellHighlightColors = [
    "#e85769", //Red
    "#5d82f7", //Blue
    "#f19720", //Orange
    "#21ce99", //Green
    "#a065d8", //Purple
    "#2db8ff" //Light Blue
]

let ArtistCollectionViewCloseButtonBackgroundColor = UIColor(fromHexString: "#121314")

let ArtistCollectionViewCellBackgroundColor = UIColor(fromHexString: "#121314")
let ArtistCollectionViewCellTitleTextColor = UIColor.whiteColor()
let ArtistCollectionViewCellSubtitleTextColor = CategoryCollectionViewCellSubtitleTextColor
let ArtistCollectionViewCellTitleFont = UIFont(name: "Lato-Regular", size: 16)
let ArtistCollectionViewCellSubtitleFont = UIFont(name: "Lato-Regular", size: 10)
let ArtistCollectionViewCellWidth: CGFloat = 135
let ArtistCollectionViewCellImageViewLeftMargin: CGFloat = 32

// Main App

let FacebookButtonTitleFont = UIFont(name: "Lato-Regular", size: 18)
let FacebookButtonTitleTextColor = UIColor.whiteColor()
let FacebookButtonIconFont = UIFont(name: "SSSocialRegular", size: 24)
let FacebookButtonNormalBackgroundColor = BlueColor
let FacebookButtonHighlightedBackgroundColor = UIColor(fromHexString: "#4d75c7")

let HomeViewBackgroundColor = UIColor(fromHexString: "#f7f7f7")