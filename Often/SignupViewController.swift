//
//  SignupViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 9/8/15.
//  Copyright (c) 2015 Surf Inc. All rights reserved.
//

import Foundation

class SignupViewController: UIViewController, UIScrollViewDelegate,
    SignupViewModelDelegate {
    var viewModel: SignupViewModel
    var signupView: SignupView
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    var pageWidth: CGFloat
    var pagesScrollViewSize: CGSize
    var pageCount: Int
    var pageViews: [UIImageView]
    var pageImages: [UIImage]
    var pagesubTitle: [String]
    var timer: NSTimer?
    var splashScreenTimer: NSTimer?
    
    var currentPage: Int {
        return Int(floor((signupView.scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
    }

    
    init (viewModel: SignupViewModel) {
        self.viewModel = viewModel
        
        signupView = SignupView()
        signupView.translatesAutoresizingMaskIntoConstraints = false
        
        pageWidth = screenWidth - 40
        
        pagesScrollViewSize = signupView.scrollView.frame.size
        
        pageCount = 0
        
        pageViews = [UIImageView]()
        
        pageImages = [
            UIImage(named: "productWalkthroughStep_1")!,
            UIImage(named: "productWalkthroughStep_2")!,
            UIImage(named: "productWalkthroughStep_3")!,
            UIImage(named: "productWalkthroughStep_4")!,
            UIImage(named: "productWalkthroughStep_5")!,
        ]
        
        pagesubTitle = [
            "Share the latest videos, songs, & news wherever you are, right from your keyboard",
            "See what's trending before you even search. Always keep convos up to date",
            "The first Hip Hop & Pop Culture powered search experience. No Bullsh*t",
            "Filter by app or website by adding a hashtag to the beginning of your search",
            "Favorites are saved right in your keyboard to easily share them again later"
        ]
        
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        signupView.scrollView.delegate = self
        
        view.addSubview(signupView)
        setupLayout()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.75, target: self, selector: "scrollToNextPage", userInfo: nil, repeats: true)
        splashScreenTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "userDataTimeOut", userInfo: nil, repeats: true)
    }

    func scrollToNextPage() {
        let xOffset = pageWidth * CGFloat((currentPage + 1) % pageCount)
        signupView.scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupView.createAccountButton.addTarget(self,  action: "didTapcreateAccountButton:", forControlEvents: .TouchUpInside)
        signupView.signinButton.addTarget(self, action: "didTapSigninButton:", forControlEvents: .TouchUpInside)
        signupView.skipButton.addTarget(self, action: "didTapSkipButton:", forControlEvents: .TouchUpInside)
        setupPages()
        loadVisiblePages()
        
        if viewModel.sessionManager.sessionManagerFlags.isUserLoggedIn {
            signupView.splashScreen.hidden = false
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
        
        signupView.scrollView.addSubview(imageView)
        
        signupView.scrollView.addConstraints([
            imageView.al_top == signupView.scrollView.al_top,
            imageView.al_height == signupView.scrollView.al_height,
            imageView.al_width == pageWidth,
            imageView.al_left == signupView.scrollView.al_left + pageWidth * CGFloat(page)
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
        
        signupView.pageControl.currentPage = currentPage
        signupView.subtitleLabel.text = subtitleString
        signupView.subtitleLabel.attributedText = subtitle
        signupView.subtitleLabel.textAlignment = .Center
        
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(3.75, target: self, selector: "scrollToNextPage", userInfo: nil, repeats: true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func setupPages() {
        pageCount = pageImages.count
        signupView.pageControl.numberOfPages = pageCount
        
        signupView.scrollView.contentSize = CGSize(width: pageWidth  * CGFloat(pageImages.count),
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
            signupView.al_bottom == view.al_bottom,
            signupView.al_top == view.al_top,
            signupView.al_left == view.al_left,
            signupView.al_right == view.al_right,
        ]
        
        view.addConstraints(constraints)
    }
    
    func signupViewModelDidLoginUser(userProfileViewModel: SignupViewModel, user: User?, isNewUser: Bool) {
        splashScreenTimer?.invalidate()
        var mainController: UIViewController
        
            if viewModel.sessionManager.sessionManagerFlags.userIsAnonymous {
                mainController = SkipSignupViewController(viewModel: SignupViewModel(sessionManager: viewModel.sessionManager))
            } else {
                let mainViewController = RootViewController()
                mainController = mainViewController
            }
            
        self.presentViewController(mainController, animated: true, completion: nil)
    }
    
    func userDataTimeOut() {
        splashScreenTimer?.invalidate()
        signupView.splashScreen.hidden = true
        viewModel.delegate = nil
    }
    
    func signupViewModelNoUserFound(userProfileViewModel: SignupViewModel) {
        splashScreenTimer?.invalidate()
        signupView.splashScreen.hidden = true
    }
}