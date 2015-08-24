//
//  VenmoServiceProvider.swift
//  Surf
//
//  Created by Luc Succes on 7/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

let VenmoContactSelectedEvent = "venmo.contact.selected"
let VenmoAddSearchBarButtonEvent = "venmo.searchBar.addButton"

class VenmoServiceProvider: ServiceProvider {
    override func provideSearchBarButton() -> ServiceProviderSearchBarButton {
        return VenmoSearchBarButton(frame: CGRectZero)
    }
    
    override func provideSupplementaryViewController() -> ServiceProviderSupplementaryViewController? {
        return VenmoSupplementaryViewController(textProcessor: textProcessor)
    }
}