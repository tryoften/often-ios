//
//  TextProcessingManager.swift
//  October
//
//  Created by Luc Succes on 7/12/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import UIKit

class TextProcessingManager: NSObject, UITextInputDelegate {
    weak var delegate: TextProcessingManagerDelegate?
    var currentProxy: UITextDocumentProxy
    var lastInsertedString: String?
    var lyricInserted = false
    var proxies: [String: UITextDocumentProxy]

    init(textDocumentProxy: UITextDocumentProxy) {
        proxies = [:]
        currentProxy = textDocumentProxy
        proxies["default"] = currentProxy
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textWillChange(textInput: UITextInput) {
    }
    
    func textDidChange(textInput: UITextInput) {
        if let text = currentProxy.documentContextBeforeInput {
            let tokens = text.componentsSeparatedByString(" ")
            
            if tokens.count > 1 {
                let firstToken = tokens[0]
                
                // check if first token is command call
                if firstToken.hasPrefix("#") {
                    let commandString = firstToken.substringFromIndex(firstToken.startIndex.successor())
                    
                    if let serviceProviderType = ServiceProviderType(rawValue: commandString) {
                        println(serviceProviderType)
                        for i in 0...count(firstToken) {
                            currentProxy.deleteBackward()
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
        if let afterInputText = currentProxy.documentContextAfterInput {
            currentProxy.adjustTextPositionByCharacterOffset(count(afterInputText.utf16))
        }
        
        if let beforeInputText = lastInsertedString {
            for var i = 0, len = count(beforeInputText.utf16); i < len; i++ {
                currentProxy.deleteBackward()
            }
        }
    }
    
    func insertText(text: String) {
        currentProxy.insertText(text)
    }
    
    func deleteBackward() {
        currentProxy.deleteBackward()
    }
    
    func setCurrentProxyWithId(id: String) -> Bool {
        if let proxy = proxies[id] {
            currentProxy = proxy
            return true
        }
        return false
    }
}

protocol TextProcessingManagerDelegate: class {
    func textProcessingManagerDidChangeText(textProcessingManager: TextProcessingManager)
    func textProcessingManagerDidDetectServiceProvider(textProcessingManager: TextProcessingManager, serviceProviderType: ServiceProviderType)
}
