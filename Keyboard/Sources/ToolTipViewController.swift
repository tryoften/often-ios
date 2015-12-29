//
//  ToolTipViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 9/25/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class ToolTipViewController: UIViewController, UIScrollViewDelegate {
    var pointerImageView: UIImageView
    var closeButton: UIButton
    var pageWidth: CGFloat
    var scrollView: UIScrollView
    var pageControl: UIPageControl
    var pageCount: Int
    var pagesScrollViewSize: CGSize
    var pageImages: [UIImage]
    var pageTexts: [String]
    var pageViews: [ToolTip]
    var pointerAlignmentConstraint: NSLayoutConstraint?
    let screenWidth = UIScreen.mainScreen().bounds.width
    let tabWidth = UIScreen.mainScreen().bounds.width / 4
    weak var closeButtonDelegate: ToolTipCloseButtonDelegate?
    weak var delegate: ToolTipViewControllerDelegate?
    
    var currentPage: Int {        
        return Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
    }
    
    init() {
        pageWidth = UIScreen.mainScreen().bounds.width - 20
        
        pageImages = [
            UIImage(named: "tooltipimage1")!,
            UIImage(named: "tooltipimage2")!,
            UIImage(named: "tooltipimage3")!,
            UIImage(named: "tooltipimage4")!
        ]
        
        pageTexts = [
            "View all of your saved lyrics\n by tapping Favorites",
            "See lyrics you've previously\n sent by tapping Recents",
            "See top lyrics, songs &\n artists by tapping Browse",
            "Search for lyrics you want to\n add by tapping on Search"
        ]
        
        pageViews = [ToolTip]()
        pageCount = 0
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.pagingEnabled = true
        scrollView.backgroundColor = ClearColor
        scrollView.showsHorizontalScrollIndicator = false
        
        pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = DarkGrey
        pageControl.currentPageIndicatorTintColor = TealColor.colorWithAlphaComponent(0.75)
        
        pagesScrollViewSize = scrollView.frame.size
        pageCount = 4
        
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "close"), forState: UIControlState.Normal)
        closeButton.contentEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        closeButton.alpha = 0.0
        closeButton.userInteractionEnabled = false
        
        pointerImageView = UIImageView()
        pointerImageView.translatesAutoresizingMaskIntoConstraints = false
        pointerImageView.contentMode = .ScaleAspectFit
        pointerImageView.image = UIImage(named: "tooltippointer")
        
        super.init(nibName: nil, bundle: nil)
        
        scrollView.delegate = self
        
        closeButton.addTarget(self, action: "closeTapped", forControlEvents: .TouchUpInside)
        
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.addSubview(closeButton)
        view.addSubview(pointerImageView)
        
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
        let toolTip = ToolTip()
        delegate = toolTip
        toolTip.translatesAutoresizingMaskIntoConstraints = false
        toolTip.imageView.image = pageImages[page]
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
        
        if currentPage > 3 {
            closeButton.userInteractionEnabled = true
            
            UIView.animateWithDuration(0.3, animations: {
                self.closeButton.alpha = 1.0
            })
        } else {
            closeButton.userInteractionEnabled = false
            
            UIView.animateWithDuration(0.3, animations: {
                self.closeButton.alpha = 0.0
            })
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(currentPage)
        pointerAlignmentConstraint?.constant = ((screenWidth / 4) * CGFloat(pageControl.currentPage + 1)) - (tabWidth / 2)
        
        UIView.animateWithDuration(0.4, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func setupLayout() {
        pointerAlignmentConstraint = pointerImageView.al_centerX == view.al_left + ((screenWidth / 4) * CGFloat(pageControl.currentPage + 1)) - (tabWidth / 2)
        
        view.addConstraints([
            pageControl.al_centerX == scrollView.al_centerX,
            pageControl.al_bottom == scrollView.al_bottom - 18,
            pageControl.al_height == 5,

            scrollView.al_centerY == view.al_centerY,
            scrollView.al_width == view.al_width - 20,
            scrollView.al_height == view.al_height - 40,
            scrollView.al_left == view.al_left + 10,
            
            closeButton.al_top == scrollView.al_top + 5,
            closeButton.al_right == scrollView.al_right - 5,
            closeButton.al_height == 32,
            closeButton.al_width == 32,
            
            pointerImageView.al_top == view.al_top + 20,
            pointerAlignmentConstraint!,
            pointerImageView.al_height == 25,
            pointerImageView.al_width == 15
        ])
    }
    
    func closeTapped() {
        closeButtonDelegate?.toolTipCloseButtonDidTap()
    }
}

class CaretView: UIView {
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        drawPlayPathTo(context!, boundedBy: rect)
    }
    
    func drawPlayPathTo(context: CGContextRef, boundedBy rect: CGRect) {
        CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextMoveToPoint(context, rect.width / 4, rect.height / 4)
        CGContextAddLineToPoint(context, rect.width * 3 / 4, rect.height / 4)
        CGContextAddLineToPoint(context, rect.width / 2, rect.height * 3 / 4)
        CGContextAddLineToPoint(context, rect.width / 4, rect.height / 4)
        CGContextFillPath(context)
    }
}

protocol ToolTipCloseButtonDelegate: class {
    func toolTipCloseButtonDidTap()
}

protocol ToolTipViewControllerDelegate: class {
    func delegateCurrentPage(currentPage: Int)
}
