//
//  Constants.swift
//  Often
//
//  Created by Luc Success on 11/22/14.
//  Copyright (c) 2014 Project Surf Inc. All rights reserved.
//

import Foundation

#if DEBUG
    var BaseURL = "https://often-dev.firebaseio.com/"
    let KeyboardIdentifier = "com.tryoften.often.master.Keyboard"
#else
    var BaseURL = "https://often-dev.firebaseio.com/"
    let KeyboardIdentifier = "com.tryoften.often.Keyboard"
#endif
var AppStoreLink = "itms-apps://itunes.apple.com/app/id955090584"
let ParseAppID = "zOkdtEf6pbq3wHN7aTWVGe6tH236I6n934Wsr59g"
let ParseClientKey = "sojWTShuzJqnaXzusIihvyIiaCnksrlvuj9z7OKV"
let FabricAPIKey = "e869c8341ef7380d0df5ebd7131f8b82beb9ee82"
let FlurryClientKey = "NS7ZP78CBVXH283QN3JB"
let AnalyticsWriteKey = "rN5D0WO3nhtyXhzR7qgF1QYKhF9KWb6x"
let TwitterConsumerKey = "IIPYUMSsLg4ETYgYmvkfUZ37e"
let TwitterConsumerSecret = "OSDOYdrn8AlzPL7kNuwf0TK8tq80khTkvWGo7pqQtdOfQLaEx2"
let SpotifyClientID = "18c6ddb2612e40fba4338f64818d7f29"
let SpotifyConsumerSecret = "29b39cc7c0cb4093be316214e379056a"
let SoundcloudClientID = "7fe98f2e8f4b840cf05bea989a6d04f5"
let SoundcloudConsumerSecret = "c0d98423d7a0afa24e40a419cea0c141"
let OftenCallbackURL = "tryoften://"
let AppSuiteName = "group.com.tryoften.often"
let CrashlyticsAPIKey = "e4598140f72849daf847791f325b1eabae27a254"


// Colors
let BlueColor = UIColor(fromHexString: "#3B5998")
let DarkGrey = UIColor(fromHexString: "#d8d8d8")
let MediumGrey = UIColor(fromHexString: "#eeeeee")
let VeryLightGray = UIColor(fromHexString: "#f7f7f7")
let BlackColor = UIColor(fromHexString: "#121314")
let MediumLightGrey = UIColor(fromHexString: "#1c1c1c")
let MainBackgroundColor = UIColor(fromHexString: "#F7F7F7")
let MainTextColor = UIColor(fromHexString: "#777777")
let SubtitleGreyColor = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 0.74)
let LightBlackColor = UIColor(fromHexString: "#202020")
let LightGrey = UIColor(fromHexString: "#d3d3d3")
let WhiteColor = UIColor.whiteColor()
let TealColor = UIColor(fromHexString: "#21CE99")
let SystemBlackColor = UIColor.blackColor()
let SystemGrayColor = UIColor.grayColor()
let ClearColor = UIColor.clearColor()
let UnactiveTextColor = UIColor(fromHexString: "#808692")
//Font
let BaseFont = UIFont(name: "OpenSans-Light", size: 20)
let MediumRegularFont = UIFont(name: "OpenSans", size: 18)
let SubtitleFont = UIFont(name: "OpenSans", size: 12)
let ButtonFont = UIFont(name: "OpenSans", size: 15)
let TitleFont = UIFont(name: "Oswald-Regular", size: 19)


// Share Message
let ShareMessage = "Check out this new keyboard called Often! oftn.me/app"

// Navbar
let NavbarDefaultBackgroundColor = MediumLightGrey
let NavBarHightlightedBackgroundColor = UIColor(fromHexString: "#e85769")

let KeyboardHeight: CGFloat = 255
let KeyboardPackPickerDismissalViewHeight: CGFloat = 71
let KeyboardSearchBarHeight: CGFloat = 44.0
let KeyboardTabBarHeight: CGFloat = 44.0
let KeyboardTableViewBackgroundColor = LightGrey
let MediaItemsSectionHeaderHeight: CGFloat = 36.0
let KeyboardMediaItemDetailViewHeight: CGFloat = 219.5
let AlphabeticalSidebarWidth: CGFloat = 28.0

let KeyboardTableSeperatorColor = DarkGrey
let KeyboardTableCoverArtViewBackgroundColor = DarkGrey


let LyricTableViewCellNormalBackgroundColor = UIColor(fromHexString: "#f7f7f7")
let LyricTableViewCellHighlightedBackgroundColor = UIColor.whiteColor()

//App EdgeInsets
let mainAppSearchSuggestionsViewControllerContentInsets = UIEdgeInsetsMake(0, 0, 0, 0)
let mainAppSearchResultsCollectionViewControllerContentInsets = UIEdgeInsetsMake(0, 0, 0, 0)

