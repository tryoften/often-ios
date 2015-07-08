//
//  KeyboardInstallationWalkthrough.swift
//  Drizzy
//
//  Created by Kervins Valcourt on 7/1/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import Foundation

class KeyboardInstallationWalkthroughViewController: UIViewController, UIScrollViewDelegate {
    var scrollView: UIScrollView
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    var pageWidth: CGFloat
    var toolbar: UIView
    var pager: UIPageControl
    var gotItButton: UIButton
    var pagesScrollViewSize: CGSize
    var pageCount: Int
    var pageViews: [KeyboardWalkthroughView]
    var pageImages: [UIImage]
    var pageTitle: [String]
    var pagesubTitle: [String]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        toolbar = UIView()
        toolbar.setTranslatesAutoresizingMaskIntoConstraints(false)
        toolbar.backgroundColor = UIColor.blackColor()
        
        scrollView = UIScrollView()
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView.pagingEnabled = true
        scrollView.layer.cornerRadius = 3.0
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.showsHorizontalScrollIndicator = false
        
        pageWidth = screenWidth - 40
        
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
            "Lastly, Install October",
            "Add New Keyboard",
            "Choose October",
            "Allow Full-Access (Optional)",
            "Start Sharing!"
        ]
        
        pagesubTitle = [
            "Start by opening Settings on your iPhone and tapping on \"General\". From here, you'll tap \"Keyboard\".",
            "Next, tap \"Keyboards\". You'll see all your currently installed keyboards. Tap \"Add New Keyboard\".",
            "Here we'll choose \"October\" under Third-Party Keyboards. After you've added it, tap on October.",
            "Full access allows us to automatically update lyrics & songs in your keyboard. We never save or read any info! See FAQ in settings for more details.",
            "Open up you favorite app, tap and hold the \"Globe\". You can revist this tutorial anytime in settings."
        ]
        
        pager = UIPageControl()
        pager.setTranslatesAutoresizingMaskIntoConstraints(false)
        pager.pageIndicatorTintColor = UIColor.grayColor()
        pager.currentPageIndicatorTintColor = UIColor.whiteColor()
        
        
        gotItButton = UIButton()
        gotItButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        gotItButton.setTitle("got it".uppercaseString, forState: UIControlState.Normal)
        gotItButton.titleLabel?.font = ButtonFont
        gotItButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        gotItButton.hidden = true
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        scrollView.delegate = self
    
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        gotItButton.addTarget(self, action: "didTapGotItButton", forControlEvents: .TouchUpInside)
        
        view.addSubview(toolbar)
        view.addSubview(scrollView)
        view.addSubview(scrollView)
        
        toolbar.addSubview(pager)
        toolbar.addSubview(gotItButton)
        
        setupLayout()
    }
    
    var currentPage: Int {
        return Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
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
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        for index in 0...pageCount - 1 {
            loadPage(index)
        }
    }
    
    func loadPage(page: Int) {
        var keyboardWalkthroughView = KeyboardWalkthroughView()
        
        keyboardWalkthroughView.setTranslatesAutoresizingMaskIntoConstraints(false)
        keyboardWalkthroughView.iphoneImageView.image = pageImages[page]
        keyboardWalkthroughView.titleLabel.text = pageTitle[page]
        keyboardWalkthroughView.subtitleLabel.text = pagesubTitle[page]
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
        gotItButton.hidden = true
        
        SEGAnalytics.sharedAnalytics().track("app:installKeyboardSwipeToPage", properties: [
            "page": currentPage
        ])
        
        if currentPage == 4 {
            gotItButton.hidden = false
        }
    }

    
    func didTapGotItButton() {
        dismissViewControllerAnimated(true, completion: nil)
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
            
            pager.al_centerX == toolbar.al_centerX,
            pager.al_centerY == toolbar.al_centerY,
            
            scrollView.al_top == view.al_top + 20,
            scrollView.al_bottom == gotItButton.al_top - 50,
            scrollView.al_left == view.al_left + 20,
            scrollView.al_right == view.al_right - 20,
            
            
            gotItButton.al_width == 60,
            gotItButton.al_right == toolbar.al_right - 10,
            gotItButton.al_top == toolbar.al_top + 10,
            gotItButton.al_bottom == toolbar.al_bottom - 10
            ])
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
   }
