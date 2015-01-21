//
//  ViewController.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var pages = [WalkthroughPage]()
    var titles: [String]!
    var subtitles: [String]!
    var actionButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(fromHexString: "#f7f7f7")
        
//        var button = UIButton(frame: CGRectMake(100, 100, 400, 50))
//        button.setTitle("Open Settings", forState: UIControlState.Normal)
//        button.addTarget(self, action: "didTapButton", forControlEvents: UIControlEvents.TouchUpInside)
//        view.addSubview(button)
        
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
        
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.addSubview(actionButton)
        
        scrollView.frame = view.bounds
        createPages(titles.count)
        setupLayout()
    }
    
    func createPages(size: Int) {
        var frame = view.frame
        let pageWidth: CGFloat = CGRectGetWidth(frame)
        let pageHeight: CGFloat = CGRectGetHeight(frame)

        for var i = 0; i < size; i++ {
            var page = WalkthroughPage(frame: CGRectMake(pageWidth * CGFloat(i), 0, pageWidth, pageHeight))

            page.titleLabel.text = self.titles[i]
            page.subtitleLabel.text = subtitles[i]
            pages.append(page)
            scrollView.addSubview(page)
        }
        
        page1()
        
        scrollView.contentSize = CGSizeMake(pageWidth * CGFloat(size), pageHeight)
    }
    
    func page1() {
        var page = pages[0]
        
        var textImages = [
            UIImage(named: "text 1"),
            UIImage(named: "text 2"),
            UIImage(named: "text 3"),
            UIImage(named: "text 4"),
            UIImage(named: "text 5"),
            UIImage(named: "text 6"),
            UIImage(named: "text 7")
        ]
        
        var imageViews = [UIImageView]()
        
        var prevView: UIView = page.subtitleLabel
        var side: String
        for (i, image) in enumerate(textImages) {
            var imageView = UIImageView(image: image)
            imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
            page.addSubview(imageView)
            
            var constraints = [NSLayoutConstraint]()
            
            if i == 0 || i == 2 || i == 5 {
                constraints.append(imageView.al_left == page.al_left + 20)
                constraints.append(imageView.al_top == prevView.al_bottom + ((i == 0) ? 20 : 10))
                side = "left"
            } else {
                if i != 3 {
                    constraints.append(imageView.al_right == page.al_right - 20)
                }
                constraints.append(imageView.al_top == prevView.al_bottom + 10)
                side = "right"
            }
            
            constraints.append(imageView.al_width == image!.size.width)
            constraints.append(imageView.al_height == image!.size.height)
            
            page.addConstraints(constraints)
            
            imageViews.append(imageView)
            prevView = imageView
        }
        
        page.addConstraint(imageViews[3].al_leading == imageViews[4].al_leading)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var width = scrollView.frame.size.width
        var page = Int((scrollView.contentOffset.x + (0.5 * width)) / width);
        pageControl.currentPage = page
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

