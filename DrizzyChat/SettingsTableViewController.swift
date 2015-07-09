//
//  SettingsTableViewController.swift
//  Drizzy
//
//  Created by Luc Succes on 6/20/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI

class SettingsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    var tableView: UITableView
    var navigationBar: UIView
    var navBarLabel: UILabel
    var backButton: UIButton
    
    var settingLabels = [
        "HOW TO INSTALL",
        "FAQ",
        "RATE IN APP STORE",
        "SUPPORT",
        "LICENSES",
        "LOGOUT"
    ]
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        tableView = UITableView()
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.scrollEnabled = false
        
        navigationBar = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 50))
        navigationBar.backgroundColor = UIColor.blackColor()
        
        navBarLabel = UILabel()
        navBarLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        navBarLabel.textColor = UIColor.whiteColor()
        navBarLabel.backgroundColor = UIColor.clearColor()
        navBarLabel.textAlignment = .Center
        navBarLabel.text = "SETTINGS"
        navBarLabel.font = UIFont(name: "OpenSans", size: 15.0)
        
        backButton = UIButton()
        backButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        backButton.setImage(UIImage(named: "BackButton"), forState: UIControlState.Normal)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        backButton.addTarget(self, action: "backButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(navigationBar)
        navigationBar.addSubview(navBarLabel)
        navigationBar.addSubview(backButton)
        view.addSubview(tableView)
        
        setupLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(fromHexString: "#202020")
        tableView.registerClass(SettingsTableViewCell.self, forCellReuseIdentifier: "settingsCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingLabels.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingsCell", forIndexPath: indexPath) as! SettingsTableViewCell
    
        cell.labelView.text = settingLabels[indexPath.row]

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            let vc = KeyboardInstallationWalkthroughViewController()
            presentViewController(vc, animated: true, completion: nil)
        case 1:
            let vc = SettingsWebViewController(website: "http://onoctober.com/faq.html")
            presentViewController(vc, animated: true, completion: nil)
        case 3:
            launchEmail(self)
        case 4:
            let vc = SettingsWebViewController(website: "http://onoctober.com/licensing.html")
            presentViewController(vc, animated: true, completion: nil)
        case 5:
                var sessionManager = SessionManager.defaultManager
                sessionManager.logout()
                
                var viewModel = SignUpWalkthroughViewModel(sessionManager: sessionManager)
                var navigationController = BaseNavigationController(rootViewController: SignUpLoginWalkthroughViewController(viewModel: viewModel))
                
                self.view.window?.rootViewController = navigationController
            default:
                let vc = SettingsWebViewController(website: "https://www.google.com/?gws_rd=ssl")
                presentViewController(vc, animated: true, completion: nil)
        }
    }

    func backButtonTapped() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func launchEmail(sender: AnyObject) {
        
        var emailTitle = "Feedback"
        var messageBody = ""
        var toRecipents = ["feedback@drizzyapp.com", "regy@drizzyapp.com"]
        var mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.presentViewController(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
        switch result.value {
        case MFMailComposeResultCancelled.value:
            println("Mail cancelled")
        case MFMailComposeResultSaved.value:
            println("Mail saved")
        case MFMailComposeResultSent.value:
            println("Mail sent")
        case MFMailComposeResultFailed.value:
            println("Mail sent failure: %@", [error.localizedDescription])
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupLayout() {
        view.addConstraints([
            tableView.al_left == view.al_left,
            tableView.al_right == view.al_right,
            tableView.al_bottom == view.al_bottom,
            tableView.al_top == view.al_top + 70,
            
            navigationBar.al_width == UIScreen.mainScreen().bounds.width,
            navigationBar.al_top == view.al_top,
            navigationBar.al_centerX == view.al_centerX,
            navigationBar.al_height == 50
        ])
        
        navigationBar.addConstraints([
            navBarLabel.al_centerX == navigationBar.al_centerX,
            navBarLabel.al_centerY == navigationBar.al_centerY,
            
            backButton.al_left == navigationBar.al_left,
            backButton.al_top == navigationBar.al_top,
            backButton.al_width == 50,
            backButton.al_height == 50
        ])
    }
}
