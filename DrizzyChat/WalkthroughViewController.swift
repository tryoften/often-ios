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

class WalkthroughViewController: UIViewController, UIScrollViewDelegate, WalkthroughPageDelegate {
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var pages = [WalkthroughPage]()
    var currentPage: Int!
    var previousPage: Int!
    var titles: [String]!
    var subtitles: [String]!
    var actionButton = UIButton()
    var pageWidth: CGFloat!

    var fbSession: FBSession! {
        didSet {
            switch(fbSession.state) {
            case .CreatedTokenLoaded:
                
                return
            default:
                break
            }
        }
    }
    
    private var previousPoint: CGPoint!
    private var currentPoint: CGPoint!
    private var pointDelta: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(fromHexString: "#f7f7f7")
        
        titles = [
            "Game Changing",
            "Curated Lyrics",
            "Install Drizzy",
            "Keep it 100, Sign Up"
        ]
        
        subtitles = [
            "Keep Drake in your pocket & let him do the talking for you",
            "Send the best Drizzy verses right from your keyboard",
            "Make sure you turn on \"full access\" so Drizzy can do his thing",
            "Connect to get access to new artists, lyrics & features."
        ]
        
        previousPage = -1
        currentPage = 0
        pointDelta = 0

        currentPoint = CGPointZero
        previousPoint = CGPointZero
        pageWidth = CGRectGetWidth(view.bounds)
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        
        pageControl = UIPageControl()
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageControl.numberOfPages = titles.count
        pageControl.pageIndicatorTintColor = UIColor(fromHexString: "#b2b2b2")
        pageControl.currentPageIndicatorTintColor = UIColor(fromHexString: "#ffb61d")
        pageControl.currentPage = currentPage
        
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
        createPages(titles.count)
        setupLayout()
    }
    
    func createPages(size: Int) {
        var frame = view.frame
        let pageHeight: CGFloat = CGRectGetHeight(frame)
        
        let classes: [WalkthroughPage.Type] = [
            TextConvoWalkthroughPage.self,
            AlbumCoverArtsWalkthroughPage.self,
            VideoTutorialWalkthroughPage.self,
            SignUpWalkthroughPage.self
        ]

        for var i = 0; i < size; i++ {
            let pageFrame = CGRectMake(pageWidth * CGFloat(i), 0, pageWidth, pageHeight)
            let WalkthroughPageClass = classes[i]
            var page: WalkthroughPage = WalkthroughPageClass(frame: pageFrame)

            page.delegate = self
            page.walkthroughViewController = self
            page.titleLabel.text = self.titles[i]
            page.subtitleLabel.text = subtitles[i]
            pages.append(page)
            scrollView.addSubview(page)
        }

        scrollView.contentSize = CGSizeMake(pageWidth * CGFloat(size), pageHeight)
    }
    
    func didTapIntroButton() {
        currentPage = 0
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
    
    func didTapContinueButton() {
        previousPage = currentPage
        currentPage = previousPage + 1

        let position = CGPointMake(CGFloat(currentPage) * CGRectGetWidth(scrollView.frame), 0)

        pageControl.currentPage = currentPage
        
        pages[previousPage].pageWillHide()
        pages[currentPage].pageWillShow()
        
        UIView.animateWithDuration(NSTimeInterval(0.3), animations: {
            self.scrollView.setContentOffset(position, animated: false)
        }, completion: { done in
            self.pages[self.previousPage].pageDidHide()
            self.pages[self.currentPage].pageDidShow()
        })
    }
    
    func getCurrentPage() -> Int {
        let width = pageWidth
        return Int((max(0, scrollView.contentOffset.x) + (0.5 * width)) / width)
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        currentPoint = scrollView.contentOffset
        pointDelta = currentPoint.x - previousPoint.x
        previousPoint = currentPoint
        
        let pos = currentPoint.x - CGFloat(pageWidth) * CGFloat(currentPage)
        
        for page in pages {
            page.scrollViewDidScroll(scrollView, position: pos)
        }
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let direction = pointDelta < 0 ? -1 : 1
        
        println("direction: \(direction), Point delta: \(pointDelta)")
        currentPage = getCurrentPage()
        
        pageControl.currentPage = currentPage
        previousPage = currentPage - direction
        
        if previousPage >= 0 && previousPage < pages.count {
            pages[previousPage].pageDidHide()
        }
        pages[currentPage].pageDidShow()

    }

    func userLoggedIn() {
        
    }
    
    func userLoggedOut() {
        
    }
    
    func getUserInfo(completion: (NSDictionary?, NSError?) -> ()) {
        var request = FBRequest.requestForMe()
        
        request.startWithCompletionHandler({ (connection, result, error) in
            
            if error == nil {
//                println("\(result)")
                var data = result as NSDictionary
                completion(data, nil)
            } else {
                completion(nil, error)
            }
            
        })
    }
    
    func presentHomeView(userInfo: NSDictionary?) {
        var homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        self.presentViewController(homeVC, animated: true, completion: nil)
    }
    
    func presentSignUpFormView(fbUser: PFUser?) {
        getUserInfo({ (result, error) in
            println("\(result)")
            var signUpFormViewController = SignUpFormViewController(nibName: nil, bundle: nil)
            
            if let user = fbUser {
                var firstName = result!["first_name"]! as String
                var lastName = result!["last_name"]! as String
                signUpFormViewController.nameField.text = "\(firstName) \(lastName)"
                signUpFormViewController.emailField.text = result!["email"] as String
            }
            
            var navigationController = UINavigationController(rootViewController: signUpFormViewController)
            
            let attributes: NSDictionary = [
                NSFontAttributeName: UIFont(name: "Lato-Regular", size: 14)!
            ]
            
            navigationController.navigationBar.titleTextAttributes = attributes
            self.presentViewController(navigationController, animated: true, completion: {})
        })
    }
    
    // MARK: WalkthroughPage
    
    func walkthroughPage(walkthroughPage: WalkthroughPage, shouldHideControls: Bool) {
        UIView.animateWithDuration(NSTimeInterval(0.3), animations: {
            self.actionButton.alpha = (shouldHideControls) ? 0.0 : 1.0
            self.pageControl.alpha = (shouldHideControls) ? 0.0 : 1.0
            }, completion: { done in
                
        })
    }
    

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

