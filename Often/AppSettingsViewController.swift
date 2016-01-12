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
    MFMailComposeViewControllerDelegate,
    UIActionSheetDelegate,
    TableViewCellDelegate {
    var appSettingView: AppSettingsView
    var viewModel: SettingsViewModel
    
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

        navigationItem.titleView = appSettingView.titleBar
        appSettingView.titleBar.sizeToFit()

        view.addSubview(appSettingView)

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
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationBar.translucent = false
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
                    let walkthroughViewController = KeyboardInstallationWalkthroughViewController(viewModel: loginViewModel)
                    walkthroughViewController.inAppDisplay = true
                    presentViewController(walkthroughViewController, animated: true, completion: nil)
                case 1: break
                case 2: launchEmail(self)
                default: break
                }

            case .About:
                var vc: SettingsWebViewController?

                switch indexPath.row {
                case 0: vc = SettingsWebViewController(title:"faq", website: "http://www.tryoften.com/faq.html")
                case 1:  vc = SettingsWebViewController(title: "terms of use & privacy policy", website: "http://www.tryoften.com/privacypolicy.html")
                default: break
                }

                if let webView = vc {
                    presentViewController(webView, animated: true, completion: nil)
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
                cell.delegate = self
            case 1:
                cell = UserProfileSettingsTableViewCell(type: .Nondisclosure)
                cell.secondaryTextField.text = viewModel.currentUser?.email
                cell.userInteractionEnabled = false
            case 2:
                cell = UserProfileSettingsTableViewCell(type: .Nondisclosure)
                cell.disclosureIndicator.image = UIImage(named: "")
               cell.userInteractionEnabled = false
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

    // MARK: MFMailComposeViewControllerDelegate - (Does not work in Simulator)
    func launchEmail(sender: AnyObject) {
        let emailTitle = "Often Feedback"
        let messageBody = ""
        let toRecipents = ["feedback@tryoften.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        mc.modalTransitionStyle = .CoverVertical
        presentViewController(mc, animated: true, completion: nil)
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            print("logout")
            viewModel.sessionManager.logout()
            let loginViewModel = LoginViewModel(sessionManager: viewModel.sessionManager)
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
