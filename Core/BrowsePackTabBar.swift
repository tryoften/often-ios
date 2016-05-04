//
//  BrowsePackTabView.swift
//  Often
//
//  Created by Katelyn Findlay on 5/2/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

enum BrowsePackTabType: Int {
    case Keyboard = 0
    case Gifs
    case Quotes
    case Categories
    case Packs
    case Delete
}

class BrowsePackTabBar: SlideTabBar {
    var globeTabBarItem: UITabBarItem
    var gifsTabBarItem: UITabBarItem
    var quotesTabBarItem: UITabBarItem
    var categoriesTabBarItem: UITabBarItem
    var packsTabBarItem: UITabBarItem
    var deleteTabBarItem: UITabBarItem
    var lastSelectedTab: UITabBarItem?
    
    override init(highlightBarEnabled enabled: Bool) {
        
        globeTabBarItem = UITabBarItem()
        globeTabBarItem.tag = BrowsePackTabType.Keyboard.rawValue
        globeTabBarItem.image = StyleKit.imageOfGlobe(scale: 0.6, color: UIColor.oftBlack74Color()).imageWithRenderingMode(.AlwaysOriginal)
        globeTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)

        gifsTabBarItem = UITabBarItem()
        gifsTabBarItem.tag = BrowsePackTabType.Gifs.rawValue
        gifsTabBarItem.image = StyleKit.imageOfGifMenuButton(color: UIColor.oftBlack74Color()).imageWithRenderingMode(.AlwaysOriginal)
        gifsTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        quotesTabBarItem = UITabBarItem()
        quotesTabBarItem.tag = BrowsePackTabType.Quotes.rawValue
        quotesTabBarItem.image = StyleKit.imageOfQuotesMenuButton(color: UIColor.oftBlack74Color()).imageWithRenderingMode(.AlwaysOriginal)
        quotesTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        categoriesTabBarItem = UITabBarItem()
        categoriesTabBarItem.tag = BrowsePackTabType.Categories.rawValue
        categoriesTabBarItem.image = StyleKit.imageOfHashtagicon(color: UIColor.oftBlack74Color()).imageWithRenderingMode(.AlwaysOriginal)
        categoriesTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        packsTabBarItem = UITabBarItem()
        packsTabBarItem.tag = BrowsePackTabType.Packs.rawValue
        packsTabBarItem.image = StyleKit.imageOfPacksMenuButton(color: UIColor.oftBlack74Color()).imageWithRenderingMode(.AlwaysOriginal)
        packsTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        deleteTabBarItem = UITabBarItem()
        deleteTabBarItem.tag = BrowsePackTabType.Delete.rawValue
        deleteTabBarItem.image = StyleKit.imageOfBackspaceIcon(scale: 0.4, color: UIColor.oftBlack74Color()).imageWithRenderingMode(.AlwaysOriginal)
        deleteTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        super.init(highlightBarEnabled: enabled)
        
        items = [globeTabBarItem, gifsTabBarItem, quotesTabBarItem, categoriesTabBarItem, packsTabBarItem, deleteTabBarItem]
        
        backgroundColor = WhiteColor
        translucent = false
        tintColor = UIColor.oftBlack74Color()
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}