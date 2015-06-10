//
//  SignUpWalkthroughViewController.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 5/25/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation
import WebKit

class WalkthroughViewController: UIViewController {
    var viewModel: SignUpWalkthroughViewModel!
    var artistService: ArtistService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var firebaseRoot = Firebase(url: BaseURL)
        self.artistService = ArtistService(root: firebaseRoot)
        viewModel = SignUpWalkthroughViewModel(artistService: self.artistService)
    }
    
    override func viewWillAppear(animated: Bool) {
        setupLayout()
    }
    
    func setupNavBar (titlePushViewButton: String) {
        var skipButton = UIBarButtonItem(title: titlePushViewButton.uppercaseString, style: .Plain, target: self, action: "didTapNavButton")
        
        self.navigationItem.setRightBarButtonItem(skipButton, animated: true)
        self.navigationItem.title = "sign up".uppercaseString
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = BlackColor
    }
    
    func didTapNavButton() {}
    func setupLayout() {}
}

class SignUpLoginWalkthroughViewController: WalkthroughViewController {
    var loginSignUpPage: SignUpOrLoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginSignUpPage = SignUpOrLoginView()
        loginSignUpPage.setTranslatesAutoresizingMaskIntoConstraints(false)
        loginSignUpPage.signUpButton.addTarget(self, action: "didTapSignUpButton", forControlEvents: .TouchUpInside)
        loginSignUpPage.loginButton.addTarget(self, action: "didTapLoginButton", forControlEvents: .TouchUpInside)
        
        view.addSubview(loginSignUpPage)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func setupLayout() {
     super.setupLayout()
        
        var constraints: [NSLayoutConstraint] = [
            loginSignUpPage.al_top == view.al_top,
            loginSignUpPage.al_bottom == view.al_bottom,
            loginSignUpPage.al_left == view.al_left,
            loginSignUpPage.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }
    
    func didTapSignUpButton() {
        let phoneNumbervc = PhoneNumberWalkthroughViewController()
        
        self.navigationController?.pushViewController(phoneNumbervc, animated: true)
    }
    
    func didTapLoginButton () {
        return
    }
}

class PhoneNumberWalkthroughViewController: WalkthroughViewController, UITableViewDelegate, UITextFieldDelegate  {
    var addPhoneNumberPage: SignUpPhoneNumberView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPhoneNumberPage = SignUpPhoneNumberView()
        addPhoneNumberPage.setTranslatesAutoresizingMaskIntoConstraints(false)
        addPhoneNumberPage.phoneNumberTxtField.delegate = self
        addPhoneNumberPage.phoneNumberTxtField.keyboardType = .PhonePad
        
        setupNavBar("skip")
    
        view.addSubview(addPhoneNumberPage)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        delay(0.05) {
            addPhoneNumberPage.phoneNumberTxtField.becomeFirstResponder()
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        var constraints: [NSLayoutConstraint] = [
            addPhoneNumberPage.al_top == view.al_top,
            addPhoneNumberPage.al_bottom == view.al_bottom,
            addPhoneNumberPage.al_left == view.al_left,
            addPhoneNumberPage.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }
    
    override func didTapNavButton() {
        let Namevc = SignUpNameWalkthroughViewController()
        
        self.navigationController?.pushViewController(Namevc, animated: true)
    }
}

class SignUpNameWalkthroughViewController: WalkthroughViewController, UITableViewDelegate, UITextFieldDelegate  {
    var addNamePage: SignUpNameView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNamePage = SignUpNameView()
        addNamePage.setTranslatesAutoresizingMaskIntoConstraints(false)
        addNamePage.fullNameTxtField.delegate = self
    
         setupNavBar("next")
        
        view.addSubview(addNamePage)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        delay(0.05) {
            addNamePage.fullNameTxtField.becomeFirstResponder()
        }
    }
    
    override func setupLayout() {
         super.setupLayout()
        
        var constraints: [NSLayoutConstraint] = [
            addNamePage.al_top == view.al_top,
            addNamePage.al_bottom == view.al_bottom,
            addNamePage.al_left == view.al_left,
            addNamePage.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }
    
    override func didTapNavButton() {
        let Emailvc = SignUpEmailWalkthroughViewController()
        
        self.navigationController?.pushViewController(Emailvc, animated: true)
    }

}

class SignUpEmailWalkthroughViewController: WalkthroughViewController, UITableViewDelegate, UITextFieldDelegate  {
    var addEmailPage: SignUpEmailView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addEmailPage = SignUpEmailView()
        addEmailPage.setTranslatesAutoresizingMaskIntoConstraints(false)
        addEmailPage.emailTxtField.delegate = self
        
