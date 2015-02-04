//
//  ViewController.swift
//  DrizzyChat
//
//  Created by Luc Success on 11/12/14.
//  Copyright (c) 2014 Luc Success. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var pages = [WalkthroughPage]()
    var titles: [String]!
    var subtitles: [String]!
    var actionButton = UIButton()
    var videoPlayer: MPMoviePlayerController!

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
        page2()
        page3()
        page4()
        
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
        
        var topConstraints = [NSLayoutConstraint]()
        var imageViews = [UIImageView]()
        var prevDelay: NSTimeInterval = 0
        var prevView: UIView = page.subtitleLabel
        var side: String
        
        for (i, image) in enumerate(textImages) {
            var scaledImage = (isIPhone5()) ? UIImage(CGImage: image?.CGImage, scale: CGFloat(0.5), orientation: UIImageOrientation.Up) : image
            println("image: \(image!.size) scaledImage: \(scaledImage?.size)")
            var imageView = UIImageView(image: scaledImage)
            imageView.alpha = 0.0
            imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
            imageView.contentMode = .ScaleAspectFit
            page.addSubview(imageView)
            
            var constraints = [NSLayoutConstraint]()
            
            var topConstraint: NSLayoutConstraint!
//            
//            if isIPhone5() {
//                var frame = imageView.frame
//                frame.size.width -= 20
//                imageView.frame = frame
//            }
            
            if i == 0 || i == 2 || i == 5 {
                constraints.append(imageView.al_left == page.al_left + 20)
                topConstraint = imageView.al_top == prevView.al_bottom + ((i == 0) ? 125 : 115)
                constraints.append(topConstraint)
                side = "left"
            } else {
                if i != 3 {
                    constraints.append(imageView.al_right == page.al_right - 20)
                }
                topConstraint = imageView.al_top == prevView.al_bottom + 115
                constraints.append(topConstraint)
                side = "right"
            }
            
            constraints.append(imageView.al_width == image!.size.width)
            constraints.append(imageView.al_height == (isIPhone5() ? image!.size.height - 8 : image!.size.height))
            page.addConstraints(constraints)
            topConstraints.append(topConstraint)
            imageViews.append(imageView)
            prevView = imageView
        }
        
        page.addConstraint(imageViews[3].al_leading == imageViews[4].al_leading)
        
        for (i, imageView) in enumerate(imageViews) {
            var duration = NSTimeInterval(0.3)
            var delay = NSTimeInterval(i)
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDelay(delay)
            UIView.setAnimationDuration(duration)
            imageView.alpha = 1.0
            topConstraints[i].constant -= 105
            UIView.commitAnimations()
        }
    }
    
    func page2() {
        var page = pages[1]
    
        var images = [
            UIImage(named: "nothing was the same"),
            UIImage(named: "so far gone"),
            UIImage(named: "thank me later"),
            UIImage(named: "0 to 100"),
            UIImage(named: "take care"),
            UIImage(named: "trophies")
        ]
        var imageViews = [UIImageView]()
        
        var midX: CGFloat = CGRectGetWidth(page.frame) / 2
        var spacing: CGFloat = 2.5
        var prevPicLeft: UIImageView?
        var prevPicRight: UIImageView?
        for (i, image) in enumerate(images) {
            var imageView = UIImageView(image: image)
            imageView.alpha = 0.0
            imageView.sizeToFit()
            var fullHeight = CGFloat(CGRectGetHeight(imageView.frame))
            var fullWidth = CGFloat(CGRectGetWidth(imageView.frame))
            
            if prevPicRight == nil {
                imageView.center = CGPointMake(midX + fullWidth / 2 + spacing,
                    CGFloat(300))
                prevPicRight = imageView
            } else if prevPicLeft == nil {
                imageView.center = CGPointMake(midX - fullWidth / 2 - spacing,
                    CGFloat(320))
                prevPicLeft = imageView
            } else {
                if i % 2 == 0 {
                    imageView.frame = CGRectMake(midX + spacing, CGFloat(CGRectGetMaxY(prevPicRight!.frame) + spacing), CGRectGetWidth(prevPicRight!.frame), CGRectGetHeight(prevPicRight!.frame))
//                    imageView.center = CGPointMake(midX + halfWidth + spacing,
//                        CGFloat(CGRectGetMaxY(prevPicRight!.frame) + CGRectGetHeight(prevPicRight!.frame) / 2 + spacing))
                    prevPicRight = imageView
                } else {
                    imageView.frame = CGRectMake(midX - fullWidth - spacing, CGFloat(CGRectGetMaxY(prevPicLeft!.frame) + spacing), CGRectGetWidth(prevPicLeft!.frame), CGRectGetHeight(prevPicLeft!.frame))
//                    imageView.center = CGPointMake(midX - halfWidth - spacing,
//                        CGFloat(CGRectGetMaxY(prevPicLeft!.frame) + CGRectGetHeight(prevPicLeft!.frame) / 2 + spacing))
                    prevPicLeft = imageView
                }
            }
            
//            imageView.center = CGPointMake(imageView.center.x, imageView.center.y + 100)
            page.addSubview(imageView)
            
            imageViews.append(imageView)
        }
        
        page.imageViews = imageViews
    }
    
    func page3() {
        var page = pages[2]
        
        var urlPath = NSBundle.mainBundle().pathForResource("tutorial-video", ofType: "mov")
        println("\(urlPath)")
        videoPlayer = MPMoviePlayerController(contentURL: NSURL.fileURLWithPath(urlPath!))
        videoPlayer.controlStyle = .None
        videoPlayer.repeatMode = .One

        var pageWidth = CGRectGetWidth(page.frame)
        var width = pageWidth * 0.7
        
        videoPlayer.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        page.addSubview(videoPlayer.view)
        
        page.addConstraints([
            videoPlayer.view.al_top == page.subtitleLabel.al_bottom + 30,
            videoPlayer.view.al_width == width,
            videoPlayer.view.al_height == CGRectGetHeight(page.frame) * 0.7,
            videoPlayer.view.al_centerX == page.al_centerX
        ])
    }
    
    func page4() {
        var page = pages[3]
        var covers = [UIImageView]()
        
        var cover1 = UIImageView(image: UIImage(named: "kanye"))
        var cover2 = UIImageView(image: UIImage(named: "kendrick"))
        var cover3 = UIImageView(image: UIImage(named: "tswift"))
        
        covers += [cover1, cover2, cover3]
        
        for cover in covers {
            cover.setTranslatesAutoresizingMaskIntoConstraints(false)
        }
        
        page.addSubview(cover2)
        page.addSubview(cover3)
        page.addSubview(cover1)
        
        var loginView = FBLoginView()
        loginView.setTranslatesAutoresizingMaskIntoConstraints(false)
        page.addSubview(loginView)
        
        page.addConstraints([
            cover1.al_top == page.subtitleLabel.al_bottom + 100,
            cover1.al_centerX == page.al_centerX,
            cover1.al_width == CGRectGetWidth(cover1.frame),
            cover1.al_height == CGRectGetHeight(cover1.frame),
            
            cover2.al_width == cover1.al_width * 0.9,
            cover2.al_height == cover1.al_height * 0.9,
            cover2.al_centerY == cover1.al_centerY,
            cover2.al_centerX == cover1.al_centerX - 50,
            
            cover3.al_width == cover1.al_width * 0.9,
            cover3.al_height == cover1.al_height * 0.9,
            cover3.al_centerY == cover1.al_centerY,
            cover3.al_centerX == cover1.al_centerX + 50,
            
            loginView.al_top == cover1.al_bottom + 20,
            loginView.al_centerX == page.al_centerX,
            loginView.al_width == CGRectGetWidth(loginView.frame),
            loginView.al_height == CGRectGetHeight(loginView.frame)
        ])
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
        var nextPage = pageControl.currentPage + 1
        var position = CGPointMake(CGFloat(nextPage) * CGRectGetWidth(scrollView.frame), 0)
        scrollView.setContentOffset(position, animated: true)
        pageControl.currentPage = nextPage
        
        if nextPage == 4 {
            var homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
            self.presentViewController(homeVC, animated: true, completion: nil)
        }
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
        
        if page == 1 {
            var pageView = pages[1]
            
            for (i, imageView) in enumerate(pageView.imageViews!) {
                imageView.alpha = 0.0
                imageView.center = CGPointMake(imageView.center.x, imageView.center.y + 100)
                UIView.animateKeyframesWithDuration(NSTimeInterval(0.3), delay: NSTimeInterval(i) * 0.3, options: nil, animations: {
                    imageView.alpha = 1.0
                    imageView.center = CGPointMake(imageView.center.x, imageView.center.y - 100)
                }, completion: nil)
            }
        } else if page == 2 {
//            videoPlayer.play()
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

