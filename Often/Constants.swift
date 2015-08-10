//
//  Constants.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/22/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import Foundation

#if DEBUG
    let BaseURL = "https://drizzy-db-dev.firebaseio.com/"
#else
    let BaseURL = "https://multi-keyboards.firebaseio.com/"
#endif
let AppStoreLink = "itms-apps://itunes.apple.com/app/id955090584"
let ParseAppID = "L1f21j1lJQuu5xtP17BxdEH1qHWD1VSb6M1otl5G"
let ParseClientKey = "TQDQM9tDsLSC31qH1zaPvHtNpyfaVcxaUAHe8OiN"
let FlurryClientKey = "NS7ZP78CBVXH283QN3JB"
let AnalyticsWriteKey = "LBptokrz7FVy55NOfwLpFBdt6fdBh7sI"
let AppSuiteName = "group.com.tryoften.often"
let CrashlyticsAPIKey = "e4598140f72849daf847791f325b1eabae27a254"
let VenmoAppSecret = "9Bexp2xAQ2hfN57LDVCBYCzRQXJXrRba"
let VenmoAccessToken = "dpswtdsGaTL3cpCGZm9XYtwPzkVcDexA"
let VenmoAppID = "2804"

// Colors
let BlueColor = UIColor(fromHexString: "#4575BF")
let DarkGrey = UIColor(fromHexString: "#d8d8d8")
let MediumGrey = UIColor(fromHexString: "#eeeeee")
let VeryLightGray = UIColor(fromHexString: "#f7f7f7")
let BlackColor = UIColor(fromHexString: "#121314")
let MediumLightGrey = UIColor(fromHexString: "#1c1c1c")
let MainBackgroundColor = UIColor(fromHexString: "")
let MainTextColor = UIColor(fromHexString: "#777777")
let SubtitleGreyColor = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 0.74)
let LightBlackColor = UIColor(fromHexString: "#303030")
let LightGrey = UIColor(fromHexString: "#d3d3d3")
let WhiteColor = UIColor.whiteColor()
let TealColor = UIColor(fromHexString: "#14E09E")
let SystemBlackColor = UIColor.blackColor()
let SystemGrayColor = UIColor.grayColor()
let ClearColor = UIColor.clearColor()
//Font
let BaseFont = UIFont(name: "OpenSans-Light", size: 20)
let MediumRegularFont = UIFont(name: "OpenSans-Regular", size: 18)
let SubtitleFont = UIFont(name: "OpenSans", size: 12)
let ButtonFont = UIFont(name: "OpenSans", size: 15)
let TitleFont = UIFont(name: "Oswald-Regular", size: 19)


// Navbar
let NavbarDefaultBackgroundColor = MediumLightGrey
let NavBarHightlightedBackgroundColor = UIColor(fromHexString: "#e85769")

let KeyboardHeight: CGFloat = 255
let KeyboardSearchBarHeight: CGFloat = 44.0
let KeyboardTableViewBackgroundColor = LightGrey

let KeyboardTableSeperatorColor = DarkGrey
let KeyboardTableCoverArtViewBackgroundColor = DarkGrey


let LyricTableViewCellNormalBackgroundColor = UIColor(fromHexString: "#f7f7f7")
let LyricTableViewCellHighlightedBackgroundColor = UIColor.whiteColor()

// The color of the background that incapsulates the text
let LyricTableViewCellTextViewBackgroundColor = LightGrey
let LyricTableViewCellMainTitleFont = UIFont(name: "OpenSans", size: 14)
let LyricTableViewCellHeight: CGFloat = 75
let LyricTableViewCellInfoHeight: CGFloat = 50.0
let LyricTableViewCellInfoBackgroundColor = MediumGrey
let LyricTableViewCellIdentifier = "LyricTableViewCell"
let LyricSelectedEventIdentifier = "lyric:selected"

let CoverArtViewImageWidth: CGFloat = 35.0

