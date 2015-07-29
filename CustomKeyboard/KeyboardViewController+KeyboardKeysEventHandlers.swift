//
//  KeyboardViewController+KeyboardKeysEventHandlers.swift
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
            
            button.highlighted = false
            button.selected = !button.selected
            
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
        if let key = button!.key {
                switch(key) {
                case .changePage(let pageNumber, let pageId):
                    setPage(pageNumber)
                default:
                    setPage(0)
                }
        }
    }
    
    func highlightKey(button: KeyboardKeyButton?) {
        button!.highlighted = true
    }
    
    func unHighlightKey(button: KeyboardKeyButton?) {
        button!.highlighted = false
    }
    
    func playKeySound() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            AudioServicesPlaySystemSound(1104)
        })
    }
    
    func showPopup(button: KeyboardKeyButton?) {
        
        if button == keyWithDelayedPopup {
            popupDelayTimer?.invalidate()
        }
        button!.showPopup()
    }
    
    func hidePopupDelay(button: KeyboardKeyButton?) {
        popupDelayTimer?.invalidate()
        
        if button != keyWithDelayedPopup {
            keyWithDelayedPopup?.hidePopup()
            keyWithDelayedPopup = button
        }
        
        if button!.popup != nil {
            popupDelayTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("hidePopupCallback"), userInfo: nil, repeats: false)
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
    }
    
    func backspaceDown(button: KeyboardKeyButton?) {
        cancelBackspaceTimers()
        
        if let textDocumentProxy = textDocumentProxy as? UIKeyInput {
            textProcessor.deleteBackward()
        }
        
        // trigger for subsequent deletes
        backspaceDelayTimer = NSTimer.scheduledTimerWithTimeInterval(backspaceDelay - backspaceRepeat, target: self, selector: Selector("backspaceDelayCallback"), userInfo: nil, repeats: false)
    }
    
    func backspaceUp(button: KeyboardKeyButton?) {
        cancelBackspaceTimers()
    }
    
    func backspaceDelayCallback() {
        backspaceDelayTimer = nil
        backspaceRepeatTimer = NSTimer.scheduledTimerWithTimeInterval(backspaceRepeat, target: self, selector: Selector("backspaceRepeatCallback"), userInfo: nil, repeats: true)
    }
    
    func backspaceRepeatCallback() {
        playKeySound()
        
        if let textDocumentProxy = textDocumentProxy as? UIKeyInput {
            textProcessor.deleteBackward()
        }
    }
    
    func shiftDown(button: KeyboardKeyButton?) {
        shiftStartingState = shiftState
        
        if let shiftStartingState = shiftStartingState {
            if shiftStartingState.uppercase() {
                // handled by shiftUp
                return
            }
            else {
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
    
    func shiftUp(button: KeyboardKeyButton?) {
        if shiftWasMultitapped {
            // do nothing
        }
        else {
            if let shiftStartingState = shiftStartingState {
                if !shiftStartingState.uppercase() {
                    // handled by shiftDown
                }
                else {
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
        shiftStartingState = nil
        shiftWasMultitapped = false
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

