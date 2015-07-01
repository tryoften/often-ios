//
//  ToolTipViewController.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/29/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

class ToolTipViewController: UIViewController, UIScrollViewDelegate {
    var viewModel: KeyboardViewModel
    
    var closeButton: UIButton
    var closeButtonDelegate: ToolTipCloseButtonDelegate?
    var pageWidth: CGFloat
    var scrollView: UIScrollView
    var pageControl: UIPageControl
    var pageCount: Int
    var pagesScrollViewSize: CGSize
    var pageImages: [UIImage]
    var pageTexts: [String]
    var pageViews: [ToolTip]
    
    init(viewModel: KeyboardViewModel) {
        
        pageWidth = UIScreen.mainScreen().bounds.width - 20
        self.viewModel = viewModel
        
        pageImages = [
            UIImage(named: "artists")!,
            UIImage(named: "categories")!,
            UIImage(named: "letters")!,
            UIImage(named: "full access")!
        ]
        
        pageTexts = [
            "Access artists by tapping their profile picture!",
            "Artist Categories can be reached by tapping the arrow",
            "Easily go right back to your regular keyboard by tapping the Globe icon",
            "To get the latest content, allow Full-Access fam! Learn more in your profile settings"
        ]
    
        pageViews = [ToolTip]()
        pageCount = 0
        
        scrollView = UIScrollView()
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView.pagingEnabled = true
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.showsHorizontalScrollIndicator = false
        
        pageControl = UIPageControl()
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageControl.currentPage = 0
        
        pagesScrollViewSize = scrollView.frame.size
        pageCount = 4
        
        closeButton = UIButton()
        closeButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        closeButton.setImage(UIImage(named: "close artists"), forState: UIControlState.Normal)
        
        super.init(nibName: nil, bundle: nil)
        
        scrollView.delegate = self
        
        closeButton.addTarget(self, action: "closeTapped", forControlEvents: UIControlEvents.TouchUpInside)
        
        view.backgroundColor = UIColor.grayColor()
        
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.addSubview(closeButton)
        
        setupLayout()
        
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
    
    func setupPages() {
        pageCount = pageImages.count
        pageControl.numberOfPages = pageCount

        scrollView.contentSize = CGSize(width: pageWidth  * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
    }
    
    func loadVisiblePages() {
        /// visible pages
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl.currentPage = page

        /// Load pages in our range
        for index in 0...pageCount - 1 {
            loadPage(index)
        }
    }
    
    func loadPage(page: Int) {
        var tooltip = ToolTip()
        tooltip.setTranslatesAutoresizingMaskIntoConstraints(false)
        tooltip.imageView.image = pageImages[page]
        tooltip.textView.text = pageTexts[page]
        scrollView.addSubview(tooltip)
        
        scrollView.addConstraints([
            tooltip.al_top == scrollView.al_top,
            tooltip.al_height == scrollView.al_height,
            tooltip.al_width == scrollView.al_width,
            tooltip.al_left == scrollView.al_left + pageWidth * CGFloat(page)
        ])
        
        pageViews.append(tooltip)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        /// Load the pages that are now on screen
        loadVisiblePages()
    }
    
    func closeTapped() {
        closeButtonDelegate?.toolTipCloseButtonDidTap()
    }
    
    func setupLayout() {
        view.addConstraints([
            pageControl.al_centerX == scrollView.al_centerX,
            pageControl.al_bottom == scrollView.al_bottom - 5,
            
            scrollView.al_top == view.al_top + 10,
            scrollView.al_width == view.al_width - 20,
            scrollView.al_height == view.al_height - 80,
            scrollView.al_left == view.al_left + 10,
            
            closeButton.al_top == view.al_top + 15,
            closeButton.al_right == view.al_right - 20
        ])
    }
}

protocol ToolTipCloseButtonDelegate {
    func toolTipCloseButtonDidTap()
}

