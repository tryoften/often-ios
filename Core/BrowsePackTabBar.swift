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
//    case Reactions
    case Gifs
    case Quotes
    case Images
    case Packs
    case Delete
}

class BrowsePackTabBar: SlideTabBar {
    var globeTabBarItem: UITabBarItem
    var gifsTabBarItem: UITabBarItem
    var quotesTabBarItem: UITabBarItem
    var imagesTabBarItem: UITabBarItem
//    var reactionsTabBarItem: UITabBarItem
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
        
        imagesTabBarItem = UITabBarItem()
        imagesTabBarItem.tag = BrowsePackTabType.Images.rawValue
        imagesTabBarItem.image = StyleKit.imageOfCameraIcon(scale: 0.3, color: UIColor.oftBlack74Color()).imageWithRenderingMode(.AlwaysOriginal)
        imagesTabBarItem.imageInsets = UIEdgeInsetsMake(13, 7, -13, -7)
        
//        reactionsTabBarItem = UITabBarItem()
//        reactionsTabBarItem.tag = BrowsePackTabType.Reactions.rawValue
//        reactionsTabBarItem.image = StyleKit.imageOfHashtagicon(color: UIColor.oftBlack74Color()).imageWithRenderingMode(.AlwaysOriginal)
//        reactionsTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        packsTabBarItem = UITabBarItem()
        packsTabBarItem.tag = BrowsePackTabType.Packs.rawValue
        packsTabBarItem.image = StyleKit.imageOfCollectionsCards(color: UIColor.oftBlack74Color(), scale: 0.4).imageWithRenderingMode(.AlwaysOriginal)
        packsTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        deleteTabBarItem = UITabBarItem()
        deleteTabBarItem.tag = BrowsePackTabType.Delete.rawValue
        deleteTabBarItem.image = StyleKit.imageOfBackspaceIcon(scale: 0.4, color: UIColor.oftBlack74Color()).imageWithRenderingMode(.AlwaysOriginal)
        deleteTabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        super.init(highlightBarEnabled: enabled)
        
        items = [globeTabBarItem, gifsTabBarItem, quotesTabBarItem, imagesTabBarItem, packsTabBarItem, deleteTabBarItem]
        
        backgroundColor = WhiteColor
        translucent = false
        tintColor = UIColor.oftBlack74Color()
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTabBarSelectedItem() {
        
//        if selectedItem?.tag != 1 {
            switch PacksService.defaultInstance.typeFilter {
            case .Gif:
                selectedItem = PacksService.defaultInstance.doesCurrentPackContainTypeForCategory(.Gif) ? items![BrowsePackTabType.Gifs.rawValue]: items![BrowsePackTabType.Quotes.rawValue]
            case .Quote, .Lyric:
                selectedItem = PacksService.defaultInstance.doesCurrentPackContainTypeForCategory(.Quote) ? items![BrowsePackTabType.Quotes.rawValue] : items![BrowsePackTabType.Gifs.rawValue]
            case .Image:
                selectedItem = PacksService.defaultInstance.doesCurrentPackContainTypeForCategory(.Image) ? items![BrowsePackTabType.Images.rawValue] : items![BrowsePackTabType.Gifs.rawValue]
            default:
                break
            }
//        }


        if !PacksService.defaultInstance.doesCurrentPackContainTypeForCategory(.Gif) {
            gifsTabBarItem.image = StyleKit.imageOfGifMenuButton(color: UIColor.oftBlack74Color().colorWithAlphaComponent(0.3)).imageWithRenderingMode(.AlwaysOriginal)
        } else {
            gifsTabBarItem.image = StyleKit.imageOfGifMenuButton(color: UIColor.oftBlack74Color()).imageWithRenderingMode(.AlwaysOriginal)
        }

        if !PacksService.defaultInstance.doesCurrentPackContainTypeForCategory(.Quote) {
            quotesTabBarItem.image = StyleKit.imageOfQuotesMenuButton(color: UIColor.oftBlack74Color().colorWithAlphaComponent(0.3)).imageWithRenderingMode(.AlwaysOriginal)
        } else {
            quotesTabBarItem.image = StyleKit.imageOfQuotesMenuButton(color: UIColor.oftBlack74Color()).imageWithRenderingMode(.AlwaysOriginal)
        }
        
        if !PacksService.defaultInstance.doesCurrentPackContainTypeForCategory(.Image) {
            imagesTabBarItem.image = StyleKit.imageOfCameraIcon(scale: 0.3, color: UIColor.oftBlack74Color().colorWithAlphaComponent(0.3)).imageWithRenderingMode(.AlwaysOriginal)
        } else {
            imagesTabBarItem.image = StyleKit.imageOfCameraIcon(scale: 0.3, color: UIColor.oftBlack74Color()).imageWithRenderingMode(.AlwaysOriginal)
        }

        lastSelectedTab = selectedItem
    }

}