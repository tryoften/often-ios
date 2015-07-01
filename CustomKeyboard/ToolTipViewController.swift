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
    var delegate: ToolTipViewControllerDelegate?
    var pageWidth: CGFloat
    var scrollView: UIScrollView
    var pageControl: UIPageControl
    var pageCount: Int
    var pagesScrollViewSize: CGSize
    var pageImages: [UIImage]
    var pageTexts: [String]
    var pageViews: [ToolTip]
    
    var currentPage: Int {
       return Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
    }
    
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
            "Access artists by tapping\n their profile picture!",
            "Artist Categories can be reached\n by tapping the arrow",
            "Easily go right back to your regular\n keyboard by tapping the Globe icon",
            "To get the latest content, allow Full-Access\n fam! Learn more in your profile settings"
        ]
    
        pageViews = [ToolTip]()
        pageCount = 0
        
        scrollView = UIScrollView()
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView.pagingEnabled = true
        scrollView.layer.cornerRadius = 3.0
        scrollView.backgroundColor = UIColor(fromHexString: "#121314")
        scrollView.showsHorizontalScrollIndicator = false
        
        pageControl = UIPageControl()
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageControl.currentPage = 0
        
        
        pagesScrollViewSize = scrollView.frame.size
        pageCount = 4
        
        closeButton = UIButton()
        closeButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        closeButton.setImage(UIImage(named: "close artists"), forState: UIControlState.Normal)
        closeButton.alpha = 0.0
        
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
        //pageControl.currentPage = page

        /// Load pages in our range
        for index in 0...pageCount - 1 {
            loadPage(index)
        }
    }
    
    func loadPage(page: Int) {
        var toolTip = ToolTip()
        delegate = toolTip
        toolTip.setTranslatesAutoresizingMaskIntoConstraints(false)
        toolTip.imageView.image = toolTip.pageImages[page]
        toolTip.textView.text = pageTexts[page]
        toolTip.currentPage = page
        toolTip.setupLayout()
        scrollView.addSubview(toolTip)
        
        scrollView.addConstraints([
            toolTip.al_top == scrollView.al_top,
            toolTip.al_height == scrollView.al_height,
            toolTip.al_width == scrollView.al_width,
            toolTip.al_left == scrollView.al_left + pageWidth * CGFloat(page)
        ])
        
        pageViews.append(toolTip)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        /// Load the pages that are now on screen
        pageControl.currentPage = currentPage
        
        if currentPage > 2 {
            UIView.animateWithDuration(0.5, animations: {
                self.closeButton.alpha = 1.0
            })
        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.closeButton.alpha = 0.0
            })
        }
    }
    
    func setupLayout() {
        view.addConstraints([
            pageControl.al_centerX == scrollView.al_centerX,
            pageControl.al_bottom == scrollView.al_bottom - 18,
            pageControl.al_height == 5,
            
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

protocol ToolTipViewControllerDelegate {
    func delegateCurrentPage(currentPage: Int)
}
