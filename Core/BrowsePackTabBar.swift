//
//  BrowsePackTabView.swift
//  Often
//
//  Created by Katelyn Findlay on 5/2/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation

enum BrowsePackTabType: Int {
    case keyboard = 0
    case gifs
    case quotes
    case categories
    case packs
    case delete
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
        globeTabBarItem.tag = BrowsePackTabType.keyboard.rawValue
        globeTabBarItem.image = StyleKit.imageOfGlobe(scale: 0.6, color: UIColor.oftBlack74Color()).withRenderingMode(.alwaysOriginal)
        globeTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)

        gifsTabBarItem = UITabBarItem()
        gifsTabBarItem.tag = BrowsePackTabType.gifs.rawValue
        gifsTabBarItem.image = StyleKit.imageOfGifMenuButton(color: UIColor.oftBlack74Color()).withRenderingMode(.alwaysOriginal)
        gifsTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        quotesTabBarItem = UITabBarItem()
        quotesTabBarItem.tag = BrowsePackTabType.quotes.rawValue
        quotesTabBarItem.image = StyleKit.imageOfQuotesMenuButton(color: UIColor.oftBlack74Color()).withRenderingMode(.alwaysOriginal)
        quotesTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        categoriesTabBarItem = UITabBarItem()
        categoriesTabBarItem.tag = BrowsePackTabType.categories.rawValue
        categoriesTabBarItem.image = StyleKit.imageOfHashtagicon(color: UIColor.oftBlack74Color()).withRenderingMode(.alwaysOriginal)
        categoriesTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        packsTabBarItem = UITabBarItem()
        packsTabBarItem.tag = BrowsePackTabType.packs.rawValue
        packsTabBarItem.image = StyleKit.imageOfPacksMenuButton(color: UIColor.oftBlack74Color()).withRenderingMode(.alwaysOriginal)
        packsTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        deleteTabBarItem = UITabBarItem()
        deleteTabBarItem.tag = BrowsePackTabType.delete.rawValue
        deleteTabBarItem.image = StyleKit.imageOfBackspaceIcon(scale: 0.4, color: UIColor.oftBlack74Color()).withRenderingMode(.alwaysOriginal)
        deleteTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        super.init(highlightBarEnabled: enabled)
        
        items = [globeTabBarItem, gifsTabBarItem, quotesTabBarItem, categoriesTabBarItem, packsTabBarItem, deleteTabBarItem]
        
        backgroundColor = WhiteColor
        isTranslucent = false
        tintColor = UIColor.oftBlack74Color()
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTabBarSelectedItem() {
        switch PacksService.defaultInstance.typeFilter {
        case .Gif:
            selectedItem = PacksService.defaultInstance.doesCurrentPackContainTypeForCategory(.Gif) ? items![BrowsePackTabType.gifs.rawValue]: items![BrowsePackTabType.quotes.rawValue]
        case .Quote, .Lyric:
            selectedItem = PacksService.defaultInstance.doesCurrentPackContainTypeForCategory(.Quote) ? items![BrowsePackTabType.quotes.rawValue] : items![BrowsePackTabType.gifs.rawValue]
        default:
            break
        }

        if !PacksService.defaultInstance.doesCurrentPackContainTypeForCategory(.Gif) {
            gifsTabBarItem.image = StyleKit.imageOfGifMenuButton(color: UIColor.oftBlack74Color().withAlphaComponent(0.3)).withRenderingMode(.alwaysOriginal)

        } else {
            gifsTabBarItem.image = StyleKit.imageOfGifMenuButton(color: UIColor.oftBlack74Color()).withRenderingMode(.alwaysOriginal)
        }

        if !PacksService.defaultInstance.doesCurrentPackContainTypeForCategory(.Quote) {
            quotesTabBarItem.image = StyleKit.imageOfQuotesMenuButton(color: UIColor.oftBlack74Color().withAlphaComponent(0.3)).withRenderingMode(.alwaysOriginal)
        } else {
            quotesTabBarItem.image = StyleKit.imageOfQuotesMenuButton(color: UIColor.oftBlack74Color()).withRenderingMode(.alwaysOriginal)
        }

        lastSelectedTab = selectedItem
    }

}
