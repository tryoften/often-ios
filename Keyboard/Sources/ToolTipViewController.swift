//
//  ToolTipViewController.swift
//  Often
//
//  Created by Komran Ghahremani on 9/25/15.
//  Copyright © 2015 Surf Inc. All rights reserved.
//

import UIKit

class ToolTipViewController: UIViewController, UIScrollViewDelegate {
    var closeButton: UIButton
    var nextIndicator: UIButton
    var loadingView: ToolTipLoadingView
    var pageWidth: CGFloat
    var scrollView: UIScrollView
    var pageControl: UIPageControl
    var pageCount: Int
    var pagesScrollViewSize: CGSize
    var pageImages: [UIImage]
    var pageTexts: [String]
    var pageViews: [ToolTip]
    weak var closeButtonDelegate: ToolTipCloseButtonDelegate?
    weak var delegate: ToolTipViewControllerDelegate?
    
    var currentPage: Int {
        return Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
    }
    
    init() {
        pageWidth = UIScreen.mainScreen().bounds.width - 20
        
        pageImages = [
            UIImage(named: "favoritesfadetooltip")!,
            UIImage(named: "iconstooltip")!,
            UIImage(named: "favoritestooltip")!,
            UIImage(named: "oftenbuttontooltip")!,
            UIImage(named: "fullaccesstooltip")!
        ]
        
        pageTexts = [
            "Find & Share whatever you're looking\n for by tapping on the search icon above.",
            "Use your favorite apps by typing\n #(appname) in the message space above.",
            "Save any link, song, video or GIF by\n tapping on a card & adding it to favorites.",
            "See all of your favorites by tapping\n the Often key. Easily edit them in-app.",
            "Remember to allow full-access for Often to\n work. We never access you private info!"
        ]
        
        pageViews = [ToolTip]()
        pageCount = 0
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.pagingEnabled = true
        scrollView.layer.cornerRadius = 3.0
        scrollView.backgroundColor = UIColor(fromHexString: "#121314")
        scrollView.showsHorizontalScrollIndicator = false
        
        pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPage = 0
        pageControl.transform = CGAffineTransformMakeScale(0.75, 0.75)
        pageControl.pageIndicatorTintColor = DarkGrey
        pageControl.currentPageIndicatorTintColor = TealColor
        
        pagesScrollViewSize = scrollView.frame.size
        pageCount = 5
        
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "close"), forState: UIControlState.Normal)
        closeButton.alpha = 0.0
        closeButton.userInteractionEnabled = false
        
        nextIndicator = UIButton()
        nextIndicator.translatesAutoresizingMaskIntoConstraints = false
        nextIndicator.setImage(UIImage(named: "next"), forState: UIControlState.Normal)
        
        loadingView = ToolTipLoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
        
        scrollView.delegate = self
        
        closeButton.addTarget(self, action: "closeTapped", forControlEvents: .TouchUpInside)
        nextIndicator.addTarget(self, action: "nextIndicatorTapped", forControlEvents: .TouchUpInside)
        
        view.backgroundColor = UIColor.grayColor()
        
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.addSubview(closeButton)
        view.addSubview(nextIndicator)
        view.addSubview(loadingView)
        // view.addSubview(caretImageView)
        
        setupLayout()
        
        loadingView.timedEndLoad()
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
            nextIndicator.userInteractionEnabled = false
            
            UIView.animateWithDuration(0.5, animations: {
                self.closeButton.alpha = 1.0
                self.nextIndicator.alpha = 0.0
            })
        } else {
            closeButton.userInteractionEnabled = false
            nextIndicator.userInteractionEnabled = true
            
            UIView.animateWithDuration(0.5, animations: {
                self.closeButton.alpha = 0.0
                self.nextIndicator.alpha = 1.0
            })
        }
    }
    
    func nextIndicatorTapped() {
        if currentPage < 4 {
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.x += self.scrollView.bounds.width
            })
        }
    }
    
    func setupLayout() {
        view.addConstraints([
            loadingView.al_left == scrollView.al_left,
            loadingView.al_right == scrollView.al_right,
            loadingView.al_top == scrollView.al_top,
            loadingView.al_bottom == scrollView.al_bottom,
            
            pageControl.al_centerX == scrollView.al_centerX,
            pageControl.al_bottom == scrollView.al_bottom - 18,
            pageControl.al_height == 5,
            
            scrollView.al_top == view.al_top + 10,
            scrollView.al_width == view.al_width - 20,
            scrollView.al_height == view.al_height - 80,
            scrollView.al_left == view.al_left + 10,
            
            closeButton.al_top == view.al_top + 25,
            closeButton.al_right == view.al_right - 25,
            closeButton.al_height == 10,
            closeButton.al_width == 10,
            
            nextIndicator.al_right == scrollView.al_right - 10,
            nextIndicator.al_centerY == scrollView.al_centerY + 5,
            nextIndicator.al_height == 20,
            nextIndicator.al_width == 13
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
