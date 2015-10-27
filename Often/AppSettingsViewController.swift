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
    
    enum ProfileSettingsSection: Int {
        case Account = 0
        case Actions = 1
        case About = 2
    }
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        
        tableView = UITableView(frame: CGRectZero, style: .Grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
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
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
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
                    // To allow name editing on same view inside of the cell
                    let cell = tableView.cellForRowAtIndexPath(indexPath) as! UserProfileSettingsTableViewCell
                    cell.secondaryTextField.becomeFirstResponder()
                } else if indexPath.row == 1 { // email
                    
                } else if indexPath.row == 2 { // password
                    
                } else { // push notifications
                    
                }
            case .Actions:
                if indexPath.row == 0 { // How to Install
                    RootViewController.sharedInstance().popToRootAndSwitchToViewController(UIViewController(), withSlideOutAnimation: true, andCompletion: {
                    })
                } else if indexPath.row == 1 { // Rate in App Store
                    
                } else { // Support
                    launchEmail(self)
                }
            case .About:
                if indexPath.row == 0 { // FAQ
                    let vc = SettingsWebViewController(website: "http://www.google.com")
                    presentViewController(vc, animated: true, completion: nil)
                } else if indexPath.row == 1 { // Privacy Policy
                    let vc = SettingsWebViewController(website: "http://www.google.com")
                    presentViewController(vc, animated: true, completion: nil)
                } else if indexPath.row == 2 { // Terms of Use
                    let vc = SettingsWebViewController(website: "http://www.google.com")
                    presentViewController(vc, animated: true, completion: nil)
                } else { // Licenses
                    let vc = SettingsWebViewController(website: "http://www.google.com")
                    presentViewController(vc, animated: true, completion: nil)
                }
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
