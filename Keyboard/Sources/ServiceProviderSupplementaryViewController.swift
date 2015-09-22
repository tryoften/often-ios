//
//  ServiceProviderSupplementaryViewController.swift
//  Surf
//
//  Created by Luc Succes on 7/19/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class ServiceProviderSupplementaryViewController: UIViewController {
    weak var searchBarController: SearchBarController?
    
    var height: CGFloat! {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(ResizeKeyboardEvent, object: self, userInfo: [
                "height": height
            ])
        }
    }

    var supplementaryViewHeight: CGFloat {
        return 0.0
    }
    var searchBarPlaceholderText: String {
        return ""
    }
    
    init(textProcessor: TextProcessingManager) {
        super.init(nibName: nil, bundle: nil)
        height = supplementaryViewHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}