let SectionPickerViewHeight: CGFloat = 55.0
let SectionPickerViewSwitchArtistHeight: CGFloat = 20.0
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
let CategoryCollectionViewCellTitleFont = UIFont(name: "OpenSans", size: 15)
let CategoryCollectionViewCellSubtitleFont = UIFont(name: "OpenSans", size: 10)
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
let ArtistCollectionViewCellTitleFont = UIFont(name: "OpenSans", size: 16)
let ArtistCollectionViewCellSubtitleFont = UIFont(name: "OpenSans", size: 10)
let ArtistCollectionViewCellWidth: CGFloat = 135
let ArtistCollectionViewCellImageViewLeftMargin: CGFloat = 32

let BrowseCollectionViewCellBackgroudColor = UIColor(fromHexString: "#f7f7f7")
let BrowseCollectionViewCellTrackNameFont = UIFont(name: "OpenSans", size: 14.0)
let BrowseCollectionViewCellLyricCountFont = UIFont(name: "OpenSans", size: 9.0)
let BrowseCollectionViewCellWidth: CGFloat = CGFloat(UIScreen.mainScreen().bounds.width)
let BrowseCollectionViewCellHeight: CGFloat = CGFloat(63)
let BrowseHeaderCollectionViewPadding: CGFloat = 75.0

//walkthroughFonts
let WalkthroughNavBarTitleFont = UIFont(name: "OpenSans-Semibold", size: 18)
let WalkthroughTitleFont = UIFont(name: "Oswald-Regular", size: 22)
let WalkthroughTextFieldFont = UIFont(name: "OpenSans", size: 14)
let WalkthroughTableViewCellSubtitleFont = UIFont(name: "OpenSans", size: 10)
let WalkthroughSpacerFront = UIFont(name: "OpenSans-Italic", size: 12)

//walkthroughColors
let WalkthroughErrorMessageBackgroundColor = UIColor(fromHexString: "#E85769")
let WalkthroughNavBarTitleFontColor = UIColor.whiteColor()
let WalkthroughTitleFontColor = UIColor(fromHexString: "#202020")
let WalkthroughSubTitleFontColor = UIColor(fromHexString: "#121314")
let WalkthroughBackgroungColor = UIColor(fromHexString: "#F7F7F7")
let WalkthroughEmailSpaceBackgroundColor = UIColor(fromHexString: "#E4E4E4")

let AddArtistsTableViewCellReuseIdentifier = "signUpAddArtistsTableViewCell"

//Add Artist Button Font
let AddArtistsButtonFont = UIFont(name: "OpenSans", size: 12.0)

//Add Artist Button Color
let RemoveArtistsButtonTitleColor = UIColor.whiteColor()
let RemoveArtistsButtonBackgroundColor = UIColor.clearColor()
let RemoveArtistsButtonBorderColor = UIColor.whiteColor().CGColor
let AddArtistsButtonTitleColor = UIColor.blackColor()
let AddArtistsButtonBackgroundColor = UIColor(fromHexString: "#F9B341")

//Add Artist Modal Collection Color
let AddArtistModalCollectionBackgroundColor = UIColor.whiteColor()
let AddArtistModalCollectionModalBackgroundColor = UIColor.clearColor()
let AddArtistModalCollectionCloseButtonFont = UIFont(name: "OpenSans-Bold", size: 15.0)
let AddArtistModalCollectionCloseButtonColor = UIColor.blackColor()
let AddArtistModalCollectionModalMainViewBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
let AddArtistModalCollectionNameLabelColor = UIColor(fromHexString: "#d3d3d3")
let AddArtistModalCollectionNameLabelFont = UIFont(name: "Oswald-Light", size: 22.0)
let AddArtistModalCollectionTopLabelFont = UIFont(name: "OpenSans", size: 18.0)
let AddArtistModalHeaderViewBackgroundColor = UIColor(fromHexString: "#f7f7f7")
let ArtistCollectionViewCellCircleLayerColor = UIColor(fromHexString: "#f19720")
let ArtistCollectionViewImageViewBackgroundColor = UIColor.blackColor()
let ArtistCollectionViewDeleteButtonColor = UIColor(fromHexString: "#f19720")
let ArtistCollectionViewCellCircleLayerColorStrokeAndFillColor = UIColor.clearColor()
let ArtistPickerCollectionViewControllerBackgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.73)
let ArtistPickerCollectionViewCellBackgroundColor = UIColor.clearColor()

