//
//  LogInViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 9/8/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class LoginViewController: UIViewController, UIScrollViewDelegate,
    LoginViewModelDelegate {
    var viewModel: LoginViewModel
    var loginView: LoginView
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    var pageWidth: CGFloat
    var pagesScrollViewSize: CGSize
    var pageCount: Int
    var pageViews: [UIImageView]
    var pageImages: [UIImage]
    var pagesubTitle: [String]
    var timer: NSTimer?
    var launchScreenLoaderTimer: NSTimer?
    
    var currentPage: Int {
        return Int(floor((loginView.scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
    }

    
    init (viewModel: LoginViewModel) {
        self.viewModel = viewModel
        
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
        
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        loginView.scrollView.delegate = self
        
        view.addSubview(loginView)
        setupLayout()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "scrollToNextPage", userInfo: nil, repeats: true)
        launchScreenLoaderTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "userDataTimeOut", userInfo: nil, repeats: true)
    }

    func scrollToNextPage() {
        let xOffset = pageWidth * CGFloat((currentPage + 1) % pageCount)
        loginView.scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView.createAccountButton.addTarget(self,  action: "didTapcreateAccountButton:", forControlEvents: .TouchUpInside)
        loginView.signinButton.addTarget(self, action: "didTapSigninButton:", forControlEvents: .TouchUpInside)
        loginView.skipButton.addTarget(self, action: "didTapSkipButton:", forControlEvents: .TouchUpInside)
        setupPages()
        loadVisiblePages()
        
        if viewModel.sessionManager.sessionManagerFlags.isUserLoggedIn {
            loginView.launchScreenLoader.hidden = false
        } 
    }
    
    override func viewDidDisappear(animated: Bool) {
        viewModel.delegate = nil
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
        
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(4.75, target: self, selector: "scrollToNextPage", userInfo: nil, repeats: true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func setupPages() {
        pageCount = pageImages.count
        loginView.pageControl.numberOfPages = pageCount
        
        loginView.scrollView.contentSize = CGSize(width: pageWidth  * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
    }
    
    func didTapcreateAccountButton(sender: UIButton) {
        timer?.invalidate()
        let createAccount = CreateAccountViewController(viewModel:self.viewModel)
        presentViewController(createAccount, animated: true, completion: nil)
    }
    
    func didTapSigninButton(sender: UIButton) {
        timer?.invalidate()
        let signinAccount = SigninViewController(viewModel:self.viewModel)
        presentViewController(signinAccount, animated: true, completion: nil)
    }
    
    func didTapSkipButton(sender: UIButton) {
        do {
            try  viewModel.sessionManager.login(.Anonymous, userData: nil, completion: { results -> Void in
                switch results {
                case .Success(_):
                    let keyboardInstallationWalkthrough = KeyboardInstallationWalkthroughViewController(viewModel: self.viewModel)
                    self.presentViewController(keyboardInstallationWalkthrough, animated: true, completion: nil)
                    break
                case .Error(let err): print(err)
                case .SystemError(let err): DropDownErrorMessage().setMessage(err.localizedDescription, errorBackgroundColor: UIColor(fromHexString: "#152036"))
                }
            })
        } catch {

        }
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
    
    func loginViewModelDidLoginUser(userProfileViewModel: LoginViewModel, user: User?, isNewUser: Bool) {
        launchScreenLoaderTimer?.invalidate()
        var mainController: UIViewController
        
            if viewModel.sessionManager.sessionManagerFlags.userIsAnonymous {
                mainController = SkipSignupViewController(viewModel: LoginViewModel(sessionManager: viewModel.sessionManager))
            } else {
                let mainViewController = RootViewController()
                mainController = mainViewController
            }
            
        self.presentViewController(mainController, animated: true, completion: nil)
    }
    
    func userDataTimeOut() {
        launchScreenLoaderTimer?.invalidate()
        loginView.launchScreenLoader.hidden = true
        viewModel.delegate = nil
    }
    
    func loginViewModelNoUserFound(userProfileViewModel: LoginViewModel) {
        launchScreenLoaderTimer?.invalidate()
        loginView.launchScreenLoader.hidden = true
    }
}