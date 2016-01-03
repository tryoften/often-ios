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

            if let textProcessor = textProcessor, searchBar = searchBar as? KeyboardSearchBar {
                textProcessor.proxies["search"] = searchBar.textInput
            }
        }
    }

    required init(viewModel aViewModel: SearchViewModel, suggestionsViewModel aSuggestionsViewModel: SearchSuggestionsViewModel, SearchBarClass: SearchBar.Type) {
        super.init(viewModel: aViewModel, suggestionsViewModel: aSuggestionsViewModel, SearchBarClass: SearchBarClass)

        guard let searchBar = searchBar as? KeyboardSearchBar else {
            return
        }
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        searchBar.textInput.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged)
        searchBar.textInput.addTarget(self, action: "textFieldDidBeginEditing", forControlEvents: .EditingDidBegin)
        searchBar.textInput.addTarget(self, action: "textFieldDidEndEditing", forControlEvents: .EditingDidEnd)
        searchBar.textInput.addTarget(self, action: "reset", forControlEvents: .EditingDidEndOnExit)		

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func textFieldDidBeginEditing() {
        guard let searchBar = self.searchBar as? KeyboardSearchBar else {
            return
        }

        textProcessor?.setCurrentProxyWithId("search")
        scheduleAutocompleteRequestTimer()

        let center = NSNotificationCenter.defaultCenter()
        center.postNotificationName(RestoreKeyboardEvent, object: nil)
        center.postNotificationName(ToggleButtonKeyboardEvent, object: nil, userInfo: ["hide": true])

        delay(0.5) {
            center.postNotificationName(TextProcessingManagerProxyEvent, object: self, userInfo: [
                "id": searchBar.textInput.id,
                "setDefault": true
            ])
        }
    }

    override func textFieldDidChange() {
        super.textFieldDidChange()
        textProcessor?.parseTextInCurrentDocumentProxy()

        if viewModel.hasReceivedResponse == true {
            NSNotificationCenter.defaultCenter().postNotificationName(ToggleButtonKeyboardEvent, object: nil, userInfo: ["hide": true])
        }
    }

    func textFieldDidEndEditing() {
        textProcessor?.setCurrentProxyWithId("default")
        if let searchBar = self.searchBar as? KeyboardSearchBar {
             searchBar.textInput.repositionText()
            reset()
        }
    }
}