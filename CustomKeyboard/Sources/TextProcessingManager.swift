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
    var context: String?

    init(textDocumentProxy: UITextDocumentProxy) {
        proxy = textDocumentProxy
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textWillChange(textInput: UITextInput) {
    }
    
    func textDidChange(textInput: UITextInput) {
        if let text = proxy.documentContextBeforeInput {
            let tokens = text.componentsSeparatedByString(" ")
            
            if tokens.count > 1 {
                let firstToken = tokens[0]
                
                // check if first token is command call
                if firstToken.hasPrefix("#") {
                    let commandString = firstToken.substringFromIndex(firstToken.startIndex.successor())
                    
                    if let serviceProviderType = ServiceProviderType(rawValue: commandString) {
                        println(serviceProviderType)
                        for i in 0..<count(firstToken) {
                            proxy.deleteBackward()
                        }
                        delegate?.textProcessingManagerDidDetectServiceProvider(self, serviceProviderType: serviceProviderType)
                    }
                }
            }
        }
        
        delegate?.textProcessingManagerDidChangeText(self)
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
    
    func insertText(text: String) {
        if var context = context {
            context = context + text
        } else {
            context = text
        }
        proxy.insertText(text)
        
    }
    
    func deleteBackward() {
        proxy.deleteBackward()
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
    func didPickLyric(lyricPicker: ContentTableViewController, shareVC: ShareViewController?, lyric: Lyric?) {
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
    func textProcessingManagerDidDetectServiceProvider(textProcessingManager: TextProcessingManager, serviceProviderType: ServiceProviderType)
}
