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
            tableView.registerClass(UserProfileSettingsTableViewCell.self, forCellReuseIdentifier: "settingCell")
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let settingsSection: ProfileSettingsSection = ProfileSettingsSection(rawValue: indexPath.section) {
            switch settingsSection {
            case .Account:
                if indexPath.row == 0 { // name
                    var cell = UserProfileSettingsTableViewCell(type: .Nondisclosure)
                    cell.titleLabel.text = accountSettings[indexPath.row]
                    cell.secondaryTextLabel.text = "Regy Perlera"
                    return cell
                } else if indexPath.row == 1 { // email
                    var cell = UserProfileSettingsTableViewCell(type: .Detailed)
                    cell.titleLabel.text = accountSettings[indexPath.row]
                    cell.secondaryTextLabel.text = "regy@tryoften.com"
                    return cell
                } else if indexPath.row == 2 { // password
                    var cell = UserProfileSettingsTableViewCell(type: .Default)
                    cell.titleLabel.text = accountSettings[indexPath.row]
                    return cell
                } else { // push notifications
                    var cell = UserProfileSettingsTableViewCell(type: .Switch)
                    cell.titleLabel.text = accountSettings[indexPath.row]
                    return cell
                }
            case .Actions:
                if indexPath.row == 0 { // How to Install
                    var cell = UserProfileSettingsTableViewCell(type: .Default)
                    cell.titleLabel.text = actionsSettings[indexPath.row]
                    return cell
                } else if indexPath.row == 1 { // Rate in App Store
                    var cell = UserProfileSettingsTableViewCell(type: .Default)
                    cell.titleLabel.text = actionsSettings[indexPath.row]
                    return cell
                } else { // Support
                    var cell = UserProfileSettingsTableViewCell(type: .Default)
                    cell.titleLabel.text = actionsSettings[indexPath.row]
                    return cell
                }
            case .About:
                if indexPath.row == 0 { // FAQ
                    var cell = UserProfileSettingsTableViewCell(type: .Default)
                    cell.titleLabel.text = aboutSettings[indexPath.row]
                    return cell
                } else if indexPath.row == 1 { // Privacy Policy
                    var cell = UserProfileSettingsTableViewCell(type: .Default)
                    cell.titleLabel.text = aboutSettings[indexPath.row]
                    return cell
                } else if indexPath.row == 2 { // Terms of Use
                    var cell = UserProfileSettingsTableViewCell(type: .Default)
                    cell.titleLabel.text = aboutSettings[indexPath.row]
                    return cell
                } else { // Licenses
                    var cell = UserProfileSettingsTableViewCell(type: .Default)
                    cell.titleLabel.text = aboutSettings[indexPath.row]
                    return cell
                }
            default:
                break
            }
        }
        let cell = UITableViewCell()
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
