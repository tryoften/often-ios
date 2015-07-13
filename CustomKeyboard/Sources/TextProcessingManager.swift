//
//  TextProcessingManager.swift
//  October
//
//  Created by Luc Succes on 7/12/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import UIKit

class TextProcessingManager: NSObject, UITextInputDelegate, LyricPickerDelegate, ShareViewControllerDelegate {
    weak var delegate: TextProcessingManagerDelegate?
    var proxy: UITextDocumentProxy
    var lastInsertedString: String?
    var currentlyInjectedLyric: Lyric?
    var lyricInserted = false
    
    init(textDocumentProxy: UITextDocumentProxy) {
        proxy = textDocumentProxy
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textWillChange(textInput: UITextInput) {
        if !proxy.hasText() {
            return
        }
        
        var context = proxy.documentContextBeforeInput
        
        println("context: \(context)")
        
        if let injectedLyric = currentlyInjectedLyric {
            // Whether the current context is the currently selected lyric on not
            lyricInserted = injectedLyric == context
        }
    }
    
    func textDidChange(textInput: UITextInput) {
        var analytics = SEGAnalytics.sharedAnalytics()
        // When the lyric is flushed and sent to the proper context
        if !proxy.hasText() {
            if let lyric = currentlyInjectedLyric {
                delegate?.textProcessingManagerDidChangeText(self)
            }
        }
    }
    func selectionWillChange(textInput: UITextInput) {
        
    }

    func selectionDidChange(textInput: UITextInput) {
        
    }
    
    func clearInput() {
        //move cursor to end of text
        if let afterInputText = proxy.documentContextAfterInput {
            proxy.adjustTextPositionByCharacterOffset(count(afterInputText.utf16))
        }
        
        if let beforeInputText = lastInsertedString {
            for var i = 0, len = count(beforeInputText.utf16); i < len; i++ {
                proxy.deleteBackward()
            }
        }
    }
    
    func shareStringForOption(option: ShareOption, url: NSURL) -> String {
        var shareString = ""
        
        switch option {
        case .Spotify:
            shareString = "Spotify: "
            break
        case .Soundcloud:
            shareString = "Soundcloud: "
            break
        case .YouTube:
            shareString = "YouTube: "
            break
        default:
            break
        }
        
        return shareString + url.absoluteString!
    }
    
    
    func insertLyric(lyric: Lyric, selectedOptions: [ShareOption: NSURL]?) {
        var text = ""
        var optionKeys = [String]()
        
        clearInput()
        
        if proxy.hasText() {
            text += ". "
        }
        
        if var options = selectedOptions {
            
            if (options.indexForKey(.Lyric) != nil) {
                text += lyric.text
                options.removeValueForKey(.Lyric)
            }
            
            if (!text.isEmpty && !options.isEmpty) {
                text += "\n"
            }
            
            for (option, url) in options {
                optionKeys.append(option.description)
                if (!text.isEmpty) {
                    text += "\n"
                }
                text += shareStringForOption(option, url: url)
            }
        } else {
            text += lyric.text
        }
        
        proxy.insertText(text)
        lastInsertedString = text
    }

    // MARK: LyricPickerDelegate
    func didPickLyric(lyricPicker: LyricPickerTableViewController, shareVC: ShareViewController?, lyric: Lyric?) {
        if let shareVC = shareVC {
            shareVC.delegate = self
        }
        currentlyInjectedLyric = lyric
        insertLyric(lyric!, selectedOptions: nil)
    }
    
    // MARK: ShareViewControllerDelegate
    func shareViewControllerDidCancel(shareVC: ShareViewController) {
        for var i = 0, len = count(shareVC.lyric!.text.utf16); i < len; i++ {
            proxy.deleteBackward()
        }
    }
    
    func shareViewControllerDidToggleShareOptions(shareViewController: ShareViewController, options: [ShareOption: NSURL]) {
        insertLyric(shareViewController.lyric!, selectedOptions:options)
    }
}

protocol TextProcessingManagerDelegate: class {
    func textProcessingManagerDidChangeText(textProcessingManager: TextProcessingManager)
}
