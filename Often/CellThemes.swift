////
////  CellThemes.swift
////  Often
////
////  Created by Katelyn Findlay on 2/16/16.
////  Copyright © 2016 Surf Inc. All rights reserved.
////
//
//import Foundation
//import Gaikan
//
//public class NavigationTabTheme: Theme {
//    public func styles() -> [String : Style] {
//        return [
//            "tab": Style() { (inout style: StyleRule) -> () in
//                style.background = WhiteColor
//            },
//            
//            "active-highlight": Style() { (inout style: StyleRule) -> () in
//                style.color = TealColor
//            },
//            
//            "active-icon": Style() { (inout style: StyleRule) -> () in
//                style.color = LightBlackColor
//            },
//            
//            "inactive-icon": Style() { (inout style: StyleRule) -> () in
//                style.color = LightBlackColor.colorWithAlphaComponent(0.54)
//            },
//            
//        ]
//    }
//}
//
//public class StickyHeaderViewTheme: Theme {
//    public func styles() -> [String : Style] {
//        return [
//            "text-label": Style() { (inout style: StyleRule) -> () in
//                style.font = UIFont(name: "OpenSans", size: 9)
//                style.color = LightBlackColor.colorWithAlphaComponent(0.74)
//                // character spacing : 2
//                // font weight: semi bold (400)
//                // uppercase
//            },
//            
//            "header": Style() { (inout style: StyleRule) -> () in
//                style.background = MainBackgroundColor
//            },
//            
//            "tab-spacer": Style() { (inout style: StyleRule) -> () in
//                style.color = DarkGrey
//            }
//            
//            // artist image - 18 x 18, border-radius = 3
//        ]
//    }
//}
//
//public class KeyboardSearchBarTheme: Theme {
//    public func styles() -> [String : Style] {
//        return [
//            "search-header": Style() { (inout style: StyleRule) -> () in
//                style.background = MainBackgroundColor
//            },
//            
//            "tab-spacer": Style() { (inout style: StyleRule) -> () in
//                style.color = DarkGrey
//            },
//            
//            "text-label": Style() { (inout style: StyleRule) -> () in
//                style.font = UIFont(name: "OpenSans", size: 12)
//                style.color = LightBlackColor.colorWithAlphaComponent(0.54)
//                // character spacing : 0.5
//            }
//            
//            // search box border
//            // DarkGrey
//            // 1.5
//        ]
//    }
//}
//
//public class BreadcrumbNavBarTheme: Theme {
//    public func styles() -> [String : Style] {
//        return [
//            "track-label": Style() { (inout style: StyleRule) -> () in
//                style.font = UIFont(name: "OpenSans", size: 12)
//                style.color = LightBlackColor.colorWithAlphaComponent(0.9)
//                //font weight: semibold
//            },
//            
//            "artist-label": Style() { (inout style: StyleRule) -> () in
//                style.font = UIFont(name: "OpenSans", size: 10.5)
//                style.color = LightBlackColor.colorWithAlphaComponent(0.54)
//            },
//            
//            "lyric-count-label": Style() { (inout style: StyleRule) -> () in
//                style.font = UIFont(name: "OpenSans", size: 9)
//                style.color = LightBlackColor.colorWithAlphaComponent(0.54)
//                //font weight: semibold
//                // character spacing: 2
//            },
//        ]
//    }
//}
//
//
//// Card Themes
//public class CardTheme: Theme {
//    public func styles() -> [String : Style] {
//        return [
//            "card": Style() { (inout style: StyleRule) -> () in
//                style.background = WhiteColor
//                // border radius = 2
//                // drop shadow BlackColor.colorWithAlphaComponent(0.19), Y-1, Blur-2
//            }
//        ]
//    }
//}
//
//public class LyricCardTheme: CardTheme {
//    public override func styles() -> [String : Style] {
//        super.styles()
//        return [
//            "artist-label": Style() { (inout style: StyleRule) -> () in
//                style.font = UIFont(name: "OpenSans", size: 10.5)
//                style.color = LightBlackColor.colorWithAlphaComponent(0.74)
//            },
//            
//            "track-label": Style() { (inout style: StyleRule) -> () in
//                style.font = UIFont(name: "OpenSans", size: 10)
//                style.color = SystemBlackColor.colorWithAlphaComponent(0.54)
//            },
//            
//            "lyrics-text": Style() { (inout style: StyleRule) -> () in
//                style.font = UIFont(name: "OpenSans", size: 9)
//                style.color = SystemBlackColor.colorWithAlphaComponent(0.74)
//                // character spacing = 1.5
//            }
//            
//            // artist image - 18 x 18, border-radius = 2
//        ]
//    }
//}
//
//public class ArtistCardTheme: CardTheme {
//    public override func styles() -> [String : Style] {
//        super.styles()
//        return [
//            "artist-label": Style() { (inout style: StyleRule) -> () in
//                style.font = UIFont(name: "OpenSans", size: 14)
//                style.color = LightBlackColor.colorWithAlphaComponent(0.9)
//                // character spacing = 1
//            },
//            
//            "track-count-label": Style() { (inout style: StyleRule) -> () in
//                style.font = UIFont(name: "OpenSans", size: 8)
//                style.color = LightBlackColor.colorWithAlphaComponent(0.54)
//                // character spacing = 2
//                // uppercase
//            }
//        ]
//    }
//}
//
//public class SongCardTheme: CardTheme {
//    public override func styles() -> [String : Style] {
//        super.styles()
//        return [
//            "track-label": Style() { (inout style: StyleRule) -> () in
//                style.font = UIFont(name: "OpenSans", size: 12)
//                style.color = LightBlackColor.colorWithAlphaComponent(0.9)
//                // character spacing = 1
//            },
//            
//            "artist-label": Style() { (inout style: StyleRule) -> () in
//                style.font = UIFont(name: "OpenSans", size: 10.5)
//                style.color = LightBlackColor.colorWithAlphaComponent(0.54)
//                // character spacing = 1
//            }
//            
//            // track image: 100 x 100, border-radius = 2
//        ]
//    }
//}