//
//  TrendingHeaderView.swift
//  Drizzy
//
//  Created by Komran Ghahremani on 6/9/15.
//  Copyright (c) 2015 Luc Success. All rights reserved.
//

import UIKit

/**
    TrendingHeaderView:

    Header view of the Trending view that displays:
    
    - Artist Cover Photo
    - Artist Name
    - Featured Button

*/

class TrendingHeaderView: UICollectionReusableView, UIScrollViewDelegate {
    @IBOutlet var featuredButton: UIButton?
    @IBOutlet var scrollView: UIScrollView?
    @IBOutlet var pageControl: UIPageControl?
    @IBOutlet var nameLabel: UILabel?
    
    var screenWidth: CGFloat
    var pageCount: Int
    var pagesScrollViewSize: CGSize
    
    /// testing
    var pageImages: [UIImage] = [
        UIImage(named: "rome-fortune")!,
        UIImage(named: "chance-the-rapper")!,
        UIImage(named: "meek-mill")!
    ]
    
    var pageViews: [UIImageView?] = []
    
    override init(frame: CGRect) {
        screenWidth = UIScreen.mainScreen().bounds.width
        
        pageCount = pageImages.count
        
        scrollView = UIScrollView(frame: CGRectMake(0, 0, screenWidth, 320))
        scrollView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView?.pagingEnabled = true
        
        pageControl = UIPageControl()
        pageControl?.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageControl?.currentPage = 0
        pageControl?.numberOfPages = pageCount
        
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        pagesScrollViewSize = scrollView!.frame.size
        scrollView?.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
        
        nameLabel = UILabel()
        nameLabel?.textAlignment = .Center
        nameLabel?.font = UIFont(name: "Oswald-Light", size: 24.0)
        nameLabel?.textColor = UIColor.whiteColor()
        nameLabel?.setTranslatesAutoresizingMaskIntoConstraints(false)
        nameLabel?.text = "R O M E  F O R T U N E"
        
        featuredButton = UIButton(frame: CGRectMake(0.0, 0.0, 85.0, 10.0))
        featuredButton?.setTranslatesAutoresizingMaskIntoConstraints(false)
        featuredButton?.setTitle("FEATURED", forState: UIControlState.Normal)
        featuredButton?.titleLabel?.font = UIFont(name: "OpenSans", size: 10.0)
        featuredButton?.backgroundColor = UIColor.whiteColor()
        featuredButton?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        super.init(frame: frame)
        
        scrollView?.delegate = self
        loadVisiblePages()
        
        backgroundColor = UIColor.blackColor()
        
        /// addSubview(coverPhoto)
        addSubview(scrollView!)
        addSubview(pageControl!)
        addSubview(nameLabel!)
        addSubview(featuredButton!)
        
        setLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadVisiblePages() {
        /// visible pages
        let pageWidth = scrollView!.frame.size.width
        let page = Int(floor((scrollView!.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl!.currentPage = page
        if page == 0 {
            nameLabel?.text = "R O M E  F O R T U N E"
        } else if page == 1 {
            nameLabel?.text = "C H A N C E  T H E  R A P P E R"
        } else if page == 2 {
            nameLabel?.text = "M E E K  M I L L"
        }
        
        /// Which page to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        /// Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        /// Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        /// Purge anything after the last page
        for var index = lastPage + 1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }
    
    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            /// If it's outside the range of what you have to display, then do nothing
            return
        }
        
        if let pageView = pageViews[page] {
            /// view already loaded
        } else {
            /// frame of content is the size of the header
            var frame = scrollView!.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            /// new image view to be placed inside of the content area just made
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            scrollView!.addSubview(newPageView)
            
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page: Int) {
        if page < 0 || page >= pageImages.count {
            /// If it's outside the range of what you have to display, then do nothing
            return
        }
        
        /// Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        /// Load the pages that are now on screen
        loadVisiblePages()
    }
    
    func setLayout() {
        addConstraints([
            nameLabel!.al_top == al_top + 100,
            nameLabel!.al_width == 280,
            nameLabel!.al_centerX == al_centerX,
            featuredButton!.al_height == 20,
            featuredButton!.al_width == 70,
            featuredButton!.al_top == nameLabel!.al_bottom + 5,
            featuredButton!.al_centerX == nameLabel!.al_centerX,
            pageControl!.al_left == al_left + 172,
            pageControl!.al_top == al_top + 210,
            scrollView!.al_top == al_top - 35,
            scrollView!.al_width == screenWidth,
            scrollView!.al_height == 320
        ])
    }
}
