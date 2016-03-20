//
//  KeyboardBrowseViewController.swift
//  Often
//
//  Created by Luc Succes on 3/4/16.
//  Copyright © 2016 Surf Inc. All rights reserved.
//

import UIKit


class KeyboardBrowseViewController: BrowseViewController {
    override var topPadding: CGFloat {
        return KeyboardTabBarHeight
    }
    override var barHeight: CGFloat {
        return KeyboardSearchBarHeight
    }

    override init(collectionViewLayout: UICollectionViewLayout, viewModel: BrowseViewModel, textProcessor: TextProcessingManager?) {
        super.init(collectionViewLayout: collectionViewLayout, viewModel: viewModel, textProcessor: textProcessor)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChanged", name: KeyboardOrientationChangeEvent, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupSearchBar() {
        let baseURL = Firebase(url: BaseURL)
        searchViewController = SearchViewController(
            viewModel: SearchViewModel(base: baseURL),
            suggestionsViewModel: SearchSuggestionsViewModel(base: baseURL),
            textProcessor: self.textProcessor!,
            SearchBarControllerClass: KeyboardSearchBarController.self,
            SearchBarClass: KeyboardSearchBar.self)

        guard let searchViewController = searchViewController else {
            return
        }

        if let keyboardSearchBarController = searchViewController.searchBarController as? KeyboardSearchBarController {
            keyboardSearchBarController.textProcessor = textProcessor!
        }

        addChildViewController(searchViewController)
        view.addSubview(searchViewController.view)
        view.addSubview(searchViewController.searchBarController.view)
    }

    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
        isFullAccessGranted()
    }

    func isFullAccessGranted() {
        let isFullAccessEnabled = UIPasteboard.generalPasteboard().isKindOfClass(UIPasteboard)

        if !isFullAccessEnabled {
            showEmptyStateViewForState(.NoKeyboard, completion: { view -> Void in
                view.primaryButton.hidden = true
                view.imageViewTopConstraint?.constant = -35
                view.titleLabel.text = "You forgot to allow Full-Access"
            })

        } else {
            hideEmptyStateView()
        }
    }

    override func showNavigationBar(animated: Bool) {
        if shouldSendScrollEvents {
            setNavigationBarOriginY(0, animated: true)
        }
    }

    override func hideNavigationBar(animated: Bool) {
        if shouldSendScrollEvents {
            var top = -2 * CGRectGetHeight(tabBarFrame)
            if searchViewController?.searchBarController.searchBar.selected == true {
                top = -CGRectGetHeight(tabBarFrame)
            }

            setNavigationBarOriginY(top, animated: true)
        }
    }

    override func setNavigationBarOriginY(y: CGFloat, animated: Bool) {
    }
}
