//
//  ParseConfig.swift
//  Often
//
//  Created by Luc Succes on 11/18/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class ParseConfig {
    static let defaultConfig = ParseConfig()

    init() {
#if !DEBUG
        Parse.setApplicationId(ParseAppID, clientKey: ParseClientKey)
        PFConfig.getConfigInBackgroundWithBlock { (config, error) in
            if let newAppStoreLink = PFConfig.currentConfig().objectForKey("AppStoreLink") as? String {
                AppStoreLink = newAppStoreLink
            }
        }
#endif
    }
}