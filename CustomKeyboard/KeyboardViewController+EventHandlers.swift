//
//  KeyboardViewController+EventHandlers.swift
//  Surf
//
//  Created by Kervins Valcourt on 7/28/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit
import AudioToolbox

extension KeyboardViewController {
    func updateKeyCaps(uppercase: Bool) {
        let characterUppercase = (NSUserDefaults.standardUserDefaults().boolForKey(ShiftStateUserDefaultsKey) ? uppercase : true)
        layoutEngine?.updateKeyCaps(false, uppercase: uppercase, characterUppercase: characterUppercase, shiftState: shiftState)
    }
    
    func didTapButton(button: KeyboardKeyButton?) {
        if let button = button, key = button.key {
            switch(key) {
            case .letter(let character):
                var str = String(character.rawValue)
                if lettercase! == .Lowercase {
                    str = str.lowercaseString
                }
                textProcessor.insertText(str)
            case .digit(let number):
                textProcessor.insertText(String(number.rawValue))
            case .special(let character, let pageId):
                textProcessor.insertText(String(character.rawValue))
            case .changePage(let pageIndex, let pageId):
                break
            case .modifier(.CapsLock, let pageId):
                lettercase = (lettercase == .Lowercase) ? .Uppercase : .Lowercase
                if lettercase == .Lowercase {
                    
                } else {
                   
                }
            case .modifier(.CallService, let pageId):
                textProcessor.insertText("#")
            case .modifier(.Space, let pageId):
                textProcessor.insertText(" ")
            case .modifier(.Enter, let pageId):
                textProcessor.insertText("\n")
            default:
                break
            }
        }
        
        playKeySound()
    }
    
    func didTouchDownOnKey(button: KeyboardKeyButton?) {
    }
    
    func advanceTapped(button: KeyboardKeyButton?) {
        NSNotificationCenter.defaultCenter().postNotificationName("switchKeyboard", object: nil)
    }
    
    func pageChangeTapped(button: KeyboardKeyButton?) {
        if let button = button, key = button.key {
                switch(key) {
                case .changePage(let pageNumber, let pageId):
                    setPage(pageNumber)
                default:
                    setPage(0)
                }
        }
    }
    
    func highlightKey(button: KeyboardKeyButton?) {
        if let button = button {
            button.highlighted = true
        }
    }
    
    func unHighlightKey(button: KeyboardKeyButton?) {
        if let button = button {
            button.highlighted = false
        }
    }
    
