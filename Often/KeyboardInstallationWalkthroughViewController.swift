//
//  KeyboardInstallationWalkthroughViewController.swift
//  Often
//
//  Created by Kervins Valcourt on 9/28/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import Foundation

class KeyboardInstallationWalkthroughViewController: UIViewController, UIScrollViewDelegate {
    var scrollView: UIScrollView
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    var pageWidth: CGFloat
    var toolbar: UIView
    var pager: UIPageControl
    var settingsButton: UIButton
    var nextButton: UIButton
    var shadowBar: UIView
    var pagesScrollViewSize: CGSize
    var pageCount: Int
    var pageViews: [KeyboardWalkthroughView]
    var pageImages: [UIImage]
    var pageTitle: [String]
    var pagesubTitle: [String]
    var viewModel: SignupViewModel
    
    
    var currentPage: Int {
        return Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
    }
    
    init (viewModel: SignupViewModel) {
        self.viewModel = viewModel
        
        toolbar = UIView()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.backgroundColor = WhiteColor
        
        shadowBar = UIView()
        shadowBar.translatesAutoresizingMaskIntoConstraints = false
        shadowBar.backgroundColor = BlackColor
        shadowBar.alpha = 0.20

        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.pagingEnabled = true
        scrollView.backgroundColor = WhiteColor
        scrollView.showsHorizontalScrollIndicator = false
        
        pageWidth = screenWidth
        
        pagesScrollViewSize = scrollView.frame.size
        
        pageCount = 0
        
        pageViews = [KeyboardWalkthroughView]()
        
        pageImages = [
            UIImage(named: "keyboardWalkthroughStep_1")!,
            UIImage(named: "keyboardWalkthroughStep_2")!,
            UIImage(named: "keyboardWalkthroughStep_3")!,
            UIImage(named: "keyboardWalkthroughStep_4")!,
            UIImage(named: "keyboardWalkthroughStep_5")!
        ]
        
        pageTitle = [
            "Let’s install this ishh",
            "Add New Keyboard",
            "Choose Often",
            "Allow Full-Access",
            "Use Often"
        ]
        
        pagesubTitle = [
            "Start by opening Settings on your iPhone and \r\n tapping on \"General\". Scroll down and tap \r\n on \"Keyboard\".",
            "Next, tap \"Keyboards\". Here you'll see all \r\n your currently installed keyboards. Tap \r\n \"Add New Keyboard\".",
            "Here we'll choose \"Often\" under Third- \r\n Party Keyboards. After you've added it, \r\n tap on Often.",
            "Full access let’s us use the internet inside \r\n the keyboard to show you search results. \r\n We never save or read any info! See FAQ in \r\n settings for more details or email us directly.",
            "Open up any app that uses a keyboard, tap \r\n and hold the \"Globe\" icon and select Often. \r\n See this tutorial again anytime in settings."
        ]
        
        pager = UIPageControl()
        pager.translatesAutoresizingMaskIntoConstraints = false
        pager.pageIndicatorTintColor = KeyboardInstallationWalkthroughViewControllerPageIndicatorTintColor
        pager.currentPageIndicatorTintColor = TealColor
        
        settingsButton = UIButton()
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.setTitle("go to settings".uppercaseString, forState: UIControlState.Normal)
        settingsButton.titleLabel?.font = UIFont(name: "Montserrat", size: 11)
        settingsButton.alpha = 0.74
        settingsButton.setTitleColor(BlackColor, forState: UIControlState.Normal)
        settingsButton.hidden = true
        
        nextButton = UIButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("next".uppercaseString, forState: UIControlState.Normal)
        nextButton.alpha = 0.74
        nextButton.titleLabel?.font = UIFont(name: "Montserrat", size: 11)
        nextButton.setTitleColor(BlackColor, forState: UIControlState.Normal)
        
        super.init(nibName: nil, bundle: nil)
        
        scrollView.delegate = self
        
        view.backgroundColor = KeyboardInstallationWalkthroughViewControllerBackgroundColor
        
        settingsButton.addTarget(self, action: "didTapSettingsButton", forControlEvents: .TouchUpInside)
        nextButton.addTarget(self, action: "didTapNextButton", forControlEvents: .TouchUpInside)
    
        view.addSubview(scrollView)
        view.addSubview(toolbar)
        view.addSubview(shadowBar)
        
        toolbar.addSubview(pager)
        toolbar.addSubview(settingsButton)
        toolbar.addSubview(nextButton)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayInstallationKeyboardWalkthrough", name: "didBecomeActive", object: nil)
        setupLayout()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPages()
        loadVisiblePages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func loadVisiblePages() {
        for index in 0...pageCount - 1 {
            loadPage(index)
        }
    }
    
    func loadPage(page: Int) {
        let keyboardWalkthroughView = KeyboardWalkthroughView()
        let subtitleString = pagesubTitle[page]
        let subtitleRange = NSMakeRange(0, subtitleString.characters.count)
        let subtitle = NSMutableAttributedString(string: subtitleString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        
        subtitle.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:subtitleRange)
        subtitle.addAttribute(NSFontAttributeName, value: UIFont(name: "OpenSans", size: 13)!, range: subtitleRange)
        subtitle.addAttribute(NSKernAttributeName, value: 0.5, range: subtitleRange)
        
        keyboardWalkthroughView.translatesAutoresizingMaskIntoConstraints = false
        keyboardWalkthroughView.iphoneImageView.image = pageImages[page]
        keyboardWalkthroughView.titleLabel.text = pageTitle[page]
        keyboardWalkthroughView.subtitleLabel.attributedText = subtitle
        keyboardWalkthroughView.subtitleLabel.textAlignment = .Center
        keyboardWalkthroughView.currentPage = page
        keyboardWalkthroughView.setupLayout()
        
        scrollView.addSubview(keyboardWalkthroughView)
        
        scrollView.addConstraints([
            keyboardWalkthroughView.al_top == scrollView.al_top,
            keyboardWalkthroughView.al_height == scrollView.al_height,
            keyboardWalkthroughView.al_width == scrollView.al_width,
            keyboardWalkthroughView.al_left == scrollView.al_left + pageWidth * CGFloat(page)
            ])
        
        pageViews.append(keyboardWalkthroughView)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        /// Load the pages that are now on screen
        pager.currentPage = currentPage
        settingsButton.hidden = true
        nextButton.hidden = false
        
        SEGAnalytics.sharedAnalytics().track("app:installKeyboardSwipeToPage", properties: [
            "page": currentPage
            ])
        
        if currentPage == 4 {
            settingsButton.hidden = false
            nextButton.hidden = true
        }
    }
    
    func displayInstallationKeyboardWalkthrough() {
        let shouldShowInstallationKeyboardWalkthrough = viewModel.sessionManager.userDefaults.boolForKey("keyboardInstall")

            if shouldShowInstallationKeyboardWalkthrough {
                self.createProfileViewController()
            } 
    }
    
    func createProfileViewController() {
        
        if (SlideNavigationController.sharedInstance() == nil) {
            let userProfileViewModel = UserProfileViewModel(sessionManager: self.viewModel.sessionManager)
            let socialAccountViewModel = SocialAccountSettingsViewModel(sessionManager: self.viewModel.sessionManager, venmoAccountManager: self.viewModel.venmoAccountManager, spotifyAccountManager: self.viewModel.spotifyAccountManager, soundcloudAccountManager: self.viewModel.soundcloudAccountManager)
            
            let frontViewController = UserProfileViewController(collectionViewLayout: UserProfileViewController.provideCollectionViewLayout(), viewModel: userProfileViewModel)
            let mainViewController = SlideNavigationController(rootViewController: frontViewController)
            mainViewController.navigationBar.hidden = true
            mainViewController.enableShadow = false   
            mainViewController.panGestureSideOffset = CGFloat(30)
            // left view controller: Set Services for keyboard
            // right view controller: App Settings
            
            SlideNavigationController.sharedInstance().leftMenu =  SocialAccountSettingsCollectionViewController(collectionViewLayout: SocialAccountSettingsCollectionViewController.provideCollectionViewLayout(), viewModel: socialAccountViewModel)
            SlideNavigationController.sharedInstance().rightMenu = AppSettingsViewController()
            presentViewController(mainViewController, animated: true, completion: nil )
            
        }
    }

    
    func didTapNextButton() {
        let pageWidth = CGRectGetWidth(self.scrollView.frame)
        let maxWidth = pageWidth * CGFloat(pageCount)
        let contentOffset = self.scrollView.contentOffset.x
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth {
            slideToX = 0
        }
        
        self.scrollView.setContentOffset(CGPoint(x: slideToX, y: 0), animated: true)
    }
    
    func didTapSettingsButton() {
        if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString)
        {
            UIApplication.sharedApplication().openURL(appSettings)
        }
    }
    