//Browse Collection View Cell
let BrowseCollectionViewCellRankLabelFont = UIFont(name: "OpenSans", size: 16.0)
let BrowseCollectionViewCellTrackNameLabelFont = UIFont(name: "OpenSans", size: 14.0)
let BrowseCollectionViewCellLyricCountLabelFont = UIFont(name: "OpenSans", size: 9.0)
let BrowseCollectionCellLineBreakViewColor = UIColor(fromHexString: "#d3d3d3")
let BrowseCollectionViewCellBackgroundColor = UIColor.whiteColor()
let BrowseHeaderCollectionViewCellConfirmViewColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
let BrowseHeaderCollectionViewControllerBackground = UIColor.clearColor()
let BrowseHeaderViewTintViewColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
let BrowseHeaderViewArtistNameLabelColor = UIColor.whiteColor()
let BrowseHeaderViewArtistNameLabelFont = UIFont(name: "Oswald-Light", size: 24.0)
let BrowseHeaderViewArtistTopLabelFont = UIFont(name: "OpenSans", size: 18.0)
let BrowseHeaderViewArtistTopLabelColor = UIColor.whiteColor()
let BrowseHeaderCollectionViewCellLayerShadowColor = UIColor.blackColor()
let BrowseHeaderViewBackgroundColor = UIColor(fromHexString: "#f7f7f7")

// Browse Section Header View
let BrowseSectionHeaderViewSongsLabelFont = UIFont(name: "OpenSans", size: 10.0)
let BrowseSectionHeaderViewLineBreakColor = UIColor(fromHexString: "#d3d3d3")
let BrowseSectionHeaderViewBackgroundColor = UIColor(fromHexString: "#ffffff")


// Base Navigation Bar
let NavigationBarColor = UIColor.whiteColor()

//Category Collection View Cell
let CategoryCollectionViewCellTitleLabelTextColor = UIColor.whiteColor()

//PhoneNumberWalkthroughViewController
let PhoneNumberWalkthroughViewControllerSkipButtonFont = UIFont(name: "OpenSans-Semibold", size: 13)

//SignUpPreAddArtistsLoaderViewController
let SignUpPreAddArtistsLoaderViewControllerTitleLabelFont = UIFont(name: "OpenSans-Semibold", size: 18)

//Keyboard Installation Walkthrough ViewController
let KeyboardInstallationWalkthroughViewControllerBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
let KeyboardInstallationWalkthroughViewControllerToolbarColor = UIColor.blackColor()
let KeyboardInstallationWalkthroughViewControllerScrollViewColor = UIColor.whiteColor()
let KeyboardInstallationWalkthroughViewControllerPageIndicatorTintColor = UIColor.grayColor()
let KeyboardInstallationWalkthroughViewControllerCurrentPageIndicatorTintColor = UIColor.whiteColor()

let KeyboardInstallationWalkthroughViewControllerGotItButtonColor = UIColor.whiteColor()
//Keyboard Walkthrough View
let KeyboardWalkthroughViewBackgroundColor = UIColor.whiteColor()

//Login View
let LoginViewTextFieldBackgroundColor = UIColor.whiteColor()

//Select Artist Walkthrough ViewController
let SelectArtistWalkthroughViewControllerSpacerColor = UIColor(fromHexString: "#E4E4E4")
let SelectArtistWalkthroughViewControllerHeaderViewColor = UIColor.whiteColor()
let SelectArtistWalkthroughViewControllerRecommendedLabelFont = UIFont(name: "OpenSans", size: 9)

//SignUp Confirm Password View
let SignUpBackgroundColor = UIColor.whiteColor()
let SignUpConfirmPasswordViewTitleLabelFont = UIFont(name: "OpenSans-Semibold", size: 18)
let SignUpSpacerColor = UIColor.blackColor()
let SignUpButtonFontColor = UIColor.whiteColor()

