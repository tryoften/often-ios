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
    case account = 0
    case actions = 1
    case about = 2
    case logout = 3
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
        appSettingView.tableView.register(UserProfileSettingsTableViewCell.self, forCellReuseIdentifier: "settingCell")
        
        super.init(nibName: nil, bundle: nil)
        
        appSettingView.tableView.delegate = self
        appSettingView.tableView.dataSource = self

        view.addSubview(appSettingView)
        
        navigationItem.title = "settings".uppercased()

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared().setStatusBarHidden(false, with: .none)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .default

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
    
    func pushNewAboutViewController(_ url: URL, title: String) {
        let webView = UIWebView(frame: view.bounds)
        webView.loadRequest(URLRequest(url: url))
        
        let vc = UIViewController()
        vc.navigationItem.title = title
        vc.navigationController?.navigationBar.isTranslucent = true
        vc.navigationController?.navigationBar.tintColor = UIColor.black()
        
        vc.view.addSubview(webView)
        
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: TableViewDelegate and Datasource
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let enumVal = ProfileSettingsSection(rawValue: section) else {
            return nil
        }
        
        switch enumVal {
        case .account:
            return "Account"
        case .actions:
            return "Actions"
        case .about:
            return "About"
        case .logout:
            return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let settingsSection = ProfileSettingsSection(rawValue: section) {
            switch settingsSection {
            case .account:
                return accountSettings.count
            case .actions:
                return actionsSettings.count
            case .about:
                return aboutSettings.count
            case .logout:
                return logoutSettings.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let settingsSection = ProfileSettingsSection(rawValue: (indexPath as NSIndexPath).section) {
            switch settingsSection {
            case .account:
                switch (indexPath as NSIndexPath).row {
                case 0: break
                case 1: break
                case 2: break
                default: break
                }
                
            case .actions:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    let loginViewModel = LoginViewModel(sessionManager: viewModel.sessionManager)
                    let walkthroughViewController = InstallationWalkthroughViewContoller(viewModel: loginViewModel, inAppSetting: true)

                    present(walkthroughViewController, animated: true, completion: nil)
                case 1:
                    if let url = URL(string: "https://itunes.apple.com/us/app/apple-store/id1053313047?mt=8") {
                        UIApplication.shared().openURL(url)
                    }

                case 2:
                    if let url = URL(string: "https://twitter.com/tryoften") {
                        pushNewAboutViewController(url, title: "support".uppercased())
                    }

                default: break
                }

            case .about:
                var link, title: String?
                switch (indexPath as NSIndexPath).row {
                case 0:
                    link = "http://www.tryoften.com/privacypolicy.html"
                    title = aboutSettings[0] 
                default: break
                }


                if let page = link , url = URL(string: page), headerText = title {
                    pushNewAboutViewController(url, title: headerText)
                }
                
            case .logout:
                let actionSheet = UIActionSheet(title: "Are you sure you want to logout?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Logout")
                actionSheet.show(in: view)
            }
        }

        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UserProfileSettingsSectionHeaderView()
        
        if ProfileSettingsSection.account.rawValue == section {
            headerView.titleLabel.text = "ACCOUNT"
        } else if ProfileSettingsSection.actions.rawValue == section {
            headerView.titleLabel.text = "ACTIONS"
        } else if ProfileSettingsSection.about.rawValue == section {
            headerView.titleLabel.text = "ABOUT"
        } else if ProfileSettingsSection.logout.rawValue == section {
            
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let settingsSection = ProfileSettingsSection(rawValue: section) else {
            return 0.01
        }

        switch settingsSection {
        case .about:
            return 30
        default:
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingsSection: ProfileSettingsSection = ProfileSettingsSection(rawValue: (indexPath as NSIndexPath).section) else {
            return UITableViewCell()
        }

        var cell = UserProfileSettingsTableViewCell(type: .switch)

        switch settingsSection {
        case .account:
            switch (indexPath as NSIndexPath).row {
            case 0:
                cell = UserProfileSettingsTableViewCell(type: .nondisclosure)
                cell.secondaryTextField.text = viewModel.currentUser?.name
                cell.isUserInteractionEnabled = false
                cell.delegate = self
            case 1:
                cell = UserProfileSettingsTableViewCell(type: .nondisclosure)
                cell.secondaryTextField.text = viewModel.currentUser?.email
                cell.isUserInteractionEnabled = false
            case 2:
                cell = UserProfileSettingsTableViewCell(type: .switch)
                cell.settingSwitch.addTarget(self, action: #selector(AppSettingsViewController.switchToggled(_:)), for: .touchUpInside)
                cell.settingSwitch.isOn = SessionManagerFlags.defaultManagerFlags.userNotificationSettings
                cell.disclosureIndicator.image = UIImage(named: "")
            default:
                break
            }

            cell.titleLabel.text = accountSettings[(indexPath as NSIndexPath).row]
            return cell

        case .actions:
            let cell = UserProfileSettingsTableViewCell(type: .default)
            cell.titleLabel.text = actionsSettings[(indexPath as NSIndexPath).row]
            return cell
        case .about:
            let cell = UserProfileSettingsTableViewCell(type: .default)
            cell.titleLabel.text = aboutSettings[(indexPath as NSIndexPath).row]
            return cell
        case .logout:
            let cell = UserProfileSettingsTableViewCell(type: .logout)
            cell.titleLabel.text = logoutSettings[(indexPath as NSIndexPath).row]
            return cell
        }
    }

    func switchToggled(_ sender: UISwitch) {
        SessionManager.defaultManager.updateUserPushNotificationStatus(sender.isOn)
    }

    // MARK: UIActionSheetDelegate
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            viewModel.sessionManager.logout()
            let loginViewModel = LoginViewModel(sessionManager: SessionManager.defaultManager)
            let vc = LoginViewController(viewModel: loginViewModel)
            vc.loginView.launchScreenLoader.isHidden = true
            present(vc, animated: true, completion: nil)
        default:
            break
        }
    }
        
    //MARK: TableViewCellDelegate
    func didFinishEditingName(_ newName: String) {
        viewModel.currentUser?.name = newName
    }
    
}
