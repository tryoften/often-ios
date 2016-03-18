//
//  EmojiKeyboardViewController.swift
//  Often
//
//  Created by Katelyn Findlay on 3/1/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class EmojiKeyboardViewController: UIViewController, AGEmojiKeyboardViewDelegate, AGEmojiKeyboardViewDataSource {
    
//    var containerView: UIView
    var emojiKeyboardView: AGEmojiKeyboardView?
    var textProcessor: TextProcessingManager
    
    init(textProcessor aTextProcessor: TextProcessingManager) {
        textProcessor = aTextProcessor
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = DefaultTheme.keyboardBackgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emojiKeyboardView = AGEmojiKeyboardView(frame: view.bounds, dataSource: self)
        emojiKeyboardView?.autoresizingMask = .FlexibleHeight
        view.addSubview(emojiKeyboardView!)
        emojiKeyboardView?.delegate = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emojiKeyboardView?.frame = view.bounds
    }
    

    // Emoji Methods
    func emojiKeyBoardView(emojiKeyBoardView: AGEmojiKeyboardView!, didUseEmoji emoji: String!) {
        textProcessor.insertText(emoji)
    }
    
    func emojiKeyBoardViewDidPressBackSpace(emojiKeyBoardView: AGEmojiKeyboardView!) {
        NSNotificationCenter.defaultCenter().postNotificationName(BackToKeyboardButtonPressedEvent, object: nil)
    }
    
    func emojiKeyboardView(emojiKeyboardView: AGEmojiKeyboardView!, imageForCategory category: AGEmojiKeyboardViewCategoryImage) -> UIImage! {
        
        
        switch category {
        case .Keyboard:
            return StyleKit.imageOfAbcIcon(emojiScale: 0.5)
        case .Recent:
            return StyleKit.imageOfRecentIcon(emojiScale: 0.5)
        case .People:
            return StyleKit.imageOfPeopleIcon(emojiScale: 0.5)
        case .Nature:
            return StyleKit.imageOfNatureIcon(emojiScale: 0.5)
        case .Food:
            return StyleKit.imageOfFoodIcon(emojiScale: 0.5)
        case .Activity:
            return StyleKit.imageOfActivityIcon(emojiScale: 0.5)
        case .Travel:
            return StyleKit.imageOfBuildingsIcon(emojiScale: 0.5)
        case .Objects:
            return StyleKit.imageOfConfettiIcon(emojiScale: 0.5)
        case .Symbols:
            return StyleKit.imageOfRandomIcon(emojiScale: 0.5)
        case .Flags:
            return StyleKit.imageOfFlagIcon(emojiScale: 0.5)
        case .Delete:
            return StyleKit.imageOfBackspaceIcon(emojiScale: 0.4)
        }
        
    }
    
    func selectedBackgroundImageForEmojiKeyboardView(emojiKeyboardView: AGEmojiKeyboardView!) -> UIImage! {
        return StyleKit.imageOfEmojiSelectedIcon(emojiScale: 0.55)
    }
    
    func emojiKeyBoardViewDidPressDeleteButton(emojiKeyBoardView: AGEmojiKeyboardView!) {
        textProcessor.deleteBackward()
    }
}
