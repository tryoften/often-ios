//
//  TextProcessingManager.swift
//  October
//
//  Created by Luc Succes on 7/12/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import UIKit


let TextProcessingManagerProxyEvent = "textProcessingManager.setCurrentProxy"
let TextProcessingManagedResetDefaultProxyEvent = "textProceesingManager.resetDefaultProxy"
let TextProcessingManagerTextChangedEvent = "textProcesssingManager.textDidChange"

class TextProcessingManager: NSObject, UITextInputDelegate {
    weak var delegate: TextProcessingManagerDelegate?
    var currentProxy: UITextDocumentProxy
    let defaultProxy: UITextDocumentProxy
    var lastInsertedString: String?
    var proxies: [String: UITextDocumentProxy]
    var autocorrectEnabled = true
    var parsingText = false
    
    private var textBuffer: String

    init(textDocumentProxy: UITextDocumentProxy) {
        proxies = [:]
        currentProxy = textDocumentProxy
        defaultProxy = textDocumentProxy
        proxies["default"] = currentProxy
        textBuffer = ""
        
        super.init()
        
        NotificationCenter.default().addObserver(self, selector: "didReceiveSetCurrentProxy:", name: TextProcessingManagerProxyEvent, object: nil)
        NotificationCenter.default().addObserver(self, selector: "didReceiveResetDefaultProxy:", name: TextProcessingManagedResetDefaultProxyEvent, object: nil)
    }
    
