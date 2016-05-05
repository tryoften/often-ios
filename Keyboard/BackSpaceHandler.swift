//
//  BackSpaceHandler.swift
//  Often
//
//  Created by Kervins Valcourt on 5/5/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import Foundation
import AudioToolbox

class BackSpaceHandler: NSObject {
    var backspaceDelayTimer: NSTimer?
    var backspaceRepeatTimer: NSTimer?
    let backspaceDelay: NSTimeInterval = 0.5
    let backspaceRepeat: NSTimeInterval = 0.07
    var backspaceStartTime: CFAbsoluteTime!
    var firstWordQuickDeleted: Bool = false
    private var textProcessor: TextProcessingManager?

    init(textProcessor: TextProcessingManager?) {
        self.textProcessor = textProcessor
    }

    func cancelBackspaceTimers() {
        backspaceDelayTimer?.invalidate()
        backspaceRepeatTimer?.invalidate()
        backspaceDelayTimer = nil
        backspaceRepeatTimer = nil
        backspaceStartTime = nil
    }

    func backspaceDown() {
        cancelBackspaceTimers()
        backspaceStartTime = CFAbsoluteTimeGetCurrent()
        textProcessor?.deleteBackward()

        // trigger for subsequent deletes
        backspaceDelayTimer = NSTimer.scheduledTimerWithTimeInterval(backspaceDelay - backspaceRepeat, target: self, selector: #selector(BackSpaceHandler.backspaceDelayCallback), userInfo: nil, repeats: false)
    }

    func backspaceUp() {
        
        cancelBackspaceTimers()
        firstWordQuickDeleted = false
    }

    func backspaceDelayCallback() {
        backspaceDelayTimer = nil
        backspaceRepeatTimer = NSTimer.scheduledTimerWithTimeInterval(backspaceRepeat, target: self, selector: #selector(BackSpaceHandler.backspaceRepeatCallback), userInfo: nil, repeats: true)
    }

    func backspaceRepeatCallback() {
        playKeySound()

        let timeElapsed = CFAbsoluteTimeGetCurrent() - backspaceStartTime
        if timeElapsed < 2.0 {
            textProcessor?.deleteBackward()
        } else {
            backspaceLongPressed()
        }
    }

    func playKeySound() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            AudioServicesPlaySystemSound(1104)
        })
    }

    func backspaceLongPressed() {
        if firstWordQuickDeleted == true {
            NSThread.sleepForTimeInterval(0.4)
        }

        firstWordQuickDeleted = true

        if let documentContextBeforeInput = textProcessor?.currentProxy.documentContextBeforeInput as NSString? {
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
                
                for _ in 0..<charactersToDelete {
                    textProcessor?.deleteBackward()
                }
            }
        }
    }
}