    func playKeySound() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            AudioServicesPlaySystemSound(1104)
        })
    }
    
    func didTapSpaceButton(button: KeyboardKeyButton?) {
        if let button = button {
            switch(button.key) {
            default:
                if currentPage != 0 {
                    setPage(0)
                }
                button.spaceBarSelected = true
            }
            
        }
    }
  
    func didReleaseSpaceButton(button: KeyboardKeyButton?) {
        if let button = button {
            button.spaceBarSelected = false
        }
    }
    
    func didTapCallKey(button: KeyboardKeyButton?) {
        if let button = button {
            button.callKeySelected = true
        }
    }
    
    func didReleaseCallKey(button: KeyboardKeyButton?) {
        if let button = button {
            button.callKeySelected = false
        }
    }

    func didTapEnterKey(button: KeyboardKeyButton?) {
        if let button = button {
            button.enterKeySelected = true
        }
    }
    
    func didReleaseEnterKey(button: KeyboardKeyButton?) {
        if let button = button {
            button.enterKeySelected = false
        }
    }

    func showPopup(button: KeyboardKeyButton?) {
        if let button = button {
            if button == keyWithDelayedPopup {
                popupDelayTimer?.invalidate()
            }
            
            button.showPopup()
        }
    }
    
    func hidePopupDelay(button: KeyboardKeyButton?) {
        if let button = button {
            popupDelayTimer?.invalidate()
            
            if button != keyWithDelayedPopup {
                keyWithDelayedPopup?.hidePopup()
                keyWithDelayedPopup = button
            }
            
            if button.popup != nil {
                popupDelayTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("hidePopupCallback"), userInfo: nil, repeats: false)
            }
        }
    }
    
    func hidePopupCallback() {
        keyWithDelayedPopup?.hidePopup()
        keyWithDelayedPopup = nil
        popupDelayTimer = nil
    }
    
    func cancelBackspaceTimers() {
        backspaceDelayTimer?.invalidate()
        backspaceRepeatTimer?.invalidate()
        backspaceDelayTimer = nil
        backspaceRepeatTimer = nil
        backspaceStartTime = nil
    }
    
    func backspaceDown(button: KeyboardKeyButton?) {
        self.cancelBackspaceTimers()
        
        backspaceStartTime = CFAbsoluteTimeGetCurrent()
        
        textProcessor.currentProxy.deleteBackward()
        
        // trigger for subsequent deletes
        self.backspaceDelayTimer = NSTimer.scheduledTimerWithTimeInterval(backspaceDelay - backspaceRepeat, target: self, selector: Selector("backspaceDelayCallback"), userInfo: nil, repeats: false)
    }
    
    func backspaceUp(button: KeyboardKeyButton?) {
        cancelBackspaceTimers()
        firstWordQuickDeleted = false
    }
    
    func backspaceDelayCallback() {
        backspaceDelayTimer = nil
        backspaceRepeatTimer = NSTimer.scheduledTimerWithTimeInterval(backspaceRepeat, target: self, selector: Selector("backspaceRepeatCallback"), userInfo: nil, repeats: true)
    }
    
    func backspaceRepeatCallback() {
        self.playKeySound()
        
        var timeElapsed = CFAbsoluteTimeGetCurrent() - backspaceStartTime
        
        if timeElapsed < 2.0 {
            textProcessor.currentProxy.deleteBackward()
        } else {
            backspaceLongPressed()
        }
    }

    /**
    Deleting whole word method. Looks at the number of characters from cursor back to first whitespace
    before it not including one that is next to it. Needs to be in loop.
    
    :param: recognizer Long Press recognizer to handle for a long backspace press
    
    */
    func backspaceLongPressed() {
        if firstWordQuickDeleted == true {
            NSThread.sleepForTimeInterval(0.4)
        }
        
        firstWordQuickDeleted = true
        
        if let documentContextBeforeInput = textProcessor.currentProxy.documentContextBeforeInput as NSString? {
            if documentContextBeforeInput.length > 0 {
                var charactersToDelete = 0
                switch documentContextBeforeInput {
                    // If cursor is next to a letter
                case let stringLeft where NSCharacterSet.letterCharacterSet().characterIsMember(stringLeft.characterAtIndex(stringLeft.length - 1)):
                    let range = documentContextBeforeInput.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet().invertedSet, options: .BackwardsSearch)
                    if range.location != NSNotFound {
                        charactersToDelete = documentContextBeforeInput.length - range.location
                    } else {
                        charactersToDelete = documentContextBeforeInput.length
                    }
                    // If cursor is next to a whitespace
                case let stringLeft where stringLeft.hasSuffix(" "):
                    let range = documentContextBeforeInput.rangeOfCharacterFromSet(NSCharacterSet.whitespaceCharacterSet().invertedSet, options: .BackwardsSearch)
                    if range.location != NSNotFound {
                        charactersToDelete = documentContextBeforeInput.length - range.location - 1
                    } else {
                        charactersToDelete = documentContextBeforeInput.length
                    }
                    // if there is only one character left
                default:
                    charactersToDelete = 1
                }
                
                for i in 0..<charactersToDelete {
                    textProcessor.currentProxy.deleteBackward()
                }
            }
        }
    }

    func shiftDown(button: KeyboardKeyButton?) {
        shiftStartingState = shiftState
        if let button = button {
            if let shiftStartingState = shiftStartingState {
                if shiftStartingState.uppercase() {
                    // handled by shiftUp
                    return
                }
                else {
                    switch shiftState {
                    case .Disabled:
                        shiftState = .Enabled
                        button.shiftSelected = true
                    case .Enabled:
                        shiftState = .Disabled
                        button.shiftSelected = false
                    case .Locked:
                        shiftState = .Disabled
                        button.shiftSelected = false
                    }
                }
            }
        }
        
    }
    
    func shiftUp(button: KeyboardKeyButton?) {
        if let button = button {
            if shiftWasMultitapped {
                // do nothing
            }
            else {
                if let shiftStartingState = shiftStartingState {
                    if !shiftStartingState.uppercase() {
                        // handled by shiftDown
                        changeKeyboardLetterCases(true)
                    }
                    else {
                        changeKeyboardLetterCases(false)
                        button.shiftSelected = false
                        switch shiftState {
                        case .Disabled:
                            shiftState = .Enabled
                        case .Enabled:
                            shiftState = .Disabled
                        case .Locked:
                            shiftState = .Disabled
                        }
                    }
                }
                
            }
        }
        shiftStartingState = nil
        shiftWasMultitapped = false
    }
    
    func changeKeyboardLetterCases(isCapLoackOn:Bool) {
        for button in allKeys {
            if let key = button.key {
                switch(key) {
                case .letter (let character):
                    var str = String(character.rawValue)
                    if isCapLoackOn {
                        button.text = str
                    } else {
                        button.text = str.lowercaseString
                    }
                    break
                default:
                    break
                }
            }
        }
    }
    
    func shiftDoubleTapped(button: KeyboardKeyButton?) {
        shiftWasMultitapped = true
        
        switch shiftState {
        case .Disabled:
            shiftState = .Locked
        case .Enabled:
            shiftState = .Locked
        case .Locked:
            shiftState = .Disabled
        }
    }
}

