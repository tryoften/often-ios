//
//  AnimatedMenuView.swift
//  Often
//
//  Created by Katelyn Findlay on 4/25/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//
//
import Foundation
import Material

class AnimatedMenuView: MenuView {

    var packsMenuItem: AnimatedMenuButton
    var categoryMenuItem: AnimatedMenuButton
    var quotesMenuItem: AnimatedMenuButton
    var gifsMenuItem: AnimatedMenuButton
    var startMenuItem: FabButton

    override init(frame: CGRect) {
        startMenuItem = FabButton()
        startMenuItem.imageView?.contentMode = .ScaleAspectFill
        startMenuItem.imageView?.layer.cornerRadius = 25
        startMenuItem.imageView?.clipsToBounds = true
        startMenuItem.backgroundColor = WhiteColor
        startMenuItem.borderWidth = 4
        startMenuItem.borderColor = WhiteColor
        
        gifsMenuItem = AnimatedMenuButton()
        gifsMenuItem.buttonImage = StyleKit.imageOfGifMenuButton(selected: false)
        gifsMenuItem.buttonLabelText = "Gifs"
        gifsMenuItem.button.tag = AnimatedMenuItem.Gifs.rawValue
        
        quotesMenuItem = AnimatedMenuButton()
        quotesMenuItem.buttonImage = StyleKit.imageOfQuotesMenuButton(selected: false)
        quotesMenuItem.buttonLabelText = "Quotes"
        quotesMenuItem.button.tag = AnimatedMenuItem.Quotes.rawValue
        
        categoryMenuItem = AnimatedMenuButton()
        categoryMenuItem.buttonImage = StyleKit.imageOfCategoriesMenuButton(selected: false)
        categoryMenuItem.buttonLabelText = "Categories"
        categoryMenuItem.button.tag = AnimatedMenuItem.Categories.rawValue
        
        packsMenuItem = AnimatedMenuButton()
        packsMenuItem.buttonImage = StyleKit.imageOfPacksMenuButton(selected: false)
        packsMenuItem.buttonLabelText = "Packs"
        packsMenuItem.button.tag = AnimatedMenuItem.Packs.rawValue

        super.init(frame: frame)
        
        quotesMenuItem.button.addTarget(self, action: #selector(buttonPressed(_:)), forControlEvents: .TouchUpInside)
        gifsMenuItem.button.addTarget(self, action: #selector(buttonPressed(_:)), forControlEvents: .TouchUpInside)
        
        addSubview(startMenuItem)
        addSubview(gifsMenuItem)
        addSubview(quotesMenuItem)
        addSubview(categoryMenuItem)
        addSubview(packsMenuItem)
        
        menu.direction = .Up
//        menu.enabled = false

        menu.baseViewSize = CGSizeMake(50, 50)
        menu.itemViewSize = CGSizeMake(41, 40)
        menu.spacing = 10.0
        
        #if KEYBOARD
            menu.baseViewSize = CGSizeMake(45, 45)
            menu.itemViewSize = CGSizeMake(36, 40)
            menu.spacing = 5.0
        #endif
        
        
        menu.views = [startMenuItem, gifsMenuItem, quotesMenuItem, categoryMenuItem, packsMenuItem]
        translatesAutoresizingMaskIntoConstraints = false
        zPosition = 1000
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonPressed(sender: AnimatedMenuButton) {
        
        guard let type = AnimatedMenuItem(rawValue: sender.tag) else {
            return
        }
        
        if type == .Gifs {
            quotesMenuItem.selected = false
            gifsMenuItem.selected = true
        } else {
            gifsMenuItem.selected = false
            quotesMenuItem.selected = true
        }
    }

}