// The color of the background that incapsulates the text
let LyricTableViewCellTextViewBackgroundColor = LightGrey
let LyricTableViewCellMainTitleFont = UIFont(name: "OpenSans", size: 14)
let LyricTableViewCellHeight: CGFloat = 75
let LyricTableViewCellInfoHeight: CGFloat = 50.0
let LyricTableViewCellInfoBackgroundColor = MediumGrey
let LyricTableViewCellIdentifier = "LyricTableViewCell"
let LyricSelectedEventIdentifier = "lyric:selected"

let CoverArtViewImageWidth: CGFloat = 35.0

let SectionPickerViewHeight: CGFloat = 35.5
let SectionPickerViewOpenedHeight: CGFloat = 200.0
let SectionPickerViewSwitchArtistHeight: CGFloat = 20.0
let SectionPickerViewBackgroundColor = UIColor.oftBlack74Color()

let SectionPickerViewCellHeight: CGFloat = 50.0
let SectionPickerViewCellNormalBackgroundColor = SectionPickerViewBackgroundColor
let SectionPickerViewCellHighlightedBackgroundColor = UIColor.oftBlackColor()
let SectionPickerViewCellTitleFont = BaseFont
let SectionPickerViewCellTitleFontColor = UIColor.oftWhiteColor()
let SectionPickerViewCurrentCategoryLabelTextColor = UIColor.oftBlackColor()

let NextKeyboardButtonBackgroundColor = UIColor.oftWhiteColor()
let NextKeyboardButtonFont = UIFont(name: "font_icons8", size:16)

let CategoriesCollectionViewBackgroundColor = UIColor.oftBlack74Color()
let CategoryCollectionViewCellBackgroundColor = UIColor(fromHexString: "#1c1c1c")
let CategoryCollectionViewCellTitleFont = UIFont(name: "OpenSans-Semibold", size: 10.5)
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

let ArtistCollectionViewCellBackgroundColor = UIColor.whiteColor()
let ArtistCollectionViewCellTitleTextColor = UIColor(fromHexString: "#121314")
let ArtistCollectionViewCellSubtitleTextColor = UIColor.oftDarkGrey74Color()
let ArtistCollectionViewCellTitleFont = UIFont(name: "OpenSans", size: 15)
let ArtistCollectionViewCellSubtitleFont = UIFont(name: "OpenSans", size: 8)
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
let WalkthroughSubTitleFontColor = UIColor(fromHexString: "#0F1010")
let WalkthroughBackgroungColor = UIColor(fromHexString: "#F7F7F7")
let WalkthroughEmailSpaceBackgroundColor = UIColor(fromHexString: "#E4E4E4")

let AddArtistsTableViewCellReuseIdentifier = "signUpAddArtistsTableViewCell"
let UserProfileHeaderViewReuseIdentifier = "UserProfileHeaderView"

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
let ArtistCollectionViewImageViewBackgroundColor = UIColor(fromHexString: "#f7f7f7")
let ArtistCollectionViewDeleteButtonColor = UIColor(fromHexString: "#f19720")
let ArtistCollectionViewCellCircleLayerColorStrokeAndFillColor = UIColor.clearColor()
let ArtistPickerCollectionViewControllerBackgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.73)
let ArtistPickerCollectionViewCellBackgroundColor = UIColor.clearColor()

//Browse Collection View Cell
let BrowseCollectionViewCellRankLabelFont = UIFont(name: "OpenSans", size: 16.0)
let BrowseCollectionViewCellTrackNameLabelFont = UIFont(name: "OpenSans", size: 14.0)
let BrowseCollectionViewCellLyricCountLabelFont = UIFont(name: "OpenSans", size: 9.0)
let BrowseCollectionCellLineBreakViewColor = UIColor(fromHexString: "#d3d3d3")
let BrowseCollectionViewCellBackgroundColor = UIColor(fromHexString: "#f7f7f7")
let BrowseHeaderCollectionViewCellConfirmViewColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
let BrowseHeaderCollectionViewControllerBackground = UIColor.clearColor()
let BrowseHeaderViewTintViewColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
let BrowseHeaderViewArtistNameLabelColor = UIColor.whiteColor()
let BrowseHeaderViewArtistNameLabelFont = UIFont(name: "Montserrat-Regular", size: 24.0)
let BrowseHeaderViewArtistTopLabelFont = UIFont(name: "Montserrat-Regular", size: 18.0)
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
let ErrorMessageFont = UIFont(name: "OpenSans-Semibold", size: 11)
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
let TrendingHeaderViewBackgroundColor = UIColor.whiteColor()
let TrendingHeaderViewTopLabelFont = UIFont(name: "Montserrat-Regular", size: 18.0)
let TrendingHeaderViewTopLabelBackgroundColor = UIColor.whiteColor()
let TrendingHeaderViewTabViewBackgroundColor = UIColor.blackColor()
let TrendingHeaderViewSongTitleLabelTextFont = UIFont(name: "OpenSans", size: 12.0)
let TrendingHeaderViewArtistNameLabelTextFont = UIFont(name: "Montserrat-Regular", size: 18.0)
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
let TrendingSectionHeaderViewTrendingLabelFont = UIFont(name: "OpenSans-Semibold", size: 10.0)
let TrendingSectionHeaderViewBottomLineBreakBackgroundColor = UIColor(fromHexString: "#d3d3d3")

