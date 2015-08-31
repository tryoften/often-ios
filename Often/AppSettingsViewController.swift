//
//  AppSettingsViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/26/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit

class AppSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var containerView: UIView
    var tableView: UITableView?
    
    var accountSettings = [
        "Name",
        "Email",
        "Password",
        "Push Notifications"
    ]
    
    var actionsSettings = [
        "How to Install Often",
        "Rate in App Store",
        "Support"
    ]
    
    var aboutSettings = [
        "FAQ",
        "Privacy Policy",
        "Terms of Use",
        "Licenses"
    ]
    
    enum ProfileSettingsSection: Int {
        case Account = 0
        case Actions = 1
        case About = 2
    }
    
    init() {
        containerView = UIView()
        containerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        containerView.backgroundColor = UIColor.grayColor()
        
        super.init(nibName: nil, bundle: nil)
        
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        if let tableView = tableView {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "settingCell")
            containerView.addSubview(tableView)
        }
        
        view.addSubview(containerView)
        
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if ProfileSettingsSection.Account.rawValue == section {
            return "Account"
        } else if ProfileSettingsSection.Actions.rawValue == section {
            return "Actions"
        } else if ProfileSettingsSection.About.rawValue == section {
            return "About"
        } else {
            return ""
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ProfileSettingsSection.Account.rawValue == section {
            return accountSettings.count
        } else if ProfileSettingsSection.Actions.rawValue == section {
            return actionsSettings.count
        } else if ProfileSettingsSection.About.rawValue == section {
            return aboutSettings.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath) as! UITableViewCell

        if indexPath.section == ProfileSettingsSection.Account.rawValue {
            cell.textLabel?.text = accountSettings[indexPath.row]
        } else if indexPath.section == ProfileSettingsSection.Actions.rawValue {
            cell.textLabel?.text = actionsSettings[indexPath.row]
        } else if indexPath.section == ProfileSettingsSection.About.rawValue {
            cell.textLabel?.text = aboutSettings[indexPath.row]
        } else {
            // nothing
        }
        
        return cell
    }
    
    func setupLayout() {
        view.addConstraints([
            tableView!.al_left == containerView.al_left,
            tableView!.al_top == containerView.al_top,
            tableView!.al_bottom == containerView.al_bottom,
            tableView!.al_right == containerView.al_right,
            
            containerView.al_left == view.al_left + 50,
            containerView.al_top == view.al_top,
            containerView.al_right == view.al_right,
            containerView.al_bottom == view.al_bottom
        ])
    }
}
