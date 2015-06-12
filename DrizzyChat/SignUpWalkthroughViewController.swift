//
//  SignUpWalkthroughViewController.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 5/25/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation
import WebKit

class WalkthroughViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {
    var viewModel: SignUpWalkthroughViewModel!
    var artistService: ArtistService!
    let firebaseRoot = Firebase(url: BaseURL)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        artistService = ArtistService(root: firebaseRoot)
    }

    override func viewWillAppear(animated: Bool) {
        setupLayout()
    }
    
    func setupNavBar (titlePushViewButton: String) {
        let navButton = UIBarButtonItem(title: titlePushViewButton.uppercaseString, style: .Plain, target: self, action: "didTapNavButton")
        let fixedSpaceItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        let backButton = UIButton(frame: CGRectMake(0, 0, 20, 16))
        let backImage = UIImage(named: "BackButton")
        let backButtonItem = UIBarButtonItem(customView: backButton)
        let textAttributes = [NSFontAttributeName:ButtonFont!,NSForegroundColorAttributeName: UIColor.whiteColor()]
        let textAttributeForButtons = [NSFontAttributeName:ButtonFont!,NSForegroundColorAttributeName: UIColor(fromHexString: "#FFFFFF")]
        
        fixedSpaceItem.width = 10
        
        backButton.setBackgroundImage(backImage, forState: .Normal)
        backButton.imageView?.contentMode = .ScaleAspectFit
        backButton.addTarget(self, action: "popBack", forControlEvents: .TouchUpInside)
        
        navButton.setTitleTextAttributes(textAttributeForButtons, forState: .Normal)
        
        navigationItem.rightBarButtonItems = [fixedSpaceItem,navButton]
        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.title = "sign up".uppercaseString
        navigationItem.rightBarButtonItem?.tintColor = BlackColor
        
        navigationController?.navigationBar.sizeThatFits(CGSizeMake(UIScreen.mainScreen().bounds.size.width, 54))
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = BlackColor
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:ButtonFont!,NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    func didTapNavButton() {}
    func setupLayout() {}
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    func popBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        didTapNavButton()
        
        return true
    }
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
    
        navigationController?.navigationBar.hidden = true
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
        
        navigationController?.pushViewController(phoneNumbervc, animated: true)
    }
    
    func didTapLoginButton () {
        return
    }
}

class PhoneNumberWalkthroughViewController: WalkthroughViewController {
    var addPhoneNumberPage: SignUpPhoneNumberView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SignUpWalkthroughViewModel(artistService: artistService)
        
        addPhoneNumberPage = SignUpPhoneNumberView()
        addPhoneNumberPage.setTranslatesAutoresizingMaskIntoConstraints(false)
        addPhoneNumberPage.phoneNumberTxtField.delegate = self
        addPhoneNumberPage.phoneNumberTxtField.keyboardType = .PhonePad
        
        setupNavBar("skip")
        
        view.addSubview(addPhoneNumberPage)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.hidden = false
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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        checkCharacterCountOfTextField()
    
        if textField == addPhoneNumberPage.phoneNumberTxtField {
            var newString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            var components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            var decimalString = "".join(components) as NSString
            var length = decimalString.length
            var hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                var newLength = (textField.text as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            
            var index = 0 as Int
            var formattedString = NSMutableString()
            
            if hasLeadingOne {
                formattedString.appendString("1 ")
                index += 1
            }
            
            if (length - index) > 3 {
                var areaCode = decimalString.substringWithRange(NSMakeRange(index, 3))
                
                formattedString.appendFormat("%@-", areaCode)
                index += 3
            }
            
            if length - index > 3 {
                var prefix = decimalString.substringWithRange(NSMakeRange(index, 3))
                
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            var remainder = decimalString.substringFromIndex(index)
            
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            
            return false
        }
            
        else {
            return true
        }
    }
    
    func checkCharacterCountOfTextField() {
        if (count(addPhoneNumberPage.phoneNumberTxtField.text) >= 2) {
            navigationItem.rightBarButtonItem?.title = "next".uppercaseString
        } else {
            navigationItem.rightBarButtonItem?.title = "skip".uppercaseString
        }
    }
    
    override func didTapNavButton() {
        if count(addPhoneNumberPage.phoneNumberTxtField.text) != 0 {
            
            if PhoneIsValid(addPhoneNumberPage.phoneNumberTxtField.text) {
                viewModel.phoneNumber = addPhoneNumberPage.phoneNumberTxtField.text
            }
            else {
                println("redo you phonenumber")
                return
            }
        }
        
        let Namevc = SignUpNameWalkthroughViewController()
        Namevc.viewModel = viewModel
        
        navigationController?.pushViewController(Namevc, animated: true)
    }
}

class SignUpNameWalkthroughViewController: WalkthroughViewController  {
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
        
        navigationController?.navigationBar.hidden = false
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
        if NameIsValid(addNamePage.fullNameTxtField.text) {
            viewModel.fullName = addNamePage.fullNameTxtField.text
        }
        else {
            println("enter name")
            return
        }

        let Emailvc = SignUpEmailWalkthroughViewController()
        Emailvc.viewModel = viewModel
        
        navigationController?.pushViewController(Emailvc, animated: true)
    }
    
}

