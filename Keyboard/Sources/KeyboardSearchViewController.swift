//
//  KeyboardSearchViewController.swift
//  Often
//
//  Created by Luc Succes on 3/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit

class KeyboardSearchViewController: SearchViewController,
    KeyboardSectionsContainerViewControllerDelegate {

    override init(viewModel aViewModel: SearchViewModel,
        suggestionsViewModel: SearchSuggestionsViewModel,
        textProcessor aTextProcessor: TextProcessingManager?,
        SearchBarControllerClass: SearchBarController.Type,
        SearchBarClass: SearchBar.Type) {

            super.init(viewModel: aViewModel,
                suggestionsViewModel: suggestionsViewModel,
                textProcessor: aTextProcessor,
                SearchBarControllerClass: SearchBarControllerClass,
                SearchBarClass: SearchBarClass)


            let center = NSNotificationCenter.defaultCenter()
            center.addObserver(self, selector: "didTapEnterButton:", name: KeyboardEnterKeyTappedEvent, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func keyboardSectionsContainerViewControllerShouldShowBarShadow(containerViewController: KeyboardSectionsContainerViewController) -> Bool {
        return false
    }

    override func searchSuggestionViewControllerDidTapSuggestion(viewController: SearchSuggestionsViewController, suggestion: SearchSuggestion) {
        super.searchSuggestionViewControllerDidTapSuggestion(viewController, suggestion: suggestion)

        switch suggestion.type {
        case .Query:
            containerViewController?.resetPosition()

            if let searchBar = searchBarController.searchBar as? KeyboardSearchBar {
                searchBar.cancelButton.selected = true
            }
        default: break
        }
    }

    override func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        super.searchBarTextDidBeginEditing(searchBar)

        if let containerViewController = containerViewController {
            containerViewController.hideTabBar(true, animations: nil)
            var searchBarFrame = self.searchBarController.view.frame
            searchBarFrame.origin.y = containerViewController.tabBarHeight
            searchBarController.view.frame = searchBarFrame
        }
    }

    override func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        super.searchBarTextDidEndEditing(searchBar)

        containerViewController?.resetPosition()
        containerViewController?.showTabBar(true, animations: nil)
    }

    override func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        super.searchBarCancelButtonClicked(searchBar)
        containerViewController?.resetPosition()
    }

    override func searchViewModelDidReceiveResponse(searchViewModel: SearchViewModel, response: SearchResponse, responseChanged: Bool) {
        super.searchViewModelDidReceiveResponse(searchViewModel, response: response, responseChanged: responseChanged)

        NSNotificationCenter.defaultCenter().postNotificationName(CollapseKeyboardEvent, object: self)
    }
}