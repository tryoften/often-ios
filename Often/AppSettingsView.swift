//
//  AppSettingsView.swift
//  Often
//
//  Created by Kervins Valcourt on 12/17/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class AppSettingsView: UIView {
    var tableView: UITableView
    var navigationBar: UIView
    var titleBar: UILabel

    override init(frame: CGRect) {
        tableView = UITableView(frame: CGRectZero, style: .Grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20.0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.backgroundColor = MediumGrey

        navigationBar = UIView()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = WhiteColor
        navigationBar.layer.shadowOffset = CGSizeMake(0, 0)
        navigationBar.layer.shadowOpacity = 0.8
        navigationBar.layer.shadowColor = DarkGrey.CGColor
        navigationBar.layer.shadowRadius = 1

        titleBar = UILabel()
        titleBar.translatesAutoresizingMaskIntoConstraints = false
        titleBar.font = UIFont(name: "Montserrat-Regular", size: 12)
        titleBar.text = "settings".uppercaseString
        titleBar.backgroundColor = UIColor.clearColor()
        titleBar.numberOfLines = 0
        titleBar.textAlignment = .Center
        titleBar.textColor = BlackColor

        super.init(frame: frame)

        
        backgroundColor = MediumGrey
        addSubview(tableView)
        addSubview(navigationBar)
        navigationBar.addSubview(titleBar)

        setupLayout()


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            navigationBar.al_left == al_left,
            navigationBar.al_top == al_top,
            navigationBar.al_right == al_right,
            navigationBar.al_height == 45,

            tableView.al_left == al_left,
            tableView.al_top == navigationBar.al_bottom,
            tableView.al_right == al_right,
            tableView.al_bottom == al_bottom
            ])

        navigationBar.addConstraints([
            titleBar.al_left == navigationBar.al_left,
            titleBar.al_right == navigationBar.al_right,
            titleBar.al_bottom == navigationBar.al_bottom,
            titleBar.al_top == navigationBar.al_top
            ])
    }
    
}