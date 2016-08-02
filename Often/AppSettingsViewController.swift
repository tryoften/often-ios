//
//  AppSettingsViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 8/26/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import FirebaseStorage

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
    TableViewCellDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
    var appSettingView: AppSettingsView
    var viewModel: SettingsViewModel
    var imagePicker: PackImagePickerViewController
    let storage = FIRStorage.storage()
    
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
        
        imagePicker = PackImagePickerViewController()
        
        super.init(nibName: nil, bundle: nil)
        
        appSettingView.tableView.delegate = self
        appSettingView.tableView.dataSource = self

        imagePicker.delegate = self
        
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
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = .Default
        navigationController?.navigationBar.tintColor = WhiteColor
        navigationController?.navigationBar.barTintColor = MainBackgroundColor
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(AppSettingsViewController.didDismissSettings))
        cancelButton.tintColor = UIColor.oftBlack74Color()
        navigationItem.rightBarButtonItem = cancelButton
        
        appSettingView.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let compareString: NSString = info[UIImagePickerControllerReferenceURL]?.absoluteString,
            let userId = viewModel.currentUser?.id {
            
            let storageRef = storage.referenceForURL("gs://firebase-often-dev.appspot.com/")
            var uploadTask: FIRStorageUploadTask = FIRStorageUploadTask()
            
            let pngRange: NSRange = compareString.rangeOfString("png", options: [.BackwardsSearch, .CaseInsensitiveSearch])
            if pngRange.location != NSNotFound {
                if let imageData: NSData = UIImagePNGRepresentation(image) {
                    let imageRef = storageRef.child("images/users/\(userId)/packPhoto.png")
                    uploadTask = imageRef.putData(imageData)
                }
            }
            
            let jpgRange: NSRange = compareString.rangeOfString("jpg", options: [.BackwardsSearch, .CaseInsensitiveSearch])
            if jpgRange.location != NSNotFound {
                if let imageData: NSData = UIImageJPEGRepresentation(image, 1.0) {
                    let imageRef = storageRef.child("images/users/\(userId)/packPhoto.jpg")
                    uploadTask = imageRef.putData(imageData)
                }
            }
            
            uploadTask.observeStatus(.Progress) { snapshot in
                // Upload reported progress
                if let progress = snapshot.progress {
                    let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                }
            }
            
            uploadTask.observeStatus(.Success) { snapshot in
                // Successful upload
            }
            
            uploadTask.observeStatus(.Failure) { snapshot in
                guard let storageError = snapshot.error else { return }
                guard let errorCode = FIRStorageErrorCode(rawValue: storageError.code) else { return }
                switch errorCode {
                case .ObjectNotFound:
                    print("File doesn't exist")
                case .Unauthorized:
                    print("User doesn't have permission to access file")
                case .Cancelled:
                    print("User canceled the upload")
                case .Unknown:
                    print("Unknown error occurred, inspect the server response")
                default:
                    print("File doesn't exist sum")
                }
            }
            
            let imageQueue = FIRDatabase.database().reference().child("/queues/image_resizing/tasks").childByAutoId()
            let imageId = generateIdForString(imageQueue.description())
            imageQueue.setValue([
                "imageId": imageId,
                "url": " https://storage.googleapis.com/firebase-often-dev.appspot.com/images/users/\(userId)/packPhoto.png"
            ])
            
            let processedImageRef = FIRDatabase.database().reference().child("/images/\(imageId)")
            processedImageRef.observeEventType(.Value, withBlock: { snapshot in
                if let value = snapshot.value as? [String : AnyObject] {
                    // write this image back to the pack
                }
            })
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func generateIdForString(string: String) -> String {
        let utf8str = string.dataUsingEncoding(NSUTF8StringEncoding)
        
        if let base64Encoded = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) {
            return base64Encoded
                .stringByReplacingOccurrencesOfString("/", withString: "_")
                .stringByReplacingOccurrencesOfString("+", withString: "-")
                .substringWithRange(Range<String.Index>(base64Encoded.startIndex..<base64Encoded.startIndex.advancedBy(9)))
        }
        
        return ""
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
    
    func didDismissSettings() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
