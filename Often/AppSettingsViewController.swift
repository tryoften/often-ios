//
//  AppSettingsViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/26/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit
import MessageUI

enum ProfileSettingsSection: Int {
    case Account = 0
    case Actions = 1
    case About = 2
    case Logout = 3
}

class AppSettingsViewController: UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    UIActionSheetDelegate,
    TableViewCellDelegate {
    var appSettingView: AppSettingsView
    var viewModel: SettingsViewModel
    var accountSettings = [
        "Name",
        "Email",
        "Push Notifications"
    ]
    
    var actionsSettings = [
        "How to Install Often",
        "Rate in App Store",
        "Support"
    ]
    
    var aboutSettings = [
        "Terms of Use & Privacy Policy"
    ]
    
    var logoutSettings = [
        "Logout"
    ]
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel

        appSettingView = AppSettingsView()
        appSettingView.translatesAutoresizingMaskIntoConstraints = false
        appSettingView.tableView.registerClass(UserProfileSettingsTableViewCell.self, forCellReuseIdentifier: "settingCell")

        super.init(nibName: nil, bundle: nil)
        
        appSettingView.tableView.delegate = self
        appSettingView.tableView.dataSource = self

        view.addSubview(appSettingView)
        
        navigationItem.title = "settings".uppercaseString

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = .Default

        appSettingView.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupLayout() {
        view.addConstraints([
            appSettingView.al_left == view.al_left,
            appSettingView.al_top == view.al_top,
            appSettingView.al_right == view.al_right,
            appSettingView.al_bottom == view.al_bottom
        ])
    }
    
    func pushNewAboutViewController(url: NSURL, title: String) {
        let webView = UIWebView(frame: view.bounds)
        webView.loadRequest(NSURLRequest(URL: url))
        
        let vc = UIViewController()
        vc.navigationItem.title = title
        vc.navigationController?.navigationBar.translucent = true
        vc.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
        vc.view.addSubview(webView)
        
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: TableViewDelegate and Datasource
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let enumVal = ProfileSettingsSection(rawValue: section) else {
            return nil
        }
        
        switch enumVal {
        case .Account:
            return "Account"
        case .Actions:
            return "Actions"
        case .About:
            return "About"
        case .Logout:
            return ""
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let settingsSection = ProfileSettingsSection(rawValue: section) {
            switch settingsSection {
            case .Account:
                return accountSettings.count
            case .Actions:
                return actionsSettings.count
            case .About:
                return aboutSettings.count
            case .Logout:
                return logoutSettings.count
            }
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let settingsSection = ProfileSettingsSection(rawValue: indexPath.section) {
            switch settingsSection {
            case .Account:
                switch indexPath.row {
                case 0: break
                case 1: break
                case 2: break
                default: break
                }
                
            case .Actions:
                switch indexPath.row {
                case 0:
                    let loginViewModel = LoginViewModel(sessionManager: viewModel.sessionManager)
                    let walkthroughViewController = InstallationWalkthroughViewContoller(viewModel: loginViewModel, inAppSetting: true)

                    presentViewController(walkthroughViewController, animated: true, completion: nil)
                case 1:
                    if let url = NSURL(string: "https://itunes.apple.com/us/app/apple-store/id1053313047?mt=8") {
                        UIApplication.sharedApplication().openURL(url)
                    }

                case 2:
                    if let url = NSURL(string: "https://twitter.com/tryoften") {
                        pushNewAboutViewController(url, title: "support".uppercaseString)
                    }

                default: break
                }

            case .About:
                var link, title: String?
                switch indexPath.row {
                case 0:
                    link = "http://tryoften.com/privacy"
                    title = aboutSettings[0] 
                default: break
                }


                if let page = link , url = NSURL(string: page), headerText = title {
                    pushNewAboutViewController(url, title: headerText)
                }
                
            case .Logout:
                let actionSheet = UIActionSheet(title: "Are you sure you want to logout?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Logout")
                actionSheet.showInView(view)
            }
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UserProfileSettingsSectionHeaderView()
        
        if ProfileSettingsSection.Account.rawValue == section {
            headerView.titleLabel.text = "ACCOUNT"
        } else if ProfileSettingsSection.Actions.rawValue == section {
            headerView.titleLabel.text = "ACTIONS"
        } else if ProfileSettingsSection.About.rawValue == section {
            headerView.titleLabel.text = "ABOUT"
        } else if ProfileSettingsSection.Logout.rawValue == section {
            
        }
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let settingsSection = ProfileSettingsSection(rawValue: section) else {
            return 0.01
        }

        switch settingsSection {
        case .About:
            return 30
        default:
            return 0.01
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let settingsSection: ProfileSettingsSection = ProfileSettingsSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        var cell = UserProfileSettingsTableViewCell(type: .Switch)

        switch settingsSection {
        case .Account:
            switch indexPath.row {
            case 0:
                cell = UserProfileSettingsTableViewCell(type: .Nondisclosure)
                cell.secondaryTextField.text = viewModel.currentUser?.name
                cell.userInteractionEnabled = false
                cell.delegate = self
            case 1:
                cell = UserProfileSettingsTableViewCell(type: .Nondisclosure)
                cell.secondaryTextField.text = viewModel.currentUser?.email
                cell.userInteractionEnabled = false
            case 2:
                cell = UserProfileSettingsTableViewCell(type: .Switch)
                cell.settingSwitch.addTarget(self, action: #selector(AppSettingsViewController.switchToggled(_:)), forControlEvents: .TouchUpInside)
                cell.settingSwitch.on = SessionManagerFlags.defaultManagerFlags.userNotificationSettings
                cell.disclosureIndicator.image = UIImage(named: "")
            default:
                break
            }

            cell.titleLabel.text = accountSettings[indexPath.row]
            return cell

        case .Actions:
            let cell = UserProfileSettingsTableViewCell(type: .Default)
            cell.titleLabel.text = actionsSettings[indexPath.row]
            return cell
        case .About:
            let cell = UserProfileSettingsTableViewCell(type: .Default)
            cell.titleLabel.text = aboutSettings[indexPath.row]
            return cell
        case .Logout:
            let cell = UserProfileSettingsTableViewCell(type: .Logout)
            cell.titleLabel.text = logoutSettings[indexPath.row]
            return cell
        }
    }

    func switchToggled(sender: UISwitch) {
        SessionManager.defaultManager.updateUserPushNotificationStatus(sender.on)
    }

    // MARK: UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            viewModel.sessionManager.logout()
            let loginViewModel = LoginViewModel(sessionManager: SessionManager.defaultManager)
            let vc = LoginViewController(viewModel: loginViewModel)
            vc.loginView.launchScreenLoader.hidden = true
            presentViewController(vc, animated: true, completion: nil)
        default:
            break
        }
    }
        
    //MARK: TableViewCellDelegate
    func didFinishEditingName(newName: String) {
        viewModel.currentUser?.name = newName
    }
    
}