    func setupPages() {
        pageCount = pageImages.count
        pager.numberOfPages = pageCount
        
        scrollView.contentSize = CGSize(width: pageWidth  * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
    }
    
    func setupLayout() {
        view.addConstraints([
            toolbar.al_width == screenWidth,
            toolbar.al_height == 55,
            toolbar.al_bottom == view.al_bottom,
            
            shadowBar.al_width == screenWidth,
            shadowBar.al_height == 1,
            shadowBar.al_bottom == toolbar.al_top,
            
            pager.al_left == toolbar.al_left + 20,
            pager.al_centerY == toolbar.al_centerY,
            
            scrollView.al_top == view.al_top,
            scrollView.al_bottom == settingsButton.al_top + 10,
            scrollView.al_left == view.al_left ,
            scrollView.al_right == view.al_right,
            
            settingsButton.al_width == 120,
            settingsButton.al_right == toolbar.al_right - 10,
            settingsButton.al_top == toolbar.al_top + 10,
            settingsButton.al_bottom == toolbar.al_bottom - 10,
            
            nextButton.al_width == 60,
            nextButton.al_right == toolbar.al_right - 10,
            nextButton.al_top == toolbar.al_top + 10,
            nextButton.al_bottom == toolbar.al_bottom - 10
            ])
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