class SignUpEmailWalkthroughViewController: WalkthroughViewController  {
    var addEmailPage: SignUpEmailView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addEmailPage = SignUpEmailView()
        addEmailPage.setTranslatesAutoresizingMaskIntoConstraints(false)
        addEmailPage.emailTxtField.delegate = self
        addEmailPage.emailTxtField.keyboardType = .EmailAddress
        
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
        if EmailIsValid(addEmailPage.emailTxtField.text) {
            viewModel.email = addEmailPage.emailTxtField.text
        }
        else {
            println("enter email")
            return
        }
        
        let Passwordvc = SignUpPassWordWalkthroughViewController()
        Passwordvc.viewModel = viewModel
        
        navigationController?.pushViewController(Passwordvc, animated: true)
    }
}

class SignUpPassWordWalkthroughViewController: WalkthroughViewController  {
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
        
        navigationController?.navigationBar.hidden = false
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
        if PasswordIsValid(addPasswordPage.passwordTxtFieldOne.text) {
            if arePasswordMatchingValid(addPasswordPage.passwordTxtFieldOne.text, addPasswordPage.confirmPasswordTxtField.text) {
                viewModel.password = addPasswordPage.passwordTxtFieldOne.text
            } else {
                println("passwords dont match")
                return
            }
            
        } else {
            println("need more chars")
            return
        }
        let selectArtistvc = SelectArtistWalkthroughViewController()
        selectArtistvc.viewModel = viewModel
        
        navigationController?.pushViewController(selectArtistvc, animated: true)
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

class SelectArtistWalkthroughViewController: WalkthroughViewController,UITableViewDataSource, UITableViewDelegate, WalkthroughViewModelDelegate {
    var tableView: UITableView!
    let kCellIdentifier = "signUpAddArtistsTableViewCell"
    var selectedArtistes = [NSNumber]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        viewModel.delegate = self
        viewModel.getListOfArtists()
        
        tableView.registerClass(SignUpAddArtistsTableViewCell.classForCoder(), forCellReuseIdentifier: kCellIdentifier)
        
        setupNavBar("done")
        
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        title = "add artists".uppercaseString
        
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

    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int  {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //TODO: make a view for this
        var recommendedLabel = UILabel()
        let titleString = "recommended".uppercaseString
        let titleRange = NSMakeRange(0, count(titleString))
        let title = NSMutableAttributedString(string: titleString)
        let headerView = UIView()
        var spacer = UIView()
        
        recommendedLabel.frame = CGRectMake(20, 8, tableView.frame.size.width, 20)
        recommendedLabel.font = UIFont(name: "OpenSans", size: 9)
        
        title.addAttribute(NSFontAttributeName, value: recommendedLabel.font!, range: titleRange)
        title.addAttribute(NSKernAttributeName, value: 1.0, range: titleRange)
        
        recommendedLabel.attributedText = title
        
        spacer.frame = CGRectMake(0, 34, tableView.frame.size.width, 1)
        spacer.backgroundColor = UIColor(fromHexString: "#E4E4E4")
        
        headerView.backgroundColor = UIColor.whiteColor()
        headerView.addSubview(recommendedLabel)
        headerView.addSubview(spacer)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : SignUpAddArtistsTableViewCell = SignUpAddArtistsTableViewCell(style: .Default, reuseIdentifier: kCellIdentifier)
       
        let lyricCount = viewModel.artistsList[indexPath.row].lyricCount as NSNumber
        
        for objects in selectedArtistes {
            if objects.integerValue == indexPath.row {
                cell.selectionButton.selected = true
            }
        }
        
        cell.lyricsCountLabel!.text = lyricCount.stringValue
        cell.artistNameLabel!.text = viewModel.artistsList[indexPath.row].name
        cell.artistImageView.setImageWithURL(viewModel.artistsList[indexPath.row].imageURLLarge, placeholderImage: UIImage(named: "ArtistPicture")!)
        cell.selectionButton.addTarget(self, action: "didTapSelectButton:", forControlEvents: .TouchUpInside)
        cell.selectionButton.tag = indexPath.row

        return cell
    }
    
    func didTapSelectButton(sender : UIButton) {
        let buttonTag = NSNumber(integer: sender.tag)
        
        sender.selected = !sender.selected
        
        if sender.selected {
            selectedArtistes.append(buttonTag)
        } else  {
            for objects in selectedArtistes {
                if objects == buttonTag {
                    if let foundIndex = find(selectedArtistes, objects) {
                        selectedArtistes.removeAtIndex(foundIndex)
                    }
                }
            }
        }
    }
    
    override func didTapNavButton() {
        for objects in selectedArtistes {
            viewModel.artistSelectedList?.append(viewModel.artistsList[objects.integerValue].id)
        }
        println(viewModel.artistSelectedList!)
        if ArtistsSelectedListIsValid(viewModel.artistSelectedList!) {
            println("go to make screen")
        } else {
            println("need to pick at lest one")
            return
        }
        
    }
    
    func walkthroughViewModelDidLoadArtistsList(signUpWalkthroughViewModel: SignUpWalkthroughViewModel, keyboardList: [Artist]) {
        tableView.reloadData()
    }
    
}

