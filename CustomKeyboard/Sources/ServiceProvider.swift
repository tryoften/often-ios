//
//  ServiceProvider.swift
//  Surf
//
//  Created by Luc Succes on 7/19/15.
//  Copyright (c) 2015 October Labs Inc. All rights reserved.
//

import Foundation

enum ServiceProviderType: String {
    case Venmo = "venmo"
    case Foursquare = "foursquare"
}

class ServiceProvider {
    let type: ServiceProviderType
    let textProcessor: TextProcessingManager
    var searchBarController: SearchBarController?
    
    init(providerType: ServiceProviderType, textProcessor: TextProcessingManager) {
        type = providerType
        self.textProcessor = textProcessor
    }
    
    func provideSupplementaryViewController() -> ServiceProviderSupplementaryViewController? {
        return nil
    }
    
    func provideSearchBarButton() -> ServiceProviderSearchBarButton {
        return ServiceProviderSearchBarButton()
    }
}