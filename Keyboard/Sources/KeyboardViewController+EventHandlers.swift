//
//  KeyboardViewController+EventHandlers.swift
//  Surf
//
//  Created by Kervins Valcourt on 7/28/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit
import AudioToolbox

let KeyboardEnterKeyTappedEvent = "keyboard.enterKey"

extension KeyboardViewController {
    func updateKeyCaps(lettercase: Lettercase) {
        let uppercase: Bool = lettercase == .Uppercase
        let characterUppercase = (NSUserDefaults.standardUserDefaults().boolForKey(ShiftStateUserDefaultsKey) ? uppercase : true)
        layoutEngine?.updateKeyCaps(false, uppercase: uppercase, characterUppercase: characterUppercase, shiftState: shiftState)
    }
    
    func didTapButton(button: KeyboardKeyButton?) {
        if let button = button, key = button.key {
            switch(key) {
            case .letter(let character):
                var str = String(character.rawValue)
                if shiftState.lettercase() == .Lowercase {
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
                break
            case .modifier(.CallService, let pageId):
                textProcessor.insertText("#")
            case .modifier(.Space, let pageId):
                textProcessor.insertText(" ")
                handleAutoPeriod(button)
            case .modifier(.Enter, let pageId):
                textProcessor.insertText("\n")
            default:
                break
            }
        }
        playKeySound()
        setCapsIfNeeded()
    }
    
    func didTouchDownOnKey(button: KeyboardKeyButton?) {
    }
    
    func advanceTapped(button: KeyboardKeyButton?) {
        NSNotificationCenter.defaultCenter().postNotificationName(SwitchKeyboardEvent, object: nil)
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
            button.selected = true
        }
    }
    
    func didReleaseSpaceButton(button: KeyboardKeyButton?) {
        if let button = button {
            button.selected = false
        }
        
        delay(0.0) {
            if self.currentPage != 0 {
                self.setPage(0)
            }
        }
    }
    
    func didTapCallKey(button: KeyboardKeyButton?) {
        if let button = button {
            button.selected = true
        }
    }
    
    func didReleaseCallKey(button: KeyboardKeyButton?) {
        if let button = button {
            button.selected = false
        }
    }

    func didTapEnterKey(button: KeyboardKeyButton?) {
        if let button = button {
            button.selected = true
        }
        
        keyboardconnectivityWormhole.passMessageObject("search", identifier: "firstSearch")
    }
    
    func didReleaseEnterKey(button: KeyboardKeyButton?) {
        if let button = button {
            button.selected = false
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(KeyboardEnterKeyTappedEvent, object: nil, userInfo: nil)
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
        if let button = button {
            button.selected = true
        }

        cancelBackspaceTimers()
        backspaceStartTime = CFAbsoluteTimeGetCurrent()
        textProcessor.deleteBackward()
        
        // trigger for subsequent deletes
        backspaceDelayTimer = NSTimer.scheduledTimerWithTimeInterval(backspaceDelay - backspaceRepeat, target: self, selector: Selector("backspaceDelayCallback"), userInfo: nil, repeats: false)
    }
    
    func backspaceUp(button: KeyboardKeyButton?) {
        if let button = button {
            button.selected = false
        }
        
        cancelBackspaceTimers()
        firstWordQuickDeleted = false
        setCapsIfNeeded()
    }
    
    func backspaceDelayCallback() {
        backspaceDelayTimer = nil
        backspaceRepeatTimer = NSTimer.scheduledTimerWithTimeInterval(backspaceRepeat, target: self, selector: Selector("backspaceRepeatCallback"), userInfo: nil, repeats: true)
    }
    
    func backspaceRepeatCallback() {
        playKeySound()
        
        let timeElapsed = CFAbsoluteTimeGetCurrent() - backspaceStartTime
        if timeElapsed < 2.0 {
            textProcessor.currentProxy.deleteBackward()
        } else {
            backspaceLongPressed()
        }
    }
    
    func callServiceLongPressed(gestureRecognizer: UIGestureRecognizer) {
        collapseKeyboard()
    }

    /**
    Deleting whole word method. Looks at the number of characters from cursor back to first whitespace
    before it not including one that is next to it. Needs to be in loop.
    
    - parameter recognizer: Long Press recognizer to handle for a long backspace press
    
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
                        button.selected = true
                    case .Enabled:
                        shiftState = .Disabled
                    case .Locked:
                        shiftState = .Disabled
                    }
                }
            }
        }
        
    }
    
    func shiftUp(button: KeyboardKeyButton?) {
        if let button = button {
            if !shiftWasMultitapped {
                if let shiftStartingState = shiftStartingState {
                    if shiftStartingState.uppercase() {
                        button.selected = false
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

    func shiftDoubleTapped(button: KeyboardKeyButton?) {
        if let button = button {
            shiftWasMultitapped = true

            switch shiftState {
            case .Disabled:
                shiftState = .Locked
                button.selected = false
            case .Enabled:
                shiftState = .Locked
                button.selected = true
            case .Locked:
                shiftState = .Disabled
                button.selected = false
            }
        }
    }
    
    func handleAutoPeriod(button: KeyboardKeyButton?){
        if let button = button, key = button.key {
            switch(key) {
            case .modifier(.Space, let pageId):
                if self.autoPeriodState == .FirstSpace {
                    if self.textProcessor.charactersAreInCorrectState() {
                        textProcessor.deleteBackward()
                        textProcessor.deleteBackward()
                        textProcessor.insertText(". ")
                        
                        self.autoPeriodState = .NoSpace
                    }
                } else {
                    self.autoPeriodState = .FirstSpace
                }
            default:
                break
            }
        }
        
    }
}

