//
//  KeyboardSearchBarController.swift
//  Often
//
//  Created by Luc Succes on 12/22/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class KeyboardSearchBarController: SearchBarController {
    var primaryTextDocumentProxy: UITextDocumentProxy?

    weak var textProcessor: TextProcessingManager? {
        didSet {
            primaryTextDocumentProxy = textProcessor?.currentProxy

            if let textProcessor = textProcessor, textInput = searchBar.textInput as? KeyboardSearchTextField {
                textProcessor.proxies["search"] = textInput
            }
        }
    }

    required init(viewModel aViewModel: SearchViewModel, suggestionsViewModel aSuggestionsViewModel: SearchSuggestionsViewModel, SearchTextFieldClass: SearchTextField.Type) {
        super.init(viewModel: aViewModel, suggestionsViewModel: aSuggestionsViewModel, SearchTextFieldClass: KeyboardSearchTextField.self)

        searchBar.textInput.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged)
        searchBar.textInput.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: .EditingDidBegin)
        searchBar.textInput.addTarget(self, action: "textFieldDidEndEditing:", forControlEvents: .EditingDidEnd)
        searchBar.textInput.addTarget(self, action: "reset", forControlEvents: .EditingDidEndOnExit)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        guard let textInput = searchBar.textInput as? KeyboardSearchTextField else {
            return
        }

        textProcessor?.setCurrentProxyWithId("search")
        scheduleAutocompleteRequestTimer()

        let center = NSNotificationCenter.defaultCenter()
        center.postNotificationName(RestoreKeyboardEvent, object: nil)
        center.postNotificationName(ToggleButtonKeyboardEvent, object: nil, userInfo: ["hide": true])

        delay(0.5) {
            center.postNotificationName(TextProcessingManagerProxyEvent, object: self, userInfo: [
                "id": textInput.id,
                "setDefault": true
            ])
        }
    }

    func textFieldDidChange() {
        textProcessor?.parseTextInCurrentDocumentProxy()

        if viewModel.hasReceivedResponse == true {
            scheduleAutocompleteRequestTimer()
            NSNotificationCenter.defaultCenter().postNotificationName(ToggleButtonKeyboardEvent, object: nil, userInfo: ["hide": true])
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {
        guard let textInput = searchBar.textInput as? KeyboardSearchTextField else {
            return
        }

        textProcessor?.setCurrentProxyWithId("default")
        textInput.repositionText()
    }
}