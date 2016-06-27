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

    override init(frame: CGRect) {
        tableView = UITableView(frame: CGRectZero, style: .Grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20.0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.backgroundColor = MediumGrey
        
        super.init(frame: frame)
        
        backgroundColor = MediumGrey
        addSubview(tableView)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addConstraints([
            tableView.al_left == al_left,
            tableView.al_top == al_top,
            tableView.al_right == al_right,
            tableView.al_bottom == al_bottom
        ])

    }

}