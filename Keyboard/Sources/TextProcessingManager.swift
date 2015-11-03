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
    var spellChecker: SpellChecker?
    var lastInsertedString: String?
    var lyricInserted = false
    var proxies: [String: UITextDocumentProxy]

    init(textDocumentProxy: UITextDocumentProxy) {
        proxies = [:]
        currentProxy = textDocumentProxy
        defaultProxy = textDocumentProxy
        proxies["default"] = currentProxy
        
        super.init()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let fileManager = NSFileManager.defaultManager()
            let filename = SpellCheckerCachedDictionaryFilename
            var path: String = SpellChecker.getFileURL(filename)!.path!
            
            if !fileManager.fileExistsAtPath(path) {
                path = NSBundle.mainBundle().resourcePath! + filename
            }
            
            if let aSpellChecker = SpellChecker.spellCheckFromCachedDictionary(path) {
                self.spellChecker = aSpellChecker
            } else {
                self.spellChecker = SpellChecker()
                self.spellChecker!.createDictionary("big.txt", language: "")
                self.spellChecker!.saveDictionary()
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveSetCurrentProxy:", name: TextProcessingManagerProxyEvent, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveResetDefaultProxy:", name: TextProcessingManagedResetDefaultProxyEvent, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didReceiveSetCurrentProxy(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let proxy = notification.object as? UITextDocumentProxy,
            let setDefault = userInfo["setDefault"] as? Bool,
            let id = userInfo["id"] as? String else {
                return
        }
        
        if let currentProxy = currentProxy as? UIResponder {
            if (currentProxy as NSObject) != (proxy as! NSObject) {
                currentProxy.resignFirstResponder()
            }
        }
        
        proxies[id] = proxy
        
        if setDefault {
            currentProxy = proxy
        }
    }
    
    func didReceiveResetDefaultProxy(notification: NSNotification) {
        if let proxy = currentProxy as? UIResponder {
            proxy.resignFirstResponder()
        }
        currentProxy = proxies["default"]!
    }
    
    func textWillChange(textInput: UITextInput?) {
        NSNotificationCenter.defaultCenter().postNotificationName(TextProcessingManagedResetDefaultProxyEvent, object: self, userInfo: nil)
    }
    
    func textDidChange(textInput: UITextInput?) {
    }

    func selectionWillChange(textInput: UITextInput?) {
        
    }

    func selectionDidChange(textInput: UITextInput?) {
        
    }
    
    func parseTextInCurrentDocumentProxy() {
        if let text = currentProxy.documentContextBeforeInput {
            let tokens = text.componentsSeparatedByString(" ")
            
            guard let firstToken = tokens.first, let lastWord = tokens.last else {
                return
            }
            print(tokens)
            
            if let suggestions = spellChecker?.lookup(lastWord, language: "", editDistanceMax: 2) {
                print("Suggestions: ", suggestions)
            }
            
            // check if first token is command call
            if firstToken.hasPrefix("#") {
                
                if let filter = delegate?.textProcessingManagerDidTextContainerFilter(text) {
                    for _ in 0...filter.text.characters.count {
                        currentProxy.deleteBackward()
                    }
                    delegate?.textProcessingManagerDidDetectFilter(self, filter: filter)
                }
                
                let commandString = firstToken.substringFromIndex(firstToken.startIndex.successor())
                if let serviceProviderType = ServiceProviderType(rawValue: commandString) {
                    print(serviceProviderType)
                    for _ in 0...firstToken.characters.count {
                        currentProxy.deleteBackward()
                    }
                    delegate?.textProcessingManagerDidDetectServiceProvider(self, serviceProviderType: serviceProviderType)
                }
            }
        }
        delegate?.textProcessingManagerDidChangeText(self)
    }
    
    func clearInput() {
        //move cursor to end of text
        if let afterInputText = currentProxy.documentContextAfterInput {
            currentProxy.adjustTextPositionByCharacterOffset(afterInputText.utf16.count)
        }
        
        if let beforeInputText = lastInsertedString {
            for var i = 0, len = beforeInputText.utf16.count; i < len; i++ {
                currentProxy.deleteBackward()
            }
        }
        
        delegate?.textProcessingManagerDidChangeText(self)
        broadcastTextDidChange()
    }
    
    func insertTextInProxy(text: String, proxy: UITextDocumentProxy) {
        proxy.insertText(text)
        delegate?.textProcessingManagerDidChangeText(self)
    }
    
    func insertText(text: String) {
        currentProxy.insertText(text)
        parseTextInCurrentDocumentProxy()
        broadcastTextDidChange()
    }
    
    func deleteBackward() {
        currentProxy.deleteBackward()
        parseTextInCurrentDocumentProxy()
        broadcastTextDidChange()
    }
    
    func setCurrentProxyWithId(id: String) -> Bool {
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
        
        NSNotificationCenter.defaultCenter().postNotificationName(TextProcessingManagerTextChangedEvent, object: self, userInfo: [
                "text": text
            ])
    }
    
    func characterIsPunctuation(character: Character) -> Bool {
        return (character == ".") || (character == "!") || (character == "?")
    }
    
    func characterIsNewline(character: Character) -> Bool {
        return (character == "\n") || (character == "\r")
    }
    
    func characterIsWhitespace(character: Character) -> Bool {
        // there are others, but who cares
        return (character == " ") || (character == "\n") || (character == "\r") || (character == "\t")
    }
    
    func charactersAreInCorrectState() -> Bool {
        let previousContext = currentProxy.documentContextBeforeInput
    
        if previousContext == nil || previousContext!.characters.count < 3 {
            return false
        }
        
        var index = previousContext!.endIndex
        
        index = index.predecessor()
        if previousContext![index] != " " {
            return false
        }
        
        index = index.predecessor()
        if previousContext![index] != " " {
            return false
        }
        
        index = index.predecessor()
        let char = previousContext![index]
        if characterIsWhitespace(char) || characterIsPunctuation(char) || char == "," {
            return false
        }
        
        return true
    }

    func stringIsWhitespace(string: String?) -> Bool {
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
        case .None:
            return false
        case .Words:
            let previousCharacter = beforeContext[beforeContext.endIndex.predecessor()]
            return self.characterIsWhitespace(previousCharacter)
        case .Sentences:
            let offset = min(3, beforeContext.characters.count)
            var index = beforeContext.endIndex

            for (var i = 0; i < offset; i += 1) {
                index = index.predecessor()
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
        case .AllCharacters:
            return true
        }

        return false
    }
    
}

protocol TextProcessingManagerDelegate: class {
    func textProcessingManagerDidChangeText(textProcessingManager: TextProcessingManager)
    func textProcessingManagerDidDetectServiceProvider(textProcessingManager: TextProcessingManager, serviceProviderType: ServiceProviderType)
    func textProcessingManagerDidDetectFilter(textProcessingManager: TextProcessingManager, filter: Filter)
    func textProcessingManagerDidTextContainerFilter(text: String) -> Filter?
    func textProcessingManagerDidReceiveSpellCheckSuggestions(TextProcessingManager: TextProcessingManager, suggestions: [SuggestItem])
}
