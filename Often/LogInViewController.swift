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
            UIImage(named: "productWalkthroughStep_1")!,
            UIImage(named: "productWalkthroughStep_2")!,
            UIImage(named: "productWalkthroughStep_3")!,
            UIImage(named: "productWalkthroughStep_4")!,
        ]
        
        pagesubTitle = [
            "Search, collect & share lyrics, \n in any app, right from your keyboard",
            "Save all the best lyrics to your Favorites & easily share them again later",
            "Discover the hottest lyrics, songs & artists right inside your keyboard",
            "Powered by Genius, search helps you \n find any lyric, song or artist"
        ]
        
        super.init(viewModel: viewModel)

        loginView.scrollView.delegate = self
        
        view.addSubview(loginView)
        setupLayout()
        
        scrollTimer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "scrollToNextPage", userInfo: nil, repeats: true)
        launchScreenLoaderTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "userDataTimeOut", userInfo: nil, repeats: true)
    }

    func scrollToNextPage() {
        let xOffset = pageWidth * CGFloat((currentPage + 1) % pageCount)
        loginView.scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
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
    
    func loadVisiblePages() {
        for index in 0...pageCount - 1 {
            loadPage(index)
        }
    }
    
    func loadPage(page: Int) {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = pageImages[page]
        imageView.contentMode = .Center
        
        loginView.scrollView.addSubview(imageView)
        
        loginView.scrollView.addConstraints([
            imageView.al_top == loginView.scrollView.al_top,
            imageView.al_height == loginView.scrollView.al_height,
            imageView.al_width == pageWidth,
            imageView.al_left == loginView.scrollView.al_left + pageWidth * CGFloat(page)
        ])
        
        pageViews.append(imageView)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let subtitleString = pagesubTitle[currentPage]
        let subtitleRange = NSMakeRange(0, subtitleString.characters.count)
        let subtitle = NSMutableAttributedString(string: subtitleString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        
        subtitle.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:subtitleRange)
        subtitle.addAttribute(NSFontAttributeName, value: UIFont(name: "OpenSans", size: 13)!, range: subtitleRange)
        subtitle.addAttribute(NSKernAttributeName, value: 0.5, range: subtitleRange)
        
        loginView.pageControl.currentPage = currentPage
        loginView.subtitleLabel.text = subtitleString
        loginView.subtitleLabel.attributedText = subtitle
        loginView.subtitleLabel.textAlignment = .Center
        
        scrollTimer?.invalidate()
        scrollTimer = NSTimer.scheduledTimerWithTimeInterval(4.75, target: self, selector: "scrollToNextPage", userInfo: nil, repeats: true)
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