//Settings TableViewCell
let SettingsTableViewCellLabelViewTextColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.74)
let SettingsTableViewCellLabelViewTextFont = UIFont(name: "OpenSans", size: 14.0)
let SettingsTableViewCellBackgroundColor = UIColor.clearColor()
let SettingsTableViewControllerNavBarLabelFont = UIFont(name: "OpenSans", size: 15.0)
let SettingsTableViewControllerNavBarLabelFontColor = UIColor.whiteColor()
let SettingsTableViewControllerNavBarLabelBackgroundColor = UIColor.clearColor()
let SettingsTableViewControllerBackgroundColor = UIColor(fromHexString: "#202020")
let SettingsTableViewControllerNavBarBackgroundColor = UIColor.blackColor()

//SignUp Add Artists LoaderView
let SignUpAddArtistsLoaderViewBackgroundColor = UIColor.whiteColor()
let SignUpAddArtistsTableViewCellImageViewBackgroundColor = UIColor.blueColor()

//ErrorMessageView
let ErrorMessageFont = UIFont(name: "OpenSans-Semibold", size: 10)
let ErrorMessageFontColor = UIColor.whiteColor()

//TabBarController
let TabBarControllerBarBorderViewBackgroundColor = UIColor(fromHexString: "#f9b341")
let TabBarControllerBackgroundColor = UIColor.blackColor()
let TabBarControllerTabBarBackgroundColor = UIColor(fromHexString: "#f9b341")
let TabBarControllerInstallKeyboardButtonBackgroundColor = UIColor(fromHexString: "#4167e1")
let TabBarControllerInstallKeyboardButtonFontColor = UIColor.whiteColor()

//Terms And Privacy View
let TermsAndPrivacyViewButtonColor = UIColor.blueColor()

//Trending CollectionViewCell
let TrendingCollectionViewCellRankLabelFont = UIFont(name: "OpenSans", size: 16.0)
let TrendingCollectionViewCellNameLabelFont = UIFont(name: "OpenSans", size: 14.0)
let TrendingCollectionViewCellSubLabelFont = UIFont(name: "OpenSans", size: 9.0)
let TrendingCollectionViewCellLineBreakColor = UIColor(fromHexString: "#d3d3d3")
let TrendingCollectionViewCellBackgroundColor = UIColor.whiteColor()
let TrendingHeaderViewTintViewBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.18)

//Trending Header View
let TrendingHeaderViewBackgroundColor = UIColor.blackColor()
let TrendingHeaderViewTopLabelFont = UIFont(name: "OpenSans", size: 18.0)
let TrendingHeaderViewTopLabelBackgroundColor = UIColor.whiteColor()
let TrendingHeaderViewTabViewBackgroundColor = UIColor.blackColor()
let TrendingHeaderViewNameLabelTextFont = UIFont(name: "Oswald-Light", size: 24.0)
let TrendingHeaderViewNameLabelTextColor = UIColor.whiteColor()
let TrendingHeaderViewFeaturedButtonTextFont = UIFont(name: "OpenSans", size: 10.0)
let TrendingHeaderViewFeaturedButtonBackgroundColor = UIColor.whiteColor()
let TrendingHeaderViewFeaturedButtonFontColor = UIColor.blackColor()
let TrendingHeaderViewArtistsButtonTextFont = UIFont(name: "OpenSans", size: 14.0)
let TrendingHeaderViewArtistsButtonFontColor = UIColor.lightGrayColor()
let TrendingHeaderViewArtistsButtonSelectedFontColor = UIColor(fromHexString: "#FFB316")
let TrendingHeaderViewLyricsButtonTextFont = UIFont(name: "OpenSans", size: 14.0)
let TrendingHeaderViewLyricsButtonNormalFontColor = UIColor.lightGrayColor()
let TrendingHeaderViewLyricsButtonSelectedFontColor = UIColor(fromHexString: "#FFB316")

