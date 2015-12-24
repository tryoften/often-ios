//
//  SearchBarNavigationController.swift
//  Often
//
//  Created by Kervins Valcourt on 12/23/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class SearchBarNavigationController: UINavigationController {
    var searchBar: SearchBarController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupNavbar() {
        let baseURL = Firebase(url: BaseURL)
        UINavigationBar.appearance().backgroundColor = UIColor.whiteColor()

        searchBar = SearchBarController(viewModel: SearchViewModel(base:baseURL),
            suggestionsViewModel: SearchSuggestionsViewModel(base: baseURL),
            SearchTextFieldClass: MainAppSearchTextField.self)

        searchBar?.view.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(searchBar!.view)

        setupLayout()
    }

    func setupLayout() {
        guard let searchBarView = searchBar?.view else {
            return
        }

        view.addConstraints([
            searchBarView.al_height == KeyboardSearchBarHeight,
            searchBarView.al_right == navigationBar.al_right,
            searchBarView.al_left == navigationBar.al_left,
            searchBarView.al_bottom == navigationBar.al_bottom,
        ])
    }
}