         setupNavBar("next")
        
        view.addSubview(addEmailPage)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        delay(0.05) {
            addEmailPage.emailTxtField.becomeFirstResponder()
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        var constraints: [NSLayoutConstraint] = [
            addEmailPage.al_top == view.al_top,
            addEmailPage.al_bottom == view.al_bottom,
            addEmailPage.al_left == view.al_left,
            addEmailPage.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }
    
    override func didTapNavButton() {
        let Passwordvc = SignUpPassWordWalkthroughViewController()
        
        self.navigationController?.pushViewController(Passwordvc, animated: true)
    }
}

class SignUpPassWordWalkthroughViewController: WalkthroughViewController, UITableViewDelegate, UITextFieldDelegate  {
    var addPasswordPage: SignUpPasswordView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPasswordPage = SignUpPasswordView()
        addPasswordPage.setTranslatesAutoresizingMaskIntoConstraints(false)
        addPasswordPage.passwordTxtFieldOne.delegate = self
        addPasswordPage.confirmPasswordTxtField.delegate = self
        
        setupNavBar("next")
        
        view.addSubview(addPasswordPage)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        delay(0.05) {
            addPasswordPage.passwordTxtFieldOne.becomeFirstResponder()
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        var constraints: [NSLayoutConstraint] = [
            addPasswordPage.al_top == view.al_top,
            addPasswordPage.al_bottom == view.al_bottom,
            addPasswordPage.al_left == view.al_left,
            addPasswordPage.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }
    
    override func didTapNavButton() {
        let selectArtisitvc = SelectArtisitWalkthroughViewController()
        
        self.navigationController?.pushViewController(selectArtisitvc, animated: true)
    }
}

class TermAndPrivacyWebView: UIViewController {
    var webView: WKWebView!
    
  override func viewDidLoad() {
    super.viewDidLoad()
        webView = WKWebView()
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let url = NSURL(string:"http://www.appcoda.com")
        let request = NSURLRequest(URL:url!)
        webView.loadRequest(request)
        
        view.addSubview(webView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
    }
    
     func setupLayout() {
        var constraints: [NSLayoutConstraint] = [
            webView.al_top == view.al_top,
            webView.al_bottom == view.al_bottom,
            webView.al_left == view.al_left,
            webView.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }

}

class SelectArtisitWalkthroughViewController: WalkthroughViewController,UITableViewDataSource, UITableViewDelegate, WalkthroughViewModelDelegate {
    var tableView: UITableView!
    let kCellIdentifier = "signUpAddArtistsTableViewCell"
    var selectedArt = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.viewModel.delegate = self
        
        self.tableView.registerClass(SignUpAddArtistsTableViewCell.classForCoder(), forCellReuseIdentifier: kCellIdentifier)
        
        setupNavBar("done")
        
        self.viewModel.getListOfArtists()
        
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func setupLayout() {
        var constraints: [NSLayoutConstraint] = [
            tableView.al_top == view.al_top,
            tableView.al_bottom == view.al_bottom,
            tableView.al_left == view.al_left,
            tableView.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.artistsList.count
    }
    
    
     func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "recommended".uppercaseString
        
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int  {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : SignUpAddArtistsTableViewCell = SignUpAddArtistsTableViewCell(style: .Default, reuseIdentifier: kCellIdentifier)
        cell.artistNameLabel!.text = viewModel.artistsList[indexPath.row].name
        let lyricCount = viewModel.artistsList[indexPath.row].lyricCount as NSNumber
        cell.lyricsCountLabel!.text = lyricCount.stringValue
        
        var image : UIImage = UIImage(named: "ArtistPicture")!
        cell.artistImageView.setImageWithURL(viewModel.artistsList[indexPath.row].imageURLLarge, placeholderImage: UIImage(named: "ArtistPicture")!)
        cell.selectionButton.addTarget(self, action: "didTapSelectButton:", forControlEvents: .TouchUpInside)
        cell.selectionButton.tag = 
        
        return cell
        
    }
    
    func didTapSelectButton(sender : UIButton) {
         sender.selected = !sender.selected
        
        if sender.selected {
        println("selected")
        } else  {
        println("not selected")
    
        }
    }
    
    func walkthroughViewModelDidLoadArtistsList(signUpWalkthroughViewModel: SignUpWalkthroughViewModel, keyboardList: [Artist]) {
        self.tableView.reloadData()
    }
    
    
}

