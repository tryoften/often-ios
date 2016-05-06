//
//  LogInViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 9/8/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class LoginViewController: UserCreationViewController, UIScrollViewDelegate {
    var loginView: LoginView
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    var pageWidth: CGFloat
    var pagesScrollViewSize: CGSize
    var pageCount: Int
    var pageViews: [UIImageView]
    var pageImages: [UIImage]
    var pageTitle: [String]
    var pagesubTitle: [String]
    var scrollTimer: NSTimer?
    var launchScreenLoaderTimer: NSTimer?
    
    var currentPage: Int {
        return Int(floor((loginView.scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
    }

    
    override init (viewModel: LoginViewModel) {
        loginView = LoginView()
        loginView.translatesAutoresizingMaskIntoConstraints = false
        
        pageWidth = screenWidth - 40
        
        pagesScrollViewSize = loginView.scrollView.frame.size
        
        pageCount = 0
        
        pageViews = [UIImageView]()
        
        pageImages = [
            UIImage(named: "onboarding1")!,
            UIImage(named: "onboarding2")!,
            UIImage(named: "onboarding3")!
        ]
        
        pageTitle = [
            "Share lyrics, quotes & GIFS",
            "Share Everywhere",
            "Feels to Hate"
        ]
        
        pagesubTitle = [
            "Pick packs from TV Shows, Artists, \n Movies, Tweets, Sports & More",
            "Easily switch packs and share your\n favorite things in any app",
            "Sort by categories and find the\n perfect response every time"
        ]
        
        super.init(viewModel: viewModel)

        loginView.scrollView.delegate = self
        
        view.addSubview(loginView)
        setupLayout()
        
        scrollTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "scrollToNextPage", userInfo: nil, repeats: true)
        launchScreenLoaderTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "userDataTimeOut", userInfo: nil, repeats: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        PKHUD.sharedHUD.hide(animated: true)

        viewModel.delegate = self

        loginView.createAccountButton.addTarget(self,  action: "didTapCreateAccountButton:", forControlEvents: .TouchUpInside)
        loginView.signinButton.addTarget(self, action: "didTapSigninButton:", forControlEvents: .TouchUpInside)
        loginView.skipButton.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
        setupPages()
        loadVisiblePages()

        if viewModel.sessionManager.sessionManagerFlags.isUserLoggedIn {
            loginView.launchScreenLoader.hidden = false
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func scrollToNextPage() {
        let xOffset = pageWidth * CGFloat((currentPage + 1) % pageCount)
        loginView.scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }
    
    func loadVisiblePages() {
        for index in 0...pageCount - 1 {
            loadPage(index)
        }
    }
    
    func loadPage(page: Int) {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = pageImages[page]
        imageView.contentMode = .ScaleAspectFit
        
        if Diagnostics.platformString().number == 5 || Diagnostics.platformString().desciption == "iPhone SE" {
            imageView.contentMode = .ScaleAspectFit
        }

        
        loginView.scrollView.addSubview(imageView)
        
        loginView.scrollView.addConstraints([
            imageView.al_top == loginView.scrollView.al_top,
            imageView.al_height == loginView.scrollView.al_height - 49.6,
            imageView.al_width == pageWidth,
            imageView.al_left == loginView.scrollView.al_left + pageWidth * CGFloat(page)
        ])
        
        pageViews.append(imageView)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let titleString = pageTitle[currentPage]
        let titleRange = NSMakeRange(0, titleString.characters.count)
        let title = NSMutableAttributedString(string: titleString)
        
        title.addAttribute(NSFontAttributeName, value: UIFont(name: "Montserrat", size: 15)!, range: titleRange)
        title.addAttribute(NSKernAttributeName, value: 1, range: titleRange)
        
        let subtitleString = pagesubTitle[currentPage]
        let subtitleRange = NSMakeRange(0, subtitleString.characters.count)
        let subtitle = NSMutableAttributedString(string: subtitleString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        
        subtitle.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:subtitleRange)
        subtitle.addAttribute(NSFontAttributeName, value: UIFont(name: "OpenSans", size: 13)!, range: subtitleRange)
        subtitle.addAttribute(NSKernAttributeName, value: 0.5, range: subtitleRange)
        
        loginView.pageControl.currentPage = currentPage
        loginView.titleLabel.text = titleString
        loginView.titleLabel.attributedText = title
        loginView.titleLabel.textAlignment = .Center
        loginView.subtitleLabel.text = subtitleString
        loginView.subtitleLabel.attributedText = subtitle
        loginView.subtitleLabel.textAlignment = .Center
        
        scrollTimer?.invalidate()
        scrollTimer = NSTimer.scheduledTimerWithTimeInterval(5.5, target: self, selector: "scrollToNextPage", userInfo: nil, repeats: true)
    }
    

    func setupPages() {
        pageCount = pageImages.count
        loginView.pageControl.numberOfPages = pageCount
        
        loginView.scrollView.contentSize = CGSize(width: pageWidth  * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
    }
    
    func didTapCreateAccountButton(sender: UIButton) {
        scrollTimer?.invalidate()

        let createAccount = CreateAccountViewController(viewModel: LoginViewModel(sessionManager: SessionManager.defaultManager))
        presentViewController(createAccount, animated: true, completion: nil)
    }
    
    func didTapSigninButton(sender: UIButton) {
        scrollTimer?.invalidate()

        let signinAccount = SigninViewController(viewModel: LoginViewModel(sessionManager: SessionManager.defaultManager))
        presentViewController(signinAccount, animated: true, completion: nil)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            loginView.al_bottom == view.al_bottom,
            loginView.al_top == view.al_top,
            loginView.al_left == view.al_left,
            loginView.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }

    func userDataTimeOut() {
        launchScreenLoaderTimer?.invalidate()
        loginView.launchScreenLoader.hidden = true
    }

    override func loginViewModelNoUserFound(userProfileViewModel: LoginViewModel) {
        launchScreenLoaderTimer?.invalidate()
        loginView.launchScreenLoader.hidden = true
    }

    override func loginViewModelDidLoginUser(userProfileViewModel: LoginViewModel, user: User?) {
        super.loginViewModelDidLoginUser(userProfileViewModel, user: user)

        scrollTimer?.invalidate()
        launchScreenLoaderTimer?.invalidate()

        var mainController: UIViewController

        if viewModel.sessionManager.sessionManagerFlags.userIsAnonymous && viewModel.isNewUser {
            mainController = InstallationWalkthroughViewContoller(viewModel: LoginViewModel(sessionManager: SessionManager.defaultManager))

        } else {
            mainController = RootViewController()
        }

        presentViewController(mainController, animated: true, completion: nil)
    }
}