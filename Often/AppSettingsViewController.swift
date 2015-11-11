//
//  AppSettingsViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/26/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit
import MessageUI

class AppSettingsViewController: UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    MFMailComposeViewControllerDelegate,
    UIActionSheetDelegate,
    SlideNavigationControllerDelegate,
    TableViewCellDelegate {
    
    var tableView: UITableView
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
        "Privacy Policy",
        "Terms of Use",
        "Licenses"
    ]
    
    var logoutSettings = [
        "Logout"
    ]
    
    enum ProfileSettingsSection: Int {
        case Account = 0
        case Actions = 1
        case About = 2
        case Logout = 3
    }
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        
        tableView = UITableView(frame: CGRectZero, style: .Grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20.0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.registerClass(UserProfileSettingsTableViewCell.self, forCellReuseIdentifier: "settingCell")
        tableView.backgroundColor = MediumGrey
        
        super.init(nibName: nil, bundle: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.layer.masksToBounds = true
        view.backgroundColor = MediumGrey
        view.addSubview(tableView)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: TableViewDelegate and Datasource
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let enumVal = ProfileSettingsSection(rawValue: section) else {
            return nil
        }
        
        switch(enumVal) {
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
            switch(settingsSection) {
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
                if indexPath.row == 0 { // name
                    
                } else if indexPath.row == 1 { // email
                    
                } else if indexPath.row == 2 { // password
                    
                } else { // push notifications
                    
                }
                break
            case .Actions:
                if indexPath.row == 0 { // How to Install
                    let signupViewModel = SignupViewModel(sessionManager: viewModel.sessionManager)
                    let walkthroughViewController = KeyboardInstallationWalkthroughViewController(viewModel: signupViewModel)
                    walkthroughViewController.inAppDisplay = true
                    RootViewController.sharedInstance().popToRootAndSwitchToViewController(walkthroughViewController, withSlideOutAnimation: true, andCompletion: {
                    })
                } else if indexPath.row == 1 { // Rate in App Store
                    
                } else { // Support
                    launchEmail(self)
                }
                break
            case .About:
                if indexPath.row == 0 { // FAQ
                    let vc = SettingsWebViewController(title:"faq", website: "http://www.tryoften.com/faq.html")
                    RootViewController.sharedInstance().popToRootAndSwitchToViewController(vc, withSlideOutAnimation: true, andCompletion: {
                    })
                } else if indexPath.row == 1 { // Privacy Policy
                    let vc = SettingsWebViewController(title: "terms of use & privacy policy", website: "http://www.tryoften.com/privacypolicy.html")
                    RootViewController.sharedInstance().popToRootAndSwitchToViewController(vc, withSlideOutAnimation: true, andCompletion: {
                    })
                } else if indexPath.row == 2 { // Terms of Use
                    let vc = SettingsWebViewController(title: "terms of use & privacy policy", website: "http://www.tryoften.com/privacypolicy.html")
                    RootViewController.sharedInstance().popToRootAndSwitchToViewController(vc, withSlideOutAnimation: true, andCompletion: {
                    })
                } 
                break
            case .Logout:
                let actionSheet = UIActionSheet(title: "Are you sure you want to logout?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Logout")
                actionSheet.showInView(view)
                break
            default:
                break
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
        if let settingsSection = ProfileSettingsSection(rawValue: section) {
            switch(settingsSection) {
            case .About:
                return 50
            default:
                return 0.01
            }
        }
        return 0.01
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let settingsSection: ProfileSettingsSection = ProfileSettingsSection(rawValue: indexPath.section) {
            switch settingsSection {
            case .Account:
                if indexPath.row == 0 { // name
                    let cell = UserProfileSettingsTableViewCell(type: .Nondisclosure)
                    cell.titleLabel.text = accountSettings[indexPath.row]
                    cell.secondaryTextField.text = viewModel.currentUser?.name
                    cell.delegate = self
                    return cell
                } else if indexPath.row == 1 { // email
                    let cell = UserProfileSettingsTableViewCell(type: .Nondisclosure)
                    cell.titleLabel.text = accountSettings[indexPath.row]
                    cell.secondaryTextField.text = viewModel.currentUser?.email
                    cell.userInteractionEnabled = false
                    return cell
                } else if indexPath.row == 2 { // password
                    let cell = UserProfileSettingsTableViewCell(type: .Default)
                    cell.titleLabel.text = accountSettings[indexPath.row]
                    cell.disclosureIndicator.image = UIImage(named: "")
                    cell.userInteractionEnabled = false
                    return cell
                } else { // push notifications
                    let cell = UserProfileSettingsTableViewCell(type: .Switch)
                    cell.titleLabel.text = accountSettings[indexPath.row]
                    return cell
                }
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
            default:
                break
            }
        }
        let cell = UITableViewCell()
        return cell
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
        
        presentViewController(mc, animated: true, completion: nil)
    }
    
//    override func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
//        RootViewController.sharedInstance().popToRootAndSwitchToViewController(viewControllerToPresent, withSlideOutAnimation: flag, andCompletion: {
//            completion?()
//        })
//    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            print("logout")
            viewModel.sessionManager.logout()
            let signupViewModel = SignupViewModel(sessionManager: viewModel.sessionManager)
            let vc = SignupViewController(viewModel: signupViewModel)
            RootViewController.sharedInstance().popToRootAndSwitchToViewController(vc, withSlideOutAnimation: true, andCompletion: {
            })
            break
        default:
            break
        }
    }
        
    //MARK: TableViewCellDelegate
    func didFinishEditingName(newName: String) {
        viewModel.currentUser?.name = newName
    }
    
    func setupLayout() {
        view.addConstraints([
            tableView.al_left == view.al_left + 60,
            tableView.al_top == view.al_top,
            tableView.al_right == view.al_right,
            tableView.al_bottom == view.al_bottom
        ])
    }
}
