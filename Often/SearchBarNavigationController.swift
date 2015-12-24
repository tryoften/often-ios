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
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barTintColor = DarkGrey

        searchBar = SearchBarController(viewModel: SearchViewModel(base:baseURL), suggestionsViewModel: SearchSuggestionsViewModel(base: baseURL), SearchTextFieldClass: MainAppSearchTextField.self)
        searchBar?.view.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(searchBar!.view)

        setupLayout()

    }

    func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            searchBar!.view.al_top == navigationBar.al_top,
            searchBar!.view.al_right == navigationBar.al_right,
            searchBar!.view.al_left == navigationBar.al_left,
            searchBar!.view.al_bottom == navigationBar.al_bottom,
        ]
        view.addConstraints(constraints)
        
    }

}