//User Profile Header View
let UserProfileHeaderViewBackgroundColor = UIColor.whiteColor()
let UserProfileHeaderViewCoverPhotoTintViewBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.36)
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

//Signup View
let SignupViewTitleLabelFont = UIFont(name: "Montserrat-Regular", size: 15)
let SignupViewTitleLabelFontColor = UIColor(fromHexString: "#2B2B2B")
let SignupViewAppDescriptionLabelFont = UIFont(name: "OpenSans", size: 14)
let SignupViewAppDescriptionLabelFontColor = UIColor(fromHexString: "#202020")
let SignupViewPageControlHighlightColor = UIColor(fromHexString: "#21CE99")
let SignupViewCreateAccountButtonColor = UIColor(fromHexString: "#21CE99")
let SignupViewCreateAccountButtonFontColor = UIColor.whiteColor()
let SignupViewCreateAccountButtonFont = UIFont(name: "Montserrat-Regular", size: 15)
let SignupViewSkipButtonFont = UIFont(name: "Montserrat-Regular", size: 15)
let SignupViewSkipButtonFontColor = UIColor(fromHexString: "#152036")
let SignupViewSigninButtonFont = UIFont(name: "Montserrat-Regular", size: 15)
let SignupViewSigninButtonFontColor = UIColor(fromHexString: "#152036")

//Create Account View
let CreateAccountViewTitleLabelFont = UIFont(name: "Montserrat-Regular", size: 15)
let CreateAccountViewTitleLabelFontColor = UIColor.blackColor()
let CreateAccountViewSubtitleLabelFont = UIFont(name: "OpenSans", size: 15)
let CreateAccountViewSubtitleLabelFontColor = UIColor(fromHexString: "#202020")
let CreateAccountViewButtonDividersColor = LightBlackColor
let CreateAccountViewSignupButtonFont = UIFont(name: "Montserrat-Regular", size: 15)
let CreateAccountViewSignupButtonFontColor = WhiteColor
let CreateAccountViewSignupButtonColor = UIColor(fromHexString: "#D8D8D8")
let CreateAccountViewSignupButtonHighlightedColor = UIColor(fromHexString: "#152036")
let CreateAccountViewSignupTwitterButtonFont = UIFont(name: "Montserrat-Regular", size: 15)
let CreateAccountViewSignupTwitterButtonFontColor = WhiteColor
let CreateAccountViewSignupTwitterButtonColor = UIColor(fromHexString: "#62A9E0")

//Sign In View
let SigninViewTitleLabelFont = UIFont(name: "Montserrat-Regular", size: 15)
let SigninViewTitleLabelFontColor = UIColor.blackColor()
let SigninViewSubtitleLabelFont = UIFont(name: "OpenSans", size: 15)
let SigninViewSubtitleLabelFontColor = UIColor(fromHexString: "#202020")
let SigninViewButtonDividersColor = LightBlackColor
let SigninViewSigninButtonFont = UIFont(name: "Montserrat-Regular", size: 15)
let SigninViewSigninButtonFontColor = WhiteColor
let SigninViewSigninButtonColor = UIColor(fromHexString: "#D8D8D8")
let SigninViewSigninButtonHighlightedColor = UIColor(fromHexString: "#152036")
let SigninViewSigninTwitterButtonFont = UIFont(name: "Montserrat-Regular", size: 15)
let SigninViewSigninTwitterButtonFontColor = UIColor(fromHexString: "#62A9E0")
let SigninViewSigninTwitterButtonColor = WhiteColor

//WalkthroughViewController
let WalkthroughViewControllerNextButtonFont = UIFont(name: "OpenSans-Semibold", size: 15)
let WalkthroughViewControllerNextButtonBackgroundColor = UIColor(fromHexString: "#2CD2B4")

//Settings View Cell
let SettingsViewCellSecondaryTextColor = UIColor(fromHexString: "202020")

// Main App
let FacebookButtonTitleFont = UIFont(name: "OpenSans", size: 14)
let FacebookButtonTitleTextColor = UIColor.whiteColor()
let FacebookButtonIconFont = UIFont(name: "SSSocialRegular", size: 24)
let FacebookButtonNormalBackgroundColor = BlueColor
let FacebookButtonHighlightedBackgroundColor = UIColor(fromHexString: "#4d75c7")

let HomeViewBackgroundColor = UIColor(fromHexString: "#f7f7f7")
let HomeViewSubtitle = UIFont(name: "OpenSans", size: 14)

// Search Bar 
let SearchBarBackgroundColor = UIColor(fromHexString: "F3F3F3")
let SearchBarPlaceholderText: String = "Search"

// Empty State Views
let TwitterButtonColor = UIColor(fromHexString: "#62A9E0")

//Pack Cells
let PackCellWidth: CGFloat = 171
let PackCellHeight: CGFloat = 237.0

