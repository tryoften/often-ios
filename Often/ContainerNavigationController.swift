//
//  ContainerNavigationController.swift
//  Often
//
//  Created by Kervins Valcourt on 12/23/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class ContainerNavigationController: UINavigationController {
    var searchBar: SearchBarController?
    var statusBarBackground: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.translucent = false

        statusBarBackground = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 20))
        statusBarBackground.backgroundColor = WhiteColor
        view.addSubview(statusBarBackground)

        UITextField.appearance().font = UIFont(name: "OpenSans-Semibold", size: 12)
        UINavigationBar.appearance().barStyle = .Black
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
    }
}