//Trending Lyric View Cell
let TrendingLyricViewCellBackgroundColor = UIColor(fromHexString: "#ffffff")
let TrendingLyricViewCellRankLabelFont = UIFont(name: "OpenSans", size: 16.0)
let TrendingLyricViewCellLyricTextViewlFont = UIFont(name: "OpenSans", size: 12.0)
let TrendingLyricViewCellArtistLabelFont = UIFont(name: "OpenSans", size: 10.0)
let TrendingLyricViewCellArtistLabelTextColor = UIColor.orangeColor()
let TrendingLyricViewCellLineBreakViewBackgroundColor = UIColor(fromHexString: "#d3d3d3")
let TrendingLyricViewCellTouchViewBackgroundColor = UIColor.clearColor()

//Trending Section Header View
let TrendingSectionHeaderViewBackgroundColor = UIColor(fromHexString: "#ffffff")
let TrendingSectionHeaderViewTrendingLabelFont = UIFont(name: "OpenSans", size: 10.0)
let TrendingSectionHeaderViewBottomLineBreakBackgroundColor = UIColor(fromHexString: "#d3d3d3")

//User Profile Header View
let UserProfileHeaderViewBackgroundColor = UIColor.whiteColor()
let UserProfileHeaderViewCoverPhotoTintViewBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
let UserProfileHeaderViewProfileImageViewBackgroundColor = UIColor.whiteColor().CGColor
let UserProfileHeaderViewMetadataViewBackgroundColor = UIColor.whiteColor()
let UserProfileHeaderViewNameLabelFont = UIFont(name: "OpenSans-Semibold", size: 14)
let UserProfileHeaderViewKeyboardCountLabelFont = UIFont(name: "OpenSans", size: 10)

//User Profile Section Header View
let UserProfileSectionHeaderViewBackgroundColor = UIColor.whiteColor()
let UserProfileSectionHeaderViewSeperatorViewBackgroundColor = UIColor(fromHexString: "#f1f1f1")
let UserProfileSectionHeaderViewTitleLabelFont = UIFont(name: "OpenSans", size: 15)
let UserProfileSectionHeaderViewEditButtonFont = UIFont(name: "OpenSans", size: 15)
let UserProfileSectionHeaderViewEditButtonFontColor = UIColor(fromHexString: "#868686")

//UserProfileViewController
let UserProfileViewControllerCollectionViewBackgroundColor = UIColor.whiteColor()
let UserProfileViewControllerCellBackgroundColor = UIColor.whiteColor()
let UserProfileViewControllerArtistPickerViewBackgroundColor = UIColor.clearColor()
let UserProfileViewControllerStatusViewBackgroundColor = UIColor.whiteColor()
let UserProfileViewControllerStatusViewImageViewShadowColor = UIColor.blackColor().CGColor
let UserProfileViewControllerStatusViewTitleLabelFont = UIFont(name: "Oswald-Light", size: 24.0)
let UserProfileViewControllerStatusViewTitleLabelBackgroundColor = UIColor.clearColor()
let UserProfileViewControllerStatusViewSubTitleLabelFont = UIFont(name: "OpenSans", size: 12.0)
let UserProfileViewControllerStatusViewSubTitleLabelBackgroundColor = UIColor.clearColor()
//WalkthroughViewController
let WalkthroughViewControllerNextButtonFont = UIFont(name: "OpenSans-Semibold", size: 15)
let WalkthroughViewControllerNextButtonBackgroundColor = UIColor(fromHexString: "#2CD2B4")
// Main App
let FacebookButtonTitleFont = UIFont(name: "OpenSans", size: 14)
let FacebookButtonTitleTextColor = UIColor.whiteColor()
let FacebookButtonIconFont = UIFont(name: "SSSocialRegular", size: 24)
let FacebookButtonNormalBackgroundColor = BlueColor
let FacebookButtonHighlightedBackgroundColor = UIColor(fromHexString: "#4d75c7")

let HomeViewBackgroundColor = UIColor(fromHexString: "#f7f7f7")
let HomeViewSubtitle = UIFont(name: "OpenSans", size: 14)