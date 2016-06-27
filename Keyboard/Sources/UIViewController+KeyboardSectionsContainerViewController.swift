//
//  UIViewController+KeyboardSectionsContainerViewController.swift
//  Often
//
//  Created by Luc Succes on 12/16/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

extension UIViewController {
    var containerViewController: KeyboardSectionsContainerViewController? {
        var viewController = parent
        while viewController != nil {
            if let parentViewController = viewController as? KeyboardSectionsContainerViewController {
                return parentViewController
            }
            viewController = viewController?.parent
        }
        return nil
    }
}
