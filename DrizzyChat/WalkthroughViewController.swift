//
//  ViewController.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

enum WalkthroughPageType: Int {
    case TextConvoPage = 0
    case AlbumCoverArtsPage
    case VideoTutorialPage
    case SignUpPage
    case ActionPage
}

class WalkthroughViewController: UIViewController, UIScrollViewDelegate {
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var pages = [WalkthroughPage]()
    var currentPage: Int!
    var titles: [String]!
    var subtitles: [String]!
    var actionButton = UIButton()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(fromHexString: "#f7f7f7")
        
        titles = [
            "Game Changing",
            "Curated Lyrics",
            "Install Drizzy",
            "Keep it 100, Sign Up",
            ""
        ]
        
        subtitles = [
            "Keep Drake in your pocket & let him do the talking for you",
            "Send the best Drizzy verses right from your keyboard",
            "Make sure you turn on \"full access\" so Drizzy can do his thing",
            "Connect to get access to new artists, lyrics & features.",
            ""
        ]
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        
        pageControl = UIPageControl()
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageControl.numberOfPages = titles.count
        pageControl.pageIndicatorTintColor = UIColor(fromHexString: "#b2b2b2")
        pageControl.currentPageIndicatorTintColor = UIColor(fromHexString: "#ffb61d")
        pageControl.currentPage = 0
        
        actionButton = UIButton()
        actionButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        actionButton.backgroundColor = UIColor(fromHexString: "#ffb61d")
        actionButton.setTitle("Continue", forState: .Normal)
        actionButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: 20)
        actionButton.titleLabel?.textColor = UIColor.whiteColor()
        actionButton.addTarget(self, action: "didTapContinueButton", forControlEvents: .TouchUpInside)

        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.addSubview(actionButton)
        
        scrollView.frame = view.bounds
        createPages(pageControl.numberOfPages)
        setupLayout()
    }
    
    func createPages(size: Int) {
        var frame = view.frame
        let pageWidth: CGFloat = CGRectGetWidth(frame)
        let pageHeight: CGFloat = CGRectGetHeight(frame)
        
        let classes: [WalkthroughPage.Type] = [
            TextConvoWalkthroughPage.self,
            AlbumCoverArtsWalkthroughPage.self,
            VideoTutorialWalkthroughPage.self,
            SignUpWalkthroughPage.self,
            ActionWalkthroughPage.self
        ]

        for var i = 0; i < size; i++ {
            let pageFrame = CGRectMake(pageWidth * CGFloat(i), 0, pageWidth, pageHeight)
            let WalkthroughPageClass = classes[i]
            var page: WalkthroughPage = WalkthroughPageClass(frame: pageFrame)

            page.titleLabel.text = self.titles[i]
            page.subtitleLabel.text = subtitles[i]
            pages.append(page)
            scrollView.addSubview(page)
        }

        scrollView.contentSize = CGSizeMake(pageWidth * CGFloat(size), pageHeight)
    }
    
    func didTapIntroButton() {
        scrollView.setContentOffset(CGPointZero, animated: true)
        pageControl.currentPage = 0
    }

    func setupLayout() {
        view.addConstraints([
            pageControl.al_top == view.al_top + 15,
            pageControl.al_height == 20,
            pageControl.al_left == view.al_left,
            pageControl.al_right == view.al_right,
            pageControl.al_width == view.al_width,
            pageControl.al_centerX == view.al_centerX,
            
            actionButton.al_bottom == view.al_bottom,
            actionButton.al_left == view.al_left,
            actionButton.al_right == view.al_right,
            actionButton.al_height == 50
        ])
    }
    
    func didTapButton() {
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    func didTapContinueButton() {
        let currentPage = pageControl.currentPage
        let nextPage = currentPage + 1
        let position = CGPointMake(CGFloat(nextPage) * CGRectGetWidth(scrollView.frame), 0)
        scrollView.setContentOffset(position, animated: true)
        pageControl.currentPage = nextPage
        
        pages[currentPage].pageWillHide()
        pages[currentPage].pageDidHide()
        
        pages[nextPage].pageWillShow()
        pages[nextPage].pageDidShow()
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var width = scrollView.frame.size.width
        var page = Int((scrollView.contentOffset.x + (0.5 * width)) / width);
        pageControl.currentPage = page
        
        pages[page].pageWillShow()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        pages[pageControl.currentPage].pageDidShow()
    }
    
    func pageDidChange(page: Int) {
        if page == 1 {
            var pageView = pages[1]
            
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

