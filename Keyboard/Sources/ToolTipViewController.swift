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
    var pageImages: [UIImage]
    var pageTexts: [String]
    var pageViews: [ToolTip]
    var pointerAlignmentConstraint: NSLayoutConstraint?

    weak var delegate: ToolTipViewControllerDelegate?
    
    var currentPage: Int {        
        return Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
    }

    var tabWidth: CGFloat {
        return UIScreen.mainScreen().bounds.width / CGFloat(pageCount)
    }

    var arrowXOffset: CGFloat {
        return (tabWidth * CGFloat(currentPage + 1)) - (tabWidth / 2)
    }

    init() {
        pageWidth = UIScreen.mainScreen().bounds.width - 20
        
        pageImages = [
            UIImage(named: "tooltipimage1")!,
            UIImage(named: "tooltipimage2")!,
            UIImage(named: "tooltipimage4")!
        ]
        
        pageTexts = [
            "View all of your saved lyrics\n by tapping Favorites",
            "See lyrics you've previously\n sent by tapping Recents",
            "Discover top lyrics, songs &\n artists by tapping Search"
        ]
        
        pageViews = [ToolTip]()
        
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
        pageCount = 3
        
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("GOT IT", forState: .Normal)
        closeButton.setTitleColor(WhiteColor, forState: .Normal)
        closeButton.titleLabel?.font = UIFont(name: "Montserrat", size: 11.0)
        closeButton.backgroundColor = TealColor
        closeButton.layer.cornerRadius = 20.0
        closeButton.alpha = 0
        closeButton.userInteractionEnabled = false
        
        pointerImageView = UIImageView()
        pointerImageView.translatesAutoresizingMaskIntoConstraints = false
        pointerImageView.contentMode = .ScaleAspectFit
        pointerImageView.image = UIImage(named: "tooltippointer")
        
        super.init(nibName: nil, bundle: nil)
        
        scrollView.delegate = self
        
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        
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
    }
    
    func setupPages() {
        pageControl.numberOfPages = pageCount
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(pageCount),
            height: scrollView.frame.size.height)

        // Update the page control
        pageControl.currentPage = currentPage

        /// Load pages in our range
        for index in 0...pageCount - 1 {
            loadPage(index)
        }
    }
    
    func loadPage(page: Int) {
        let toolTip = ToolTip()
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

        delegate?.toolTipViewControllerCurrentPage(self, currentPage: currentPage)

        if currentPage == pageCount - 1 {
            closeButton.userInteractionEnabled = true
            
            UIView.animateWithDuration(0.3, animations: {
                self.closeButton.alpha = 1.0
                self.pageControl.alpha = 0
            })
        } else {
            closeButton.userInteractionEnabled = false
            
            UIView.animateWithDuration(0.3, animations: {
                self.closeButton.alpha = 0.0
                self.pageControl.alpha = 1
            })
        }

        pointerAlignmentConstraint?.constant = arrowXOffset
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func setupLayout() {
        pointerAlignmentConstraint = pointerImageView.al_centerX == view.al_left + arrowXOffset

        view.addConstraints([
            pageControl.al_centerX == scrollView.al_centerX,
            pageControl.al_bottom == scrollView.al_bottom - 18,
            pageControl.al_height == 5,

            scrollView.al_centerY == view.al_centerY,
            scrollView.al_width == view.al_width - 20,
            scrollView.al_height == view.al_height - 40,
            scrollView.al_left == view.al_left + 10,
            
            closeButton.al_bottom == pageControl.al_top + 10,
            closeButton.al_centerX == view.al_centerX,
            closeButton.al_height == 40,
            closeButton.al_width == 140,
            
            pointerImageView.al_top == view.al_top + 20,
            pointerAlignmentConstraint!,
            pointerImageView.al_height == 25,
            pointerImageView.al_width == 15
        ])
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

protocol ToolTipViewControllerDelegate: class {
    func toolTipViewControllerCurrentPage(toolTipViewController: ToolTipViewController, currentPage: Int)
}