    deinit {
        NotificationCenter.default().removeObserver(self)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didReceiveSetCurrentProxy(_ notification: Foundation.Notification) {
        guard let userInfo = (notification as NSNotification).userInfo,
            let proxy = notification.object as? UITextDocumentProxy,
            let setDefault = userInfo["setDefault"] as? Bool,
            let id = userInfo["id"] as? String else {
                return
        }

        if let currentProxy = currentProxy as? UIResponder {
            // swiftlint:disable force_cast
            if currentProxy as NSObject != (proxy as! NSObject) {
                currentProxy.resignFirstResponder()
            }
            // swiftlint:enable force_cast
        }
        
        proxies[id] = proxy
        
        if setDefault {
            currentProxy = proxy
        }
    }
    
    func didReceiveResetDefaultProxy(_ notification: Foundation.Notification) {
        if let proxy = currentProxy as? UIResponder {
            proxy.resignFirstResponder()
        }
        currentProxy = proxies["default"]!
    }
    
    func textWillChange(_ textInput: UITextInput?) {
        if let beforeInput = defaultProxy.documentContextBeforeInput {
            textBuffer = beforeInput
        }
        
        NotificationCenter.default().post(name: Foundation.Notification.Name(rawValue: TextProcessingManagedResetDefaultProxyEvent), object: self, userInfo: nil)
    }
    
    func textDidChange(_ textInput: UITextInput?) {
        if !defaultProxy.hasText() {
            delegate?.textProcessingManagerDidClearTextBuffer(self, text: textBuffer)
        }
    }

    func selectionWillChange(_ textInput: UITextInput?) {
        
    }

    func selectionDidChange(_ textInput: UITextInput?) {
        
    }
    
    func parseTextInCurrentDocumentProxy() {
        if parsingText {
            return
        }
        parsingText = true
        
        defer {
            parsingText = false
        }
        
        if let text = currentProxy.documentContextBeforeInput {
            let tokens = text.components(separatedBy: " ")
        }

        delegate?.textProcessingManagerDidChangeText(self)
    }

    func clearInput() {
        //move cursor to end of text
        if let afterInputText = currentProxy.documentContextAfterInput {
            currentProxy.adjustTextPosition(byCharacterOffset: afterInputText.utf16.count)
        }
        
        if let beforeInputText = lastInsertedString {
            for _ in 0..<beforeInputText.utf16.count {
                currentProxy.deleteBackward()
            }
        }
        
        delegate?.textProcessingManagerDidChangeText(self)
        broadcastTextDidChange()
    }
    
    func insertTextInProxy(_ text: String, proxy: UITextDocumentProxy) {
        proxy.insertText(text)
        delegate?.textProcessingManagerDidChangeText(self)
    }
    
    func insertText(_ text: String) {
        currentProxy.insertText(text)
        parseTextInCurrentDocumentProxy()
        broadcastTextDidChange()
    }
    
    func deleteBackward() {
        currentProxy.deleteBackward()
        parseTextInCurrentDocumentProxy()
        broadcastTextDidChange()
    }
    
    func setCurrentProxyWithId(_ id: String) -> Bool {
        if let proxy = proxies[id] {
            currentProxy = proxy
            return true
        }
        return false
    }
    
    func broadcastTextDidChange() {
        var text: String = ""
        
        if let beforeInput = currentProxy.documentContextBeforeInput {
            text += beforeInput
        }
        
        if let afterInput = currentProxy.documentContextAfterInput {
            text += afterInput
        }
        
        NotificationCenter.default().post(name: Foundation.Notification.Name(rawValue: TextProcessingManagerTextChangedEvent), object: self, userInfo: [
            "text": text
        ])
    }
    
    func characterIsPunctuation(_ character: Character) -> Bool {
        return (character == ".") || (character == "!") || (character == "?")
    }
    
    func characterIsNewline(_ character: Character) -> Bool {
        return (character == "\n") || (character == "\r")
    }
    
    func characterIsWhitespace(_ character: Character) -> Bool {
        // there are others, but who cares
        return (character == " ") || (character == "\n") || (character == "\r") || (character == "\t")
    }
    
    func charactersAreInCorrectState() -> Bool {
        let previousContext = currentProxy.documentContextBeforeInput
    
        if previousContext == nil || previousContext!.characters.count < 3 {
            return false
        }
        
        var index = previousContext!.endIndex
        
        index = previousContext!.characters.index(before: index)
        if previousContext![index] != " " {
            return false
        }
        
        index = previousContext!.characters.index(before: index)
        if previousContext![index] != " " {
            return false
        }
        
        index = previousContext!.characters.index(before: index)
        let char = previousContext![index]
        if characterIsWhitespace(char) || characterIsPunctuation(char) || char == "," {
            return false
        }
        
        return true
    }

    func stringIsWhitespace(_ string: String?) -> Bool {
        if string != nil {
            for char in string!.characters {
                if !characterIsWhitespace(char) {
                    return false
                }
            }
        }
        return true
    }
    
    func shouldAutoCapitalize() -> Bool {
        guard let autocapitalization = currentProxy.autocapitalizationType,
            let beforeContext = currentProxy.documentContextBeforeInput else {
                return false
        }

        switch autocapitalization {
        case .none:
            return false
        case .words:
            let previousCharacter = beforeContext[beforeContext.characters.index(before: beforeContext.endIndex)]
            return self.characterIsWhitespace(previousCharacter)
        case .sentences:
            let offset = min(3, beforeContext.characters.count)
            var index = beforeContext.endIndex

            for i in 0 ..< offset {
                index = beforeContext.characters.index(before: index)
                let char = beforeContext[index]

                if characterIsPunctuation(char) {
                    if i == 0 {
                        return false //not enough spaces after punctuation
                    }
                    return true //punctuation with at least one space after it
                }
                else {
                    if !characterIsWhitespace(char) {
                        return false //hit a foreign character before getting to 3 spaces
                    }
                    else if characterIsNewline(char) {
                        return true //hit start of line
                    }
                }
            }
        case .allCharacters:
            return true
        }

        return false
    }
    
}

protocol TextProcessingManagerDelegate: class {
    func textProcessingManagerDidChangeText(_ textProcessingManager: TextProcessingManager)
    func textProcessingManagerDidClearTextBuffer(_ textProcessingManager: TextProcessingManager, text: String)
}

