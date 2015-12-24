//
//  UIViewController+SearchBarNavigationController.swift
//  Often
//
//  Created by Kervins Valcourt on 12/23/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

extension UIViewController {

    var mainContainerViewController: SearchBarNavigationController? {
        var viewController = parentViewController
        while viewController != nil {
            if let parentViewController = viewController as? SearchBarNavigationController {
                return parentViewController
            }
            viewController = viewController?.parentViewController
        }
        return nil
    